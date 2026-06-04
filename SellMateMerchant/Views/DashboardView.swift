import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        List {
            Section("Machine") {
                Text(viewModel.machineName)
            }
            Section("Today") {
                HStack { Text("Sales"); Spacer(); Text("$\(Double(viewModel.app.salesViewModel.todayTotalCents)/100, specifier: "%.2f")") }
                HStack { Text("Orders"); Spacer(); Text("\(viewModel.app.salesViewModel.todayOrderCount)") }
                HStack { Text("Items Sold"); Spacer(); Text("\(viewModel.app.salesViewModel.todayItemsSold)") }
            }
            if viewModel.app.salesViewModel.sales.isEmpty {
                Section {
                    ContentUnavailableView("No Sales Yet", systemImage: "chart.bar") {
                        Text("Sales will appear here as they happen.")
                    }
                }
            } else {
                Section("Recent") {
                    ForEach(viewModel.app.salesViewModel.sales.prefix(5)) { sale in
                        HStack {
                            Text(sale.timestamp, style: .time)
                            Spacer()
                            Text("$\(Double(sale.totalCents)/100, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
        .task { await viewModel.app.salesViewModel.load() }
    }
}
