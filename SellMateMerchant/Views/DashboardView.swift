import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        List {
            Section("Machine") {
                Text(viewModel.machineName)
            }
            Section("Inventory") {
                HStack {
                    Text("Total units")
                    Spacer()
                    Text("\(viewModel.totalInventoryCount)")
                }
                HStack {
                    Text("Low stock slots")
                    Spacer()
                    Text("\(viewModel.lowStockCount)")
                }
            }
        }
        .navigationTitle("Dashboard")
    }
}
