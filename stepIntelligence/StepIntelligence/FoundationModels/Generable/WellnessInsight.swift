//
//  WellnessInsight.swift
//  StepIntelligence
//
//  Created by Leonardo González on 19/03/26.
//

import Foundation
import FoundationModels

@Generable(description: "A wellness insight based on step data with a summary and suggested action")
struct WellnessInsight {
    @Guide(description: "A positive 1–2 sentence summary of the user's activity level. Under 30 words.")
    var summary: String

    @Guide(description: "One specific action the user can do right now. Single imperative sentence starting with a verb.")
    var suggestedAction: String
}
