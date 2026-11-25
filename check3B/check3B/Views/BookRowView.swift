import SwiftUI

struct BookRowView: View {
    let book: Concert

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.zona)
                    .font(.headline)
                Text("Cantidad: \(book.cantidad)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if book.estacionamiento {
                    Text("Acceso a estacionamiento")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text("Total: \(book.total)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if book.estacionamiento {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel("Read")
            }
        }
    }
}
