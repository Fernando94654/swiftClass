import SwiftUI

struct BookRowView: View {
    
    let book : Book
    
    var body: some View {
        HStack {
            if let first = book.imageName {
                Image(first).resizable().scaledToFit()
            } else {
                Image(systemName: "book.closed").resizable().scaledToFit()
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Copies: \(book.copies)")
            }
        }
    }
}
