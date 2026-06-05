import Foundation
import Testing
@testable import SellMateMerchant

struct SalesDashboardMetricsTests {
    @Test func revenueMetricsRespectCalendarPeriodBoundaries() {
        let calendar = gregorianUTC
        let now = date(year: 2026, month: 6, day: 18, hour: 12)
        let sales = [
            makeSale(id: "today-a", timestamp: date(year: 2026, month: 6, day: 18, hour: 9), totalCents: 1_000),
            makeSale(id: "today-b", timestamp: date(year: 2026, month: 6, day: 18, hour: 11), totalCents: 2_500),
            makeSale(id: "week", timestamp: date(year: 2026, month: 6, day: 16, hour: 10), totalCents: 3_000),
            makeSale(id: "month", timestamp: date(year: 2026, month: 6, day: 2, hour: 15), totalCents: 4_000),
            makeSale(id: "prior-month", timestamp: date(year: 2026, month: 5, day: 31, hour: 23), totalCents: 8_000)
        ]
        let calculator = SalesMetricCalculator(calendar: calendar)

        #expect(calculator.revenueCents(from: sales, in: .day, containing: now) == 3_500)
        #expect(calculator.revenueCents(from: sales, in: .weekOfYear, containing: now) == 6_500)
        #expect(calculator.revenueCents(from: sales, in: .month, containing: now) == 10_500)
    }

    @Test func revenueUsesSaleTotalRatherThanLineItems() {
        let calendar = gregorianUTC
        let now = date(year: 2026, month: 6, day: 18, hour: 12)
        let sale = Sale(
            id: "sale-with-discount",
            orderId: "1001",
            machineId: "machine001",
            timestamp: now,
            items: [
                SaleItem(id: "item-1", slotId: "A1", productId: "water", qty: 1, amountCents: 500),
                SaleItem(id: "item-2", slotId: "B2", productId: "chips", qty: 1, amountCents: 500)
            ],
            totalCents: 750
        )
        let calculator = SalesMetricCalculator(calendar: calendar)

        #expect(calculator.revenueCents(from: [sale], in: .day, containing: now) == 750)
    }

    @Test func monthStartIsUsedForSalesFetchWindow() {
        let calendar = gregorianUTC
        let now = date(year: 2026, month: 6, day: 18, hour: 12)
        let calculator = SalesMetricCalculator(calendar: calendar)

        #expect(calculator.start(of: .month, for: now) == date(year: 2026, month: 6, day: 1, hour: 0))
    }

    private var gregorianUTC: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 2
        return calendar
    }

    private func date(year: Int, month: Int, day: Int, hour: Int) -> Date {
        var components = DateComponents()
        components.calendar = gregorianUTC
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        return components.date!
    }

    private func makeSale(id: String, timestamp: Date, totalCents: Int) -> Sale {
        Sale(
            id: id,
            orderId: id,
            machineId: "machine001",
            timestamp: timestamp,
            items: [
                SaleItem(id: "\(id)-item", slotId: "A1", productId: "water", qty: 1, amountCents: totalCents)
            ],
            totalCents: totalCents
        )
    }
}
