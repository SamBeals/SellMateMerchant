import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    let service: InventoryServiceProtocol

    @Published private(set) var merchant: Merchant?
    @Published private(set) var machines: [Machine] = []
    @Published private(set) var products: [Product] = []
    @Published private(set) var sales: [Sale] = []

    lazy var dashboardViewModel = DashboardViewModel(app: self)
    lazy var machineInventoryViewModel = MachineInventoryViewModel(app: self)
    lazy var masterProductsViewModel = MasterProductsViewModel(app: self)
    lazy var salesViewModel = SalesViewModel(app: self)

    convenience init() {
        self.init(service: InventoryService())
    }

    init(service: InventoryServiceProtocol) {
        self.service = service
        FirebaseManager.configure()
    }

    func bootstrap() async {
        do {
            let uid = try await service.bootstrapSession()
            let merchant = try await service.fetchMerchant(for: uid)
            self.merchant = merchant
            // Hardcode machine001 for MVP; in future fetch machines by merchant.
            let machine = Machine(id: "machine001", merchantId: merchant.id, displayName: "Machine 001", location: "", status: "online")
            self.machines = [machine]
            let products = try await service.fetchProducts(merchantId: merchant.id)
            self.products = products
            self.sales = try await service.fetchSales(machineId: machine.id, since: Calendar.current.startOfDay(for: Date()))
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
    
    func refreshSales() async {
        guard let machineId = machines.first?.id else { return }
        do {
            sales = try await service.fetchSales(machineId: machineId, since: Calendar.current.startOfDay(for: Date()))
        } catch {
            print("Refresh sales error: \(error)")
        }
    }
}
