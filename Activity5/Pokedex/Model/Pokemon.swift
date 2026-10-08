import Foundation

// Clean Code: single responsibility - these types only describe the API data
struct Pokemon: Identifiable, Decodable {
    let name: String
    let url: URL

    /// The list has no id field, it is the last part of the url
    var id: Int {
        Int(url.lastPathComponent) ?? 0
    }

    var imageURL: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}

/// The API wraps the list inside "results"
struct PokemonResponse: Decodable {
    let results: [Pokemon]
}
