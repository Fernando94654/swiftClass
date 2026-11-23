import Foundation

struct Book : Identifiable, Decodable {
    var id: Int
    var title: String
    var artist: String
    var description: String
    var imageName : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artist
        case description
        case imageName
    }
}
