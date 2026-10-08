# Pokédex

## What the app does

Shows the first 151 Pokémon in a list. Tap one to open a detail screen with its artwork, name and Pokédex number.

- Loading state with a `ProgressView`
- Friendly errors with a "Try again" button (no connection, bad status code, unreadable data)
- Basic accessibility: VoiceOver reads each row as one item and the artwork has a label

## API

PokéAPI, one GET request: https://pokeapi.co/api/v2/pokemon?limit=151

Docs: https://pokeapi.co/docs/v2

Artwork: https://github.com/PokeAPI/sprites

## How to run

- Xcode 26 on a Mac
- iOS 17.0 or later (simulator or device)

1. `git clone <repo-url>`
2. `open Activity5/Pokedex.xcodeproj`
3. Pick an iPhone simulator and press Cmd+R (needs internet).
4. If Xcode asks for signing: Pokedex target > Signing & Capabilities > choose your Personal Team.

## Architecture (MVVM)

- Model: `Model/Pokemon.swift`
- ViewModel: `ViewModel/PokemonViewModel.swift` (state: loading, loaded, failed)
- Service: `Service/PokemonService.swift` and `Service/APIError.swift` (network and errors)
- Views: `Views/`

## Clean Code rules used

- Single responsibility: model, service, view model and each view have one job
- Small views: list screen, row, detail and error are separate views
- Consistent naming: `Pokemon*` for everything about a Pokémon
- No dead code

The rules are also noted in short comments next to the relevant code.
