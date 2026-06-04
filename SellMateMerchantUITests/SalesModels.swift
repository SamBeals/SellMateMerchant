import Foundation

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
