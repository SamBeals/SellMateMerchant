import Foundation

@MainActor
final class MachineInventoryViewModel: ObservableObject {
    unowned let app: AppViewModel
    @Published var rows: [InventoryRow] = []

    init(app: AppViewModel) {
        self.app = app
    }

    func load() async {
        guard let machineId = app.machines.first?.id else { return }
        do {
            let slots = try await app.service.fetchInventory(machineId: machineId)
            let productMap = Dictionary(uniqueKeysWithValues: app.products.map { ($0.id, $0) })
            rows = slots.map { slot in
                InventoryRow(id: slot.id, slotId: slot.id, product: productMap[slot.productId], qty: slot.qty, enabled: slot.enabled)
            }.sorted { $0.slotId < $1.slotId }
        } catch {
            print("Load inventory error: \(error)")
        }
    }

    func adjustQuantity(slotId: String, delta: Int) async {
        guard let machineId = app.machines.first?.id,
              let idx = rows.firstIndex(where: { $0.slotId == slotId }) else { return }
        let newQty = max(0, rows[idx].qty + delta)
        rows[idx] = InventoryRow(id: rows[idx].id, slotId: rows[idx].slotId, product: rows[idx].product, qty: newQty, enabled: rows[idx].enabled)
        try? await app.service.updateInventory(machineId: machineId, slotId: slotId, qty: newQty, enabled: rows[idx].enabled)
    }

    func toggleEnabled(slotId: String, enabled: Bool) async {
        guard let machineId = app.machines.first?.id,
              let idx = rows.firstIndex(where: { $0.slotId == slotId }) else { return }
        rows[idx] = InventoryRow(id: rows[idx].id, slotId: rows[idx].slotId, product: rows[idx].product, qty: rows[idx].qty, enabled: enabled)
        try? await app.service.updateInventory(machineId: machineId, slotId: slotId, qty: rows[idx].qty, enabled: enabled)
    }
}
