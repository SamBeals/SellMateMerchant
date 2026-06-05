import SwiftUI

struct MachineInventoryView: View {
    @ObservedObject var viewModel: MachineInventoryViewModel

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSaving {
                ProgressView("Saving…").padding().background(.thinMaterial)
            }
            if let error = viewModel.errorMessage {
                StatusBanner(kind: .error, message: error)
            }
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading inventory…")
                Spacer()
            } else if viewModel.rows.isEmpty {
                ContentUnavailableView("No Inventory", systemImage: "shippingbox", description: Text("No slots found for this machine."))
            } else {
                List {
                    ForEach(viewModel.rows) { row in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Slot \(row.slotId)")
                                    .font(.headline)
                                Spacer()
                                Toggle("Enabled", isOn: Binding(get: { row.enabled }, set: { newValue in
                                    Task { await viewModel.toggleEnabled(slotId: row.slotId, enabled: newValue) }
                                }))
                                .labelsHidden()
                            }
                            Text(row.product?.name ?? "Unassigned product")
                            HStack {
                                Button("-") { Task { await viewModel.adjustQuantity(slotId: row.slotId, delta: -1) } }
                                Text("Qty: \(row.qty)")
                                    .frame(minWidth: 70)
                                Button("+") { Task { await viewModel.adjustQuantity(slotId: row.slotId, delta: 1) } }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Machine Inventory")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Discard") { viewModel.discardChanges() }
                    .disabled(!viewModel.hasUnsavedChanges)
                Button("Save") { Task { await viewModel.saveChanges() } }
                    .disabled(!viewModel.hasUnsavedChanges)
            }
        }
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
    }
}
