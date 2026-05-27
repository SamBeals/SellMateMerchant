import SwiftUI

struct MachineInventoryView: View {
    @ObservedObject var viewModel: MachineInventoryViewModel

    var body: some View {
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
        .navigationTitle("Machine Inventory")
        .task { await viewModel.load() }
    }
}
