import SwiftUI

struct MasterProductsView: View {
    @ObservedObject var viewModel: MasterProductsViewModel
    @State private var showingAdd = false

    var body: some View {
        List(viewModel.products) { product in
            VStack(alignment: .leading) {
                Text(product.name).font(.headline)
                Text("$\(Double(product.priceCents) / 100, specifier: "%.2f")")
                Text(product.active ? "Active" : "Inactive")
                    .font(.caption)
                    .foregroundStyle(product.active ? .green : .secondary)
            }
        }
        .navigationTitle("Products")
        .toolbar {
            Button {
                showingAdd = true
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddProductView(viewModel: viewModel)
        }
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MasterProductsViewModel

    @State private var name = ""
    @State private var price = ""
    @State private var imageUrl = ""
    @State private var active = true

    var body: some View {
        NavigationStack {
            Form {
                TextField("Product name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Image URL", text: $imageUrl)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                Toggle("Active", isOn: $active)
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.addProduct(name: name, priceText: price, imageUrl: imageUrl, active: active)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || price.isEmpty)
                }
            }
        }
    }
}
