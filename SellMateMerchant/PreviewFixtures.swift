import SwiftUI

#if DEBUG
struct PreviewInventoryService: InventoryServiceProtocol {
    func bootstrapSession() async throws -> String {
        "preview-owner"
    }

    func fetchMerchant(for ownerUid: String) async throws -> Merchant {
        Merchant(id: "preview-merchant", businessName: "Preview Merchant", ownerUid: ownerUid)
    }

    func fetchProducts(merchantId: String) async throws -> [Product] {
        [
            Product(id: "water", name: "Sparkling Water", priceCents: 250, imageUrl: "", active: true),
            Product(id: "chips", name: "Sea Salt Chips", priceCents: 175, imageUrl: "", active: true)
        ]
    }

    func addProduct(merchantId: String, name: String, priceCents: Int, imageUrl: String, active: Bool) async throws {}

    func fetchMachines(merchantId: String) async throws -> [Machine] {
        [Machine(id: "machine001", merchantId: merchantId, displayName: "Machine 001", location: "Lobby", status: "online")]
    }

    func fetchInventory(machineId: String) async throws -> [InventorySlot] {
        [
            InventorySlot(id: "A1", productId: "water", qty: 7, enabled: true, updatedAt: Date()),
            InventorySlot(id: "B2", productId: "chips", qty: 2, enabled: true, updatedAt: Date())
        ]
    }

    func updateInventory(machineId: String, slotId: String, qty: Int, enabled: Bool) async throws {}

    func fetchSales(machineId: String, since: Date) async throws -> [Sale] {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? calendar.startOfDay(for: now)
        let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? calendar.startOfDay(for: now)
        return [
            Sale(
                id: "sale-1",
                orderId: "1001",
                machineId: machineId,
                timestamp: now,
                items: [
                    SaleItem(id: "sale-1-item-1", slotId: "A1", productId: "water", qty: 1, amountCents: 250),
                    SaleItem(id: "sale-1-item-2", slotId: "B2", productId: "chips", qty: 2, amountCents: 350)
                ],
                totalCents: 600
            ),
            Sale(
                id: "sale-2",
                orderId: "1002",
                machineId: machineId,
                timestamp: calendar.date(byAdding: .day, value: 1, to: weekStart) ?? now,
                items: [
                    SaleItem(id: "sale-2-item-1", slotId: "A1", productId: "water", qty: 2, amountCents: 500)
                ],
                totalCents: 500
            ),
            Sale(
                id: "sale-3",
                orderId: "1003",
                machineId: machineId,
                timestamp: calendar.date(byAdding: .day, value: 1, to: monthStart) ?? now,
                items: [
                    SaleItem(id: "sale-3-item-1", slotId: "B2", productId: "chips", qty: 1, amountCents: 175)
                ],
                totalCents: 175
            )
        ].filter { $0.timestamp >= since }
    }
}

private struct PreviewScreen<Content: View>: View {
    @StateObject private var app = AppViewModel(service: PreviewInventoryService())
    let content: (AppViewModel) -> Content

    var body: some View {
        NavigationStack {
            content(app)
                .environmentObject(app)
        }
        .task {
            await app.bootstrap()
            await app.salesViewModel.load()
            app.masterProductsViewModel.load()
        }
    }
}

#Preview("App - Light") {
    PreviewScreen { _ in
        ContentView()
    }
    .environment(\.colorScheme, .light)
}

#Preview("App - Dark") {
    PreviewScreen { _ in
        ContentView()
    }
    .environment(\.colorScheme, .dark)
}

#Preview("Dashboard - Dark") {
    PreviewScreen { app in
        DashboardView(viewModel: app.dashboardViewModel)
    }
    .environment(\.colorScheme, .dark)
}

#Preview("Inventory - Dark") {
    PreviewScreen { app in
        MachineInventoryView(viewModel: app.machineInventoryViewModel)
    }
    .environment(\.colorScheme, .dark)
}

#Preview("Products - Dark") {
    PreviewScreen { app in
        MasterProductsView(viewModel: app.masterProductsViewModel)
    }
    .environment(\.colorScheme, .dark)
}

#Preview("Sales - Dark") {
    PreviewScreen { app in
        SalesView(viewModel: app.salesViewModel)
    }
    .environment(\.colorScheme, .dark)
}
#endif
