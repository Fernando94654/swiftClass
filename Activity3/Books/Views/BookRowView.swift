import SwiftUI

struct BookRowView: View {
    
    let book : Book
    
    var body: some View {
        HStack {
            Image(book.imageName[0])
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            
            VStack(alignment: .leading) {
                Text(book.name)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    BookRowView(book: Book(name: "Frankenstein", title: "Frankenstein; or, The Modern Prometheus", author: "Mary Shelley", year: 1818, description: "Description", infoURL: "", imageName: ["Frankenstein"]))
}
