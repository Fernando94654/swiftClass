# Foundation Models (Apple Intelligence)

_From: Deck "Understanding Foundation Models" · StepIntelligence · Activity8/9 BookShelf AI_

- `import FoundationModels` gives access to Apple's on-device language model (~3B parameters): works offline, free, prompts never leave the device. Context window: 4,096 tokens per session (instructions + prompt + schema + answer).
- Mental model: Instructions = who the model is (job + rules), Session = the conversation, `@Generable` = the form to fill, `@Guide` = notes beside each field, Prompt = today's data and request, Streaming = they dictate as they write.
- `LanguageModelSession(instructions:)` sets the rules once. The model gives Instructions priority over the Prompt: keep safety rules there and never paste user-typed text into them.
- `@Generable struct` = guided generation: the model fills a Swift struct, not free text, so the UI is predictable. `@Guide(description:)` shapes each field ("under 30 words", "starting with a verb"); can also constrain, like `.count(3)`.
- `respond(to:generating:)` returns the complete struct. `streamResponse` returns `PartiallyGenerated` snapshots whose fields are Optional, so show them with `if let`.
- Check before generating: `SystemLanguageModel.default.availability` (`.available`, or `.unavailable(.deviceNotEligible / .appleIntelligenceNotEnabled / .modelNotReady)`).
- `session.prewarm()` loads the model early; `GenerationOptions(temperature: 0.3)` = lower temperature, more predictable output.
- Tool calling: a `struct` adopting `Tool` with `name`, `description`, `@Generable struct Arguments`, and `call(arguments:)`. Pass it with `LanguageModelSession(tools: [...], instructions:)`. The model decides when to call it.
- Context engineering: turn numbers into meaning before prompting ("below your weekly average"). The model never touches HealthKit; it gets 4 summarized values (data minimization).
- Setup: Apple silicon Mac, matching macOS/Xcode/simulator versions, Apple Intelligence on, model downloaded.

> **Exam trap:** Show errors: the starter project stored the error but never showed it. Log the detail, show the user a short message and a Retry button.

```swift
@Generable(description: "A wellness insight based on step data")
struct WellnessInsight {
    @Guide(description: "A positive 1–2 sentence summary. Under 30 words.")
    var summary: String
    @Guide(description: "One specific action. Single imperative sentence starting with a verb.")
    var suggestedAction: String
}

let session = LanguageModelSession(instructions: Instructions {
    "You are a personal wellness companion. Never give medical advice."
})

let prompt = Prompt { "Steps today: \(data.stepsToday). Today's activity is \(trendText)." }
let stream = session.streamResponse(to: prompt, generating: WellnessInsight.self)
for try await partial in stream {
    wellnessInsight = partial.content          // WellnessInsight.PartiallyGenerated, fields are optional
}

struct LibraryTool: Tool {
    let name = "readLibrary"
    let description = "Returns the titles of the books in the user's library"
    @Generable struct Arguments {
        @Guide(description: "true for books already read") let isRead: Bool
    }
    func call(arguments: Arguments) async throws -> [String] { ... }
}
```
