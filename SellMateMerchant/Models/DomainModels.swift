import Foundation

struct Merchant: Identifiable, Codable {
    let id: String
    let businessName: String
    let ownerUid: String
}

struct Product: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let priceCents: Int
    let imageUrl: String
    let active: Bool
}

struct Machine: Identifiable, Codable {
    let id: String
    let merchantId: String
    let displayName: String
    let location: String
    let status: String
}

struct InventorySlot: Identifiable, Codable {
    let id: String
    let productId: String
    let qty: Int
    let enabled: Bool
    let updatedAt: Date
}

struct InventoryRow: Identifiable, Equatable {
    let id: String
    let slotId: String
    let product: Product?
    let qty: Int
    let enabled: Bool
}

struct Sale: Identifiable, Codable {
    let id: String
    let orderId: String
    let machineId: String
    let timestamp: Date
    let items: [SaleItem]
    let totalCents: Int
}

struct SaleItem: Identifiable, Codable {
    let id: String
    let slotId: String
    let productId: String
    let qty: Int
    let amountCents: Int
}
