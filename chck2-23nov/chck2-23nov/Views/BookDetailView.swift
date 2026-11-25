import SwiftUI

struct BookDetailView: View {
    
    let book : Book
    let bookVM : BookViewModel
    
    private var current : Book {
        bookVM.arrBooks.first(where: { $0.id == book.id }) ?? book
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottom) {
                    if let first = book.imageName {
                        Image(first).resizable().scaledToFit()
                    } else {
                        Image(systemName: "book.closed").resizable().scaledToFit()
                    }
                    
                    Text(book.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.6))
                }
                
                Text(book.synopsis)
                
                if let url = URL(string: book.category) {
                    Link(destination: url) {
                        Text("Learn more")
                    }
                }
                
                HStack {
                    Button("Remove copie", systemImage: "minus.circle.fill") {
                        bookVM.decreaseBook(book: current)
                    }.disabled(current.copies == 0)
                    Text("Copies: \(current.copies)")
                    Button("Add copie", systemImage: "plus.circle.fill") {
                        bookVM.increaseBook(book: current)
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

