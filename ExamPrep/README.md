# ExamPrep index

Open `CHEATSHEET.md` first (fast reference). `HOWTO.md` has step-by-step guides: test files, @Binding, sheets, adding files, Swift basics, modifiers, debugging, theory. Then pick the folder that matches the exercise.

| Exam exercise | Folder | Based on |
|---|---|---|
| Books list from JSON, `copies` +/−, add book, detail | `BooksCopies/` (full Xcode project) | Activity 3 |
| Checkpoint 3 A: Concerts with SwiftData, `@Query`, swipe delete | `Checkpoint3_Concerts/` (source files) | Activity 7 Birthdays, Activity 8/9 |
| Checkpoint 3 B: Tickets with `@Binding`, half sheet, Swift Testing | `Checkpoint3_Tickets/` (source files) | Activity 8 slides, Activity 9 tests |

## Exam-day workflow
1. New project (see CHEATSHEET section 0). Build and run once.
2. Copy the matching files into the new project (App file: keep Xcode's, add `.modelContainer(for:)` if SwiftData).
3. Rename types/properties to what the statement asks. Press ⌘R after each point.
4. Tests: add the Swift Testing target, copy the test file, replace the module name in `@testable import`.
5. Read the statement's numbers again (prices, limits, edge cases) and match them in the code and tests.

## Not tested
The Concert and Tickets files were written without Xcode (Linux). Run them on a Mac before the exam if you can.
