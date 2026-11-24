import Foundation

@Observable
class BookViewModel {
    
    var arrBooks = [Book]()
    
    init() {
        arrBooks = load("booksData.json")
    }
    
    func increaseBook(book: Book){
        guard let index = arrBooks.firstIndex(where: {$0.id == book.id}) else {
            return
        }
        arrBooks[index].copies += 1
    }
    
    func decreaseBook(book: Book){
        guard let index = arrBooks.firstIndex(where: {$0.id == book.id}) else {
            return
        }
        if(arrBooks[index].copies > 0){
            arrBooks[index].copies -= 1
        }
        
    }
    
    func addBook(title: String, author: String, synopsis: String, category: String, copies: Int, imageName: String) {
        let book = Book(id: UUID(), title: title, author: author, synopsis: synopsis, category: category, imageName: imageName, copies: copies,
        )
        arrBooks.append(book)
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
