import SwiftUI

struct MasterProductsView: View {
    @ObservedObject var viewModel: MasterProductsViewModel
    @State private var showingAdd = false

    var body: some View {
        VStack(spacing: 0) {
            if let error = viewModel.errorMessage {
                HStack { Image(systemName: "exclamationmark.triangle"); Text(error).font(.footnote) }
                    .padding()
                    .background(Color.red.opacity(0.1))
            }
            List(viewModel.working) { product in
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Name", text: Binding(
                            get: { product.name },
                            set: { viewModel.update(productId: product.id, name: $0) }
                        ))
                        .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("$")
                        TextField("Price", text: Binding(
                            get: { String(format: "%.2f", Double(product.priceCents)/100) },
                            set: { text in
                                let cents = Int((Double(text) ?? 0) * 100)
                                viewModel.update(productId: product.id, priceCents: cents)
                            }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    }
                    TextField("Image URL", text: Binding(
                        get: { product.imageUrl },
                        set: { viewModel.update(productId: product.id, imageUrl: $0) }
                    ))
                    .textInputAutocapitalization(.never)
                    Toggle("Active", isOn: Binding(
                        get: { product.active },
                        set: { viewModel.update(productId: product.id, active: $0) }
                    ))
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("Products")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Discard") { viewModel.load() }
                    .disabled(!viewModel.hasUnsavedChanges)
                Button("Save") { Task { await viewModel.saveChanges() } }
                    .disabled(!viewModel.hasUnsavedChanges)
                Button {
                    showingAdd = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddProductView(viewModel: viewModel)
        }
        .onAppear { viewModel.load() }
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
