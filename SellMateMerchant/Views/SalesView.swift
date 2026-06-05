import SwiftUI

struct SalesView: View {
    @ObservedObject var viewModel: SalesViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading sales...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                    Button("Retry") { Task { await viewModel.load() } }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
            } else if viewModel.sales.isEmpty {
                ContentUnavailableView("No Sales Yet", systemImage: "cart", description: Text("Recent sales will appear here."))
            } else {
                List {
                    Section("Today Totals") {
                        HStack { Text("Total"); Spacer(); Text("$\(Double(viewModel.todayTotalCents)/100, specifier: "%.2f")") }
                        HStack { Text("Orders"); Spacer(); Text("\(viewModel.todayOrderCount)") }
                        HStack { Text("Items Sold"); Spacer(); Text("\(viewModel.todayItemsSold)") }
                    }
                    Section("Recent Sales") {
                        ForEach(viewModel.sales) { sale in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Order \(sale.orderId)").font(.headline)
                                    Spacer()
                                    Text(sale.timestamp, style: .time).font(.caption)
                                }
                                HStack {
                                    Image(systemName: "creditcard")
                                    Text("$\(Double(sale.totalCents)/100, specifier: "%.2f")")
                                }
                                ForEach(sale.items) { item in
                                    HStack {
                                        Text("Slot \(item.slotId)")
                                        Spacer()
                                        Text("x\(item.qty)")
                                        Text("$\(Double(item.amountCents)/100, specifier: "%.2f")")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Sales")
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
    }
}
