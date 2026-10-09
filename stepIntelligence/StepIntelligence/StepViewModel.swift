//
//  StepViewModel.swift
//  StepIntelligence
//
//  Created by Research and Development Tec de Monterrey on 09/03/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
class StepsViewModel {
    private let healthKit = HealthKitService()
    var stepData: StepData?
    var isLoading = false
    var errorMessage: String?
    
    func requestAccessAndLoad() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await healthKit.requestAuthorization()
            stepData = try await healthKit.fetchStepContext()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
