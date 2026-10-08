import Foundation
import Observation

// Clean Code: single responsibility - holds the screen state, knows nothing about layout
@MainActor @Observable
class PokemonViewModel {

    /// The three things the screen can show
    enum State {
        case loading
        case loaded([Pokemon])
        case failed(String)
    }

    private(set) var state = State.loading
    private let service = PokemonService()

    func load() async {
        state = .loading
        do {
            state = .loaded(try await service.fetchPokemon())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
