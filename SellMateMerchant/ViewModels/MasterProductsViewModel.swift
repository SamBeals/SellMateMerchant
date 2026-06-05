import Foundation
import Combine

@MainActor
final class MasterProductsViewModel: ObservableObject {
    unowned let app: AppViewModel
    @Published var working: [Product] = []
    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?
    var hasUnsavedChanges: Bool { 
        working.map(\.id) != app.products.map(\.id) || 
        !zip(working, app.products.sorted { $0.name < $1.name }).allSatisfy { 
            $0.name == $1.name && $0.priceCents == $1.priceCents && $0.imageUrl == $1.imageUrl && $0.active == $1.active 
        } 
    }

    init(app: AppViewModel) {
        self.app = app
    }

    var products: [Product] { app.products.sorted { $0.name < $1.name } }

    func load() {
        working = products
    }
    
    func update(productId: String, name: String? = nil, priceCents: Int? = nil, imageUrl: String? = nil, active: Bool? = nil) {
        guard let idx = working.firstIndex(where: { $0.id == productId }) else { return }
        let p = working[idx]
        working[idx] = Product(id: p.id, name: name ?? p.name, priceCents: priceCents ?? p.priceCents, imageUrl: imageUrl ?? p.imageUrl, active: active ?? p.active)
    }
    
    func saveChanges() async {
        // TODO: Define and implement master inventory update API in InventoryService when schema is finalized.
        // For now, just refresh from service to clear any local diffs after an add.
        await app.refreshProducts()
        load()
    }

    func addProduct(name: String, priceText: String, imageUrl: String, active: Bool) async {
        guard let merchantId = app.merchant?.id else { return }
        let priceCents = Int((Double(priceText) ?? 0) * 100)
        do {
            try await app.service.addProduct(merchantId: merchantId, name: name, priceCents: priceCents, imageUrl: imageUrl, active: active)
            await app.refreshProducts()
            load()
        } catch {
            print("Add product error: \(error)")
        }
    }
}
