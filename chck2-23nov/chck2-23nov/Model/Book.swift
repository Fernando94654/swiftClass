import Foundation

struct Book : Identifiable, Decodable {
    var id = UUID()
    var title: String
    var author: String
    var synopsis: String
    var category : String
    var imageName : String
    var copies: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case synopsis
        case category
        case imageName
        case copies
    }
}
