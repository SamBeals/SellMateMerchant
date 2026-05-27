import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    let service: InventoryServiceProtocol

    @Published private(set) var merchant: Merchant?
    @Published private(set) var machines: [Machine] = []
    @Published private(set) var products: [Product] = []

    lazy var dashboardViewModel = DashboardViewModel(app: self)
    lazy var machineInventoryViewModel = MachineInventoryViewModel(app: self)
    lazy var masterProductsViewModel = MasterProductsViewModel(app: self)

    init(service: InventoryServiceProtocol = InventoryService()) {
        self.service = service
        FirebaseManager.configure()
    }

    func bootstrap() async {
        do {
            let uid = try await service.bootstrapSession()
            let merchant = try await service.fetchMerchant(for: uid)
            let machines = try await service.fetchMachines(merchantId: merchant.id)
            let products = try await service.fetchProducts(merchantId: merchant.id)
            self.merchant = merchant
            self.machines = machines
            self.products = products
            await machineInventoryViewModel.load()
        } catch {
            print("Bootstrap error: \(error)")
        }
    }

    func refreshProducts() async {
        guard let merchantId = merchant?.id else { return }
        do {
            products = try await service.fetchProducts(merchantId: merchantId)
            await machineInventoryViewModel.load()
        } catch {
            print("Refresh products error: \(error)")
        }
    }
}
