import SwiftUI

// Clean Code: small views - this one only chooses what to show for each state
struct ContentView: View {

    @State private var pokemonVM = PokemonViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokédex")
        }
        .task {
            await pokemonVM.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch pokemonVM.state {
        case .loading:
            ProgressView("Loading Pokémon...")
        case .loaded(let pokemon):
            List {
                ForEach(pokemon) { item in
                    NavigationLink {
                        PokemonDetailView(pokemon: item)
                    } label: {
                        PokemonRowView(pokemon: item)
                    }
                }
            }
        case .failed(let message):
            ErrorView(message: message) {
                Task { await pokemonVM.load() }
            }
        }
    }
}

#Preview {
    ContentView()
}
