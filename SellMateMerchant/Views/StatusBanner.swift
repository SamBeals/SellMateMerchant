import SwiftUI

struct StatusBanner: View {
    enum Kind {
        case error

        var iconName: String {
            switch self {
            case .error: "exclamationmark.triangle"
            }
        }

        var tint: Color {
            switch self {
            case .error: .red
            }
        }
    }

    let kind: Kind
    let message: String

    var body: some View {
        Label {
            Text(message)
                .font(.footnote)
                .foregroundStyle(.primary)
        } icon: {
            Image(systemName: kind.iconName)
                .foregroundStyle(kind.tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(kind.tint.opacity(0.35))
        }
        .padding([.horizontal, .top])
    }
}
