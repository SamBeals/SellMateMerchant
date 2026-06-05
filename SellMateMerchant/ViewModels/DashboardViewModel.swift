import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    unowned let app: AppViewModel

    init(app: AppViewModel) {
        self.app = app
    }

    var machineName: String { app.machines.first?.displayName ?? "No machine" }
    var totalInventoryCount: Int { app.machineInventoryViewModel.rows.map(\.qty).reduce(0, +) }
    var lowStockCount: Int { app.machineInventoryViewModel.rows.filter { $0.qty <= 3 }.count }
}
