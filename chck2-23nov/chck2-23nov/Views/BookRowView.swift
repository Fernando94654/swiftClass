import SwiftUI

struct BookRowView: View {
    
    let book : Book
    
    var body: some View {
        HStack {
            Image(book.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            
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
