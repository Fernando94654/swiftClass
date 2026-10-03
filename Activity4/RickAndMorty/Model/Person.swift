import Foundation

struct Person : Identifiable, Decodable {
    var id = UUID()
    var name : String
    var status : String
    var species : String
    var image : String?
    
    enum CodingKeys : String, CodingKey {
        case name
        case status
        case species
        case image
    }
}

struct PersonResponse : Decodable {
    var results : [Person]
}
