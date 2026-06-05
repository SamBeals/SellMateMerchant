import Foundation
import Combine

@MainActor
final class SalesViewModel: ObservableObject {
    unowned let app: AppViewModel
    @Published private(set) var sales: [Sale] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    init(app: AppViewModel) {
        self.app = app
    }

    func load() async {
        guard let machineId = app.machines.first?.id else { return }
        let now = Date()
        let startOfMonth = SalesMetricCalculator(calendar: .current).start(of: .month, for: now)
        isLoading = true
        defer { isLoading = false }
        do {
            sales = try await app.service.fetchSales(machineId: machineId, since: startOfMonth)
            errorMessage = nil
        } catch {
            errorMessage = String(describing: error)
        }
    }

    var todayRevenueCents: Int { revenueCents(for: .day) }
    var weeklyRevenueCents: Int { revenueCents(for: .weekOfYear) }
    var monthlyRevenueCents: Int { revenueCents(for: .month) }
    var todayTotalCents: Int { todayRevenueCents }
    var todayOrderCount: Int { sales(for: .day).count }
    var todayItemsSold: Int { sales(for: .day).flatMap { $0.items }.reduce(0) { $0 + $1.qty } }

    var todayRevenueText: String { currencyText(for: todayRevenueCents) }
    var weeklyRevenueText: String { currencyText(for: weeklyRevenueCents) }
    var monthlyRevenueText: String { currencyText(for: monthlyRevenueCents) }

    func currencyText(for cents: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        let amount = NSDecimalNumber(value: cents).dividing(by: NSDecimalNumber(value: 100))
        return formatter.string(from: amount) ?? "$0.00"
    }

    private func revenueCents(for component: Calendar.Component) -> Int {
        SalesMetricCalculator(calendar: .current).revenueCents(from: sales, in: component, containing: Date())
    }

    private func sales(for component: Calendar.Component) -> [Sale] {
        SalesMetricCalculator(calendar: .current).sales(from: sales, in: component, containing: Date())
    }
}

struct SalesMetricCalculator {
    let calendar: Calendar

    func start(of component: Calendar.Component, for date: Date) -> Date {
        calendar.dateInterval(of: component, for: date)?.start ?? calendar.startOfDay(for: date)
    }

    func sales(from sales: [Sale], in component: Calendar.Component, containing date: Date) -> [Sale] {
        guard let interval = calendar.dateInterval(of: component, for: date) else { return [] }
        return sales.filter { sale in
            sale.timestamp >= interval.start && sale.timestamp < interval.end
        }
    }

    func revenueCents(from sales: [Sale], in component: Calendar.Component, containing date: Date) -> Int {
        self.sales(from: sales, in: component, containing: date).reduce(0) { $0 + $1.totalCents }
    }
}
