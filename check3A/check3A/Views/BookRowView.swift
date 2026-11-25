import SwiftUI

struct BookRowView: View {
    let book: Concert

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.artist)
                    .font(.headline)
                Text(book.place)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if book.visited {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel("Read")
            }
        }
    }
}
