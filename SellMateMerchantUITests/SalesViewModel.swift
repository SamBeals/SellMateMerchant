import Foundation

@MainActor
final class SalesViewModel: ObservableObject {
    unowned let app: AppViewModel
    @Published private(set) var sales: [Sale] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    init(app: AppViewModel) { self.app = app }

    func load() async {
        guard let machineId = app.machines.first?.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            sales = try await app.service.fetchSales(machineId: machineId, since: Calendar.current.startOfDay(for: Date()))
            errorMessage = nil
        } catch {
            errorMessage = String(describing: error)
        }
    }

    var todayTotalCents: Int { sales.reduce(0) { $0 + $1.totalCents } }
    var todayOrderCount: Int { sales.count }
    var todayItemsSold: Int { sales.flatMap { $0.items }.reduce(0) { $0 + $1.qty } }
}
