import Foundation

struct Book : Identifiable, Decodable {
    var id = UUID()
    var name : String
    var title: String
    var author: String
    var year: Int
    var description: String
    var infoURL : String
    var imageName : [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case title
        case author
        case year
        case description
        case infoURL
        case imageName
    }
}
