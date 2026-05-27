import Foundation
#if canImport(FirebaseAuth)
import FirebaseAuth
import FirebaseFirestore
#endif

protocol InventoryServiceProtocol {
    func bootstrapSession() async throws -> String
    func fetchMerchant(for ownerUid: String) async throws -> Merchant
    func fetchProducts(merchantId: String) async throws -> [Product]
    func addProduct(merchantId: String, name: String, priceCents: Int, imageUrl: String, active: Bool) async throws
    func fetchMachines(merchantId: String) async throws -> [Machine]
    func fetchInventory(machineId: String) async throws -> [InventorySlot]
    func updateInventory(machineId: String, slotId: String, qty: Int, enabled: Bool) async throws
}

final class InventoryService: InventoryServiceProtocol {
    #if canImport(FirebaseFirestore)
    private let db = Firestore.firestore()
    #endif

    func bootstrapSession() async throws -> String {
        #if canImport(FirebaseAuth)
        if let uid = Auth.auth().currentUser?.uid { return uid }
        let authResult = try await Auth.auth().signInAnonymously()
        return authResult.user.uid
        #else
        return "local-dev-merchant"
        #endif
    }

    func fetchMerchant(for ownerUid: String) async throws -> Merchant {
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("merchants").whereField("ownerUid", isEqualTo: ownerUid).limit(to: 1).getDocuments()
        if let doc = snapshot.documents.first {
            let data = doc.data()
            return Merchant(
                id: doc.documentID,
                businessName: data["businessName"] as? String ?? "Merchant",
                ownerUid: data["ownerUid"] as? String ?? ownerUid
            )
        }
        let merchantRef = db.collection("merchants").document(ownerUid)
        try await merchantRef.setData(["businessName": "My Business", "ownerUid": ownerUid], merge: true)
        return Merchant(id: ownerUid, businessName: "My Business", ownerUid: ownerUid)
        #else
        return Merchant(id: "merchant-1", businessName: "Demo Merchant", ownerUid: ownerUid)
        #endif
    }

    func fetchProducts(merchantId: String) async throws -> [Product] {
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("merchants").document(merchantId).collection("products").getDocuments()
        return snapshot.documents.map { doc in
            let d = doc.data()
            return Product(id: doc.documentID, name: d["name"] as? String ?? "Unknown", priceCents: d["priceCents"] as? Int ?? 0, imageUrl: d["imageUrl"] as? String ?? "", active: d["active"] as? Bool ?? true)
        }
        #else
        return []
        #endif
    }

    func addProduct(merchantId: String, name: String, priceCents: Int, imageUrl: String, active: Bool) async throws {
        #if canImport(FirebaseFirestore)
        try await db.collection("merchants").document(merchantId).collection("products").addDocument(data: ["name": name, "priceCents": priceCents, "imageUrl": imageUrl, "active": active])
        #endif
    }

    func fetchMachines(merchantId: String) async throws -> [Machine] {
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("machines").whereField("merchantId", isEqualTo: merchantId).getDocuments()
        return snapshot.documents.map { doc in
            let d = doc.data()
            return Machine(id: doc.documentID, merchantId: d["merchantId"] as? String ?? merchantId, displayName: d["displayName"] as? String ?? "Machine", location: d["location"] as? String ?? "", status: d["status"] as? String ?? "unknown")
        }
        #else
        return [Machine(id: "machine-1", merchantId: merchantId, displayName: "Demo Machine", location: "Lobby", status: "online")]
        #endif
    }

    func fetchInventory(machineId: String) async throws -> [InventorySlot] {
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("machines").document(machineId).collection("inventory").getDocuments()
        return snapshot.documents.map { doc in
            let d = doc.data()
            let ts = d["updatedAt"] as? Timestamp
            return InventorySlot(id: doc.documentID, productId: d["productId"] as? String ?? "", qty: d["qty"] as? Int ?? 0, enabled: d["enabled"] as? Bool ?? true, updatedAt: ts?.dateValue() ?? Date())
        }
        #else
        return [InventorySlot(id: "A1", productId: "", qty: 5, enabled: true, updatedAt: Date())]
        #endif
    }

    func updateInventory(machineId: String, slotId: String, qty: Int, enabled: Bool) async throws {
        #if canImport(FirebaseFirestore)
        try await db.collection("machines").document(machineId).collection("inventory").document(slotId).setData([
            "qty": qty,
            "enabled": enabled,
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)
        #endif
    }
}
