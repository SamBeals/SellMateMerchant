import Foundation

@MainActor
final class MachineInventoryViewModel: ObservableObject {
    unowned let app: AppViewModel
    @Published var rows: [InventoryRow] = []
    @Published private(set) var originalRows: [InventoryRow] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?

    var hasUnsavedChanges: Bool { rows != originalRows }

    init(app: AppViewModel) {
        self.app = app
    }

    func load() async {
        guard let machineId = app.machines.first?.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let slots = try await app.service.fetchInventory(machineId: machineId)
            let productMap = Dictionary(uniqueKeysWithValues: app.products.map { ($0.id, $0) })
            let mapped = slots.map { slot in
                InventoryRow(id: slot.id, slotId: slot.id, product: productMap[slot.productId], qty: slot.qty, enabled: slot.enabled)
            }.sorted { $0.slotId < $1.slotId }
            self.rows = mapped
            self.originalRows = mapped
            self.errorMessage = nil
        } catch {
            self.errorMessage = String(describing: error)
        }
    }

    func adjustQuantity(slotId: String, delta: Int) async {
        guard let idx = rows.firstIndex(where: { $0.slotId == slotId }) else { return }
        let newQty = max(0, rows[idx].qty + delta)
        rows[idx] = InventoryRow(id: rows[idx].id, slotId: rows[idx].slotId, product: rows[idx].product, qty: newQty, enabled: rows[idx].enabled)
    }

    func toggleEnabled(slotId: String, enabled: Bool) async {
        guard let idx = rows.firstIndex(where: { $0.slotId == slotId }) else { return }
        rows[idx] = InventoryRow(id: rows[idx].id, slotId: rows[idx].slotId, product: rows[idx].product, qty: rows[idx].qty, enabled: enabled)
    }

    func saveChanges() async {
        guard let machineId = app.machines.first?.id else { return }
        isSaving = true
        defer { isSaving = false }
        do {
            let byId = Dictionary(uniqueKeysWithValues: rows.map { ($0.slotId, $0) })
            let originalById = Dictionary(uniqueKeysWithValues: originalRows.map { ($0.slotId, $0) })
            for (slotId, row) in byId {
                let original = originalById[slotId]
                if original?.qty != row.qty || original?.enabled != row.enabled {
                    try await app.service.updateInventory(machineId: machineId, slotId: slotId, qty: row.qty, enabled: row.enabled)
                }
            }
            originalRows = rows
            errorMessage = nil
        } catch {
            errorMessage = String(describing: error)
        }
    }

    func discardChanges() {
        rows = originalRows
    }
}
