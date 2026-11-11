import FoundationModels

// Clean Code: DRY - both Foundation Models features share this message
extension SystemLanguageModel {
    /// A readable message when the model can't be used, or nil when it is ready
    var unavailableMessage: String? {
        switch availability {
        case .available:
            return nil
        case .unavailable(.deviceNotEligible):
            return "This device doesn't support Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Turn on Apple Intelligence in Settings to use this feature."
        case .unavailable(.modelNotReady):
            return "The model is still getting ready. Try again later."
        case .unavailable:
            return "This feature is not available right now."
        }
    }
}
