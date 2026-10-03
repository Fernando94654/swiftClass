import SwiftUI

struct BookDetailView: View {
    
    let book : Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottom) {
                    Image(book.imageName[0])
                        .resizable()
                        .scaledToFit()
                    
                    Text(book.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.6))
                }
                
                Text("\(book.author) - \(book.year)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(book.description)
                
                if let url = URL(string: book.infoURL) {
                    Link(destination: url) {
                        Text("Learn more")
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle(book.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: Book(name: "Frankenstein", title: "Frankenstein; or, The Modern Prometheus", author: "Mary Shelley", year: 1818, description: "Description", infoURL: "https://en.wikipedia.org/wiki/Frankenstein", imageName: ["Frankenstein", "Frankenstein2", "Frankenstein3"]))
    }
}
