import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        List {
            Section("Machine") {
                Text(viewModel.machineName)
            }
            Section("Revenue") {
                HStack { Text("Today"); Spacer(); Text(viewModel.app.salesViewModel.todayRevenueText) }
                HStack { Text("This Week"); Spacer(); Text(viewModel.app.salesViewModel.weeklyRevenueText) }
                HStack { Text("This Month"); Spacer(); Text(viewModel.app.salesViewModel.monthlyRevenueText) }
            }
            Section("Today") {
                HStack { Text("Orders"); Spacer(); Text("\(viewModel.app.salesViewModel.todayOrderCount)") }
                HStack { Text("Items Sold"); Spacer(); Text("\(viewModel.app.salesViewModel.todayItemsSold)") }
            }
            if viewModel.app.salesViewModel.sales.isEmpty {
                Section {
                    ContentUnavailableView("No Sales Yet", systemImage: "chart.bar", description: Text("Sales will appear here as they happen."))
                }
            } else {
                Section("Recent") {
                    ForEach(viewModel.app.salesViewModel.sales.prefix(5)) { sale in
                        HStack {
                            Text(sale.timestamp, style: .time)
                            Spacer()
                            Text(viewModel.app.salesViewModel.currencyText(for: sale.totalCents))
                        }
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
        .task { await viewModel.app.salesViewModel.load() }
    }
}
