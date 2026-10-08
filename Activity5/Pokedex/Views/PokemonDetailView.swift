import SwiftUI

struct PokemonDetailView: View {

    let pokemon: Pokemon

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: pokemon.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: 300, maxHeight: 300)
            // Accessibility: VoiceOver describes the image with the Pokemon name
            .accessibilityLabel("Artwork of \(pokemon.name.capitalized)")

            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .bold()

            Text(String(format: "Pokédex number #%03d", pokemon.id))
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemon: Pokemon(name: "pikachu", url: URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!))
    }
}
