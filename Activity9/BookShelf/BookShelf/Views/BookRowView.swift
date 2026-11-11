import SwiftUI

struct BookRowView: View {
    let book: Book

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if book.isRead {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel("Read")
            }
        }
    }
}

#Preview {
    BookRowView(book: Book(title: "Dune", author: "Frank Herbert", isRead: true, dateAdded: .now, summary: ""))
        .padding()
}
