import Foundation

// Clean Code: single responsibility - this type only talks to the API
struct PokemonService {

    /// GET request for the first 151 Pokemon
    func fetchPokemon() async throws -> [Pokemon] {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // URLSession does not throw for 404 or 500, so the status code is checked here
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                throw APIError.badStatus(http.statusCode)
            }

            return try JSONDecoder().decode(PokemonResponse.self, from: data).results
        } catch let error as APIError {
            throw error
        } catch is DecodingError {
            throw APIError.decoding
        } catch {
            throw APIError.offline
        }
    }
}
