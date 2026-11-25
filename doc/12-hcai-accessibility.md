# HCAI Framework and accessibility

_From: HCAI Framework PDF (July 2026) · Activity9 RESEARCH.md · StepIntelligence reflection slide_

- Apple's HCAI Framework has 7 dimensions: Safety, Efficiency, Reliability, Privacy, Accessibility, Transparency, User Agency.
- Safety: safeguards against harmful or accidental AI interactions (guardrails, rule "no medical advice, calories, BMI or heart rate zones").
- Efficiency: right-sized models, on-device inference, prewarm, tool calling and protecting the context window.
- Reliability: works in real-world cases; `@Generable` guarantees format, availability is checked, every failure has a message and Try Again.
- Privacy: ask permission, collect the minimum, users control their data. StepIntelligence sends only 4 summarized values and they never leave the device.
- Accessibility: perceivable, operable, adaptable for all abilities. VoiceOver labels, Dynamic Type, standard controls.
- Transparency: users know output is AI-generated ("Written with Apple Intelligence. Check it before you save.") and what it's based on.
- User Agency: users control AI behavior: they start every AI action, can edit, cancel, or ignore the result.
- SwiftUI accessibility: `.accessibilityLabel("Visited")` on icons, `.accessibilityElement(children: .combine)` to read a row as one item, `Button("Add", systemImage: "plus")` so VoiceOver reads "Add".

> **Exam trap:** A silent AI failure looks like "nothing happened". Transparency means showing a clear message, not an empty screen.

```swift
Image(systemName: "checkmark.circle.fill")
    .foregroundStyle(.green)
    .accessibilityLabel("Read")              // VoiceOver says "Read", not "checkmark"

HStack { ... }
    .accessibilityElement(children: .combine) // one swipe reads the whole row

Text("Written with Apple Intelligence. Check it before you save.") // transparency
```
