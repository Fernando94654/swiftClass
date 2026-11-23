import SwiftUI

struct BookDetailView: View {
    
    let book : Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottom) {
                    Image(book.imageName)
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
                
                Text(book.description)
                
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

