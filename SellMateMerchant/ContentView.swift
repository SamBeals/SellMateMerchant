import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appViewModel: AppViewModel

    var body: some View {
        TabView {
            NavigationStack {
                DashboardView(viewModel: appViewModel.dashboardViewModel)
            }
            .tabItem {
                Label("Dashboard", systemImage: "chart.bar")
            }

            NavigationStack {
                MachineInventoryView(viewModel: appViewModel.machineInventoryViewModel)
            }
            .tabItem {
                Label("Inventory", systemImage: "shippingbox")
            }

            NavigationStack {
                MasterProductsView(viewModel: appViewModel.masterProductsViewModel)
            }
            .tabItem {
                Label("Products", systemImage: "list.bullet.rectangle")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
