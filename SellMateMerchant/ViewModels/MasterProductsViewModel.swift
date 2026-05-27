import Foundation

@MainActor
final class MasterProductsViewModel: ObservableObject {
    unowned let app: AppViewModel

    init(app: AppViewModel) {
        self.app = app
    }

    var products: [Product] { app.products.sorted { $0.name < $1.name } }

    func addProduct(name: String, priceText: String, imageUrl: String, active: Bool) async {
        guard let merchantId = app.merchant?.id else { return }
        let priceCents = Int((Double(priceText) ?? 0) * 100)
        do {
            try await app.service.addProduct(merchantId: merchantId, name: name, priceCents: priceCents, imageUrl: imageUrl, active: active)
            await app.refreshProducts()
        } catch {
            print("Add product error: \(error)")
        }
    }
}
