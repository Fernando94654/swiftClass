# Foundation Models, deeper: research and integration

## 1. What I investigated

Apple's **Foundation Models** framework (iOS 26, iPadOS 26, macOS 26). It gives an app access to the on-device language model behind Apple Intelligence, from Swift.

Facts (sources at the end):
- The on-device model has about 3 billion parameters.
- It runs on the device: it works offline, inference is free of cost, and the prompts don't leave the device.
- It needs a device that supports Apple Intelligence, with Apple Intelligence turned on.
- Main features: guided generation (`@Generable`), streaming, tool calling, and sessions with instructions.
- Limit: a context window of 4,096 tokens per session. Instructions, prompt, tool definitions, schemas and the answer all count.

## 2. Why this framework

| Option | Decision |
| --- | --- |
| Foundation Models | Chosen. Works with Xcode 26, no extra setup, and Activity 8 only used the basics. |
| App Intents | Good, but it is about Siri and Shortcuts, not AI generation. |
| Natural Language, Vision | Useful, but narrower than a language model. |
| Core ML / Core AI | Core AI is new in iOS 27 and needs Xcode 27. The lab has Xcode 26. |

## 3. What I built (BookShelf AI)

| Feature | Where | API |
| --- | --- | --- |
| Streaming summary | `BookSuggestionViewModel` | `streamResponse(to:generating:)`, `PartiallyGenerated` |
| Tool calling | `LibraryTool`, `RecommendationViewModel` | `Tool`, `LanguageModelSession(tools:instructions:)` |
| Structured output | `BookSuggestion`, `BookRecommendation` | `@Generable`, `@Guide` |
| Model ready and low latency | `BookSuggestionViewModel` | `prewarm()`, `GenerationOptions(temperature:)` |
| Availability | `ModelAvailability.swift` | `SystemLanguageModel.default.availability` |

## 4. Integration process

1. Copy BookShelf (Activity 8) to a new folder.
2. Check availability first: one extension on `SystemLanguageModel` returns a readable message, used by both features.
3. Describe the output with `@Generable` structs, so the answer always has the same shape.
4. Streaming: replace `respond` with `streamResponse` and read each snapshot (`snapshot.content`). The fields arrive as optionals, because they are not finished yet.
5. Tool calling: write `LibraryTool` (name, description, `@Generable Arguments`, `call`). The model decides when to call it. The tool reads the titles from `BookViewModel`.
6. Show states in the UI: loading, partial result, final result, error with Try Again.
7. Test the part that is not AI: `titles(isRead:)` has a unit test, because the model can't run in tests.

Key code:

```swift
struct LibraryTool: Tool {
    let name = "readLibrary"
    let description = "Returns the titles of the books in the user's library, read or not read yet"
    let viewModel: BookViewModel

    @Generable
    struct Arguments {
        @Guide(description: "true for the books already read, false for the books not read yet")
        let isRead: Bool
    }

    func call(arguments: Arguments) async throws -> [String] {
        await viewModel.titles(isRead: arguments.isRead)
    }
}

for try await snapshot in session.streamResponse(to: prompt, generating: BookRecommendation.self) {
    recommendation = snapshot.content
}
```

## 5. HCAI Framework (Apple, July 2026)

| Dimension | How the integration follows it |
| --- | --- |
| Safety | The framework's built-in guardrails stay on. If a generation fails, the app shows a plain message and keeps working. Output is shown as a suggestion, never saved without the user pressing Save. |
| Efficiency | A right-sized on-device model (about 3B parameters), no server. `prewarm()` loads it before use. Tool calling reads the library only when needed, instead of putting every book in the prompt, which protects the 4,096-token window. A new session per recommendation keeps the context small. |
| Reliability | `@Generable` guarantees the format. Availability is checked before each request. Empty library, Apple Intelligence off, and generation errors all have a message and a Try Again. Low temperature for factual summaries. |
| Privacy | Everything runs on the device. The model only sees the book titles, and only when it calls the tool after the user taps Recommend. Nothing is sent to a server. |
| Accessibility | Buttons have text labels plus SF Symbols, system fonts support Dynamic Type, standard controls work with VoiceOver. Gap: streamed text is not announced while it grows. Next step: test with VoiceOver and announce when the text is finished. |
| Transparency | AI text is labeled: "Written with Apple Intelligence. Check it before you save." and "Suggested by Apple Intelligence, based on your library". The second one says what the suggestion is based on. |
| User Agency | The user starts every AI action with a button. The summary is editable, Cancel discards it, and the user decides to save. The user can ignore the recommendation. Gap: there is no setting to turn the AI buttons off. |

## 6. Survey answers

These are written from my point of view as a student. Items marked (confirm) are course facts to check with the professor.

1. **Typical model sizes and datasets in student projects?** In this class nobody trains a model. We use Apple's on-device model of about 3 billion parameters through Foundation Models. The datasets are very small: a JSON file of a few items, or a few records in SwiftData. (confirm for other classes)
2. **Frameworks students use? Required or free?** Swift, SwiftUI, SwiftData, Swift Testing and Foundation Models, in Xcode. The Apple stack is required for the iOS class. PyTorch, TensorFlow, JAX, MLX or scikit-learn were not used here. (confirm)
3. **Open-source LLMs (Llama, Mistral, Phi, Gemma)?** No. We use Apple's model. (confirm for other classes)
   - How: inference only, with prompt engineering (instructions), guided generation, and tool calling. No fine-tuning, no pretraining.
4. **Hardware available?** Mixed. The lab has Macs with Xcode, but only for a few hours a week. I develop on an Ubuntu laptop and have no Apple device, so I can only run and test the app in the lab.
5. **Compute? Cloud?** No cloud. The model runs on the device or the simulator. We did not use AWS, GCP, Azure or Colab. (confirm)
6. **Limits or challenges?** No quotas, because inference is local and free. The challenges are access (few lab hours, and Macs and devices that support Apple Intelligence with it turned on) and the small 4,096-token context window.

## 7. Presentation outline (about 5 minutes)

1. The problem: BookShelf needs smarter features without a server (30 s).
2. Foundation Models in one slide: on-device, free, offline, 3B parameters, 4,096 tokens (45 s).
3. Demo 1: streaming summary in the form (60 s).
4. Demo 2: Recommend, and how the model calls `LibraryTool` (90 s). Show the tool code.
5. HCAI Framework: one sentence for each of the 7 dimensions, plus the 2 gaps I found (60 s).
6. Lessons: check availability, use guided generation, protect the context window, test what is not AI (30 s).

## 8. Video scripts

**Code video (4-5 min):** `ModelAvailability` > `@Generable` structs > `BookSuggestionViewModel` (prewarm, options, streaming) > `LibraryTool` > `RecommendationViewModel` > the two sheets and their AI labels > the 3 tests (Cmd+U).

**App video (2-3 min):** add 3 books (some read) > open a book > Suggest with Apple Intelligence (watch it stream) > edit the text and save > Recommend (show the library-based result) > turn Apple Intelligence off and show the message.

## Sources

- Apple Newsroom, Foundation Models framework: https://www.apple.com/newsroom/2025/09/apples-foundation-models-framework-unlocks-new-intelligent-app-experiences/
- Foundation Models documentation: https://developer.apple.com/documentation/foundationmodels
- Tool: https://developer.apple.com/documentation/foundationmodels/tool
- TN3193, Managing the on-device model's context window: https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window
- HCAI Framework, CEI HCAI Summit, July 2026 (PDF from the class)
