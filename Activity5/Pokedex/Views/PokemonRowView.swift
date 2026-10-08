import SwiftUI

struct PokemonRowView: View {

    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: pokemon.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                Text(String(format: "#%03d", pokemon.id))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        // Accessibility: VoiceOver reads the whole row as one item
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PokemonRowView(pokemon: Pokemon(name: "pikachu", url: URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!))
}
