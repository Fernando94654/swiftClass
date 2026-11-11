# BookShelf AI

Activity 9: BookShelf from Activity 8 plus a deeper integration of Apple's Foundation Models framework.

## What is new

- Streaming: the summary of a book appears while the model writes it (`BookSuggestionViewModel`)
- Tool calling: "Recommend" asks the model for the next book. The model calls `LibraryTool` to read the user's library (`RecommendationViewModel`, `LibraryTool`)
- Prewarm and generation options: the model is loaded when the form opens, with a low temperature for summaries
- Disclosure: AI-generated text is labeled

The research notes, the HCAI Framework mapping and the survey answers are in `RESEARCH.md`.

## How to run

- Xcode 26 on a Mac, iOS 26 or later
- A device or simulator with Apple Intelligence turned on. Without it, the AI buttons show a message and the rest of the app works.

1. `git clone <repo-url>`
2. `open Activity9/BookShelf/BookShelf.xcodeproj`
3. Pick an iPhone simulator and press Cmd+R. Press Cmd+U to run the 3 tests.
4. If Xcode asks for signing: BookShelf target > Signing & Capabilities > choose your Personal Team.
