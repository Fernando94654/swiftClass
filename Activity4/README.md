# RickAndMorty

Activity 4: first API call in Swift. Fetches characters from https://rickandmortyapi.com/api/character with `URLSession`, decodes the JSON with `Decodable` and shows them in a `List` with `AsyncImage`.

## Structure

- `Model/Person.swift`: `Person` and `PersonResponse`
- `ViewModel/PersonViewModel.swift`: the API call
- `Views/ContentView.swift`: the list

## Run it on a Mac (Xcode 26)

1. `git clone <repo-url>`
2. `open Activity4/RickAndMorty.xcodeproj`
3. Pick an iPhone simulator and press Cmd+R (needs internet).
4. If Xcode asks for signing: RickAndMorty target > Signing & Capabilities > choose your Personal Team.
