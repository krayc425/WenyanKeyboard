//
//  ContentView.swift
//  Wenyan
//
//  Created by Kuixi Song on 6/9/25.
//

import FoundationModels
import SwiftUI

struct ContentView: View {

    var body: some View {
        switch SystemLanguageModel.default.availability {
            case .available:
                GenerateView()
            case .unavailable(.deviceNotEligible):
                ContentUnavailableView("Device not eligible", systemImage: "xmark")
            case .unavailable(.appleIntelligenceNotEnabled):
                ContentUnavailableView("Apple Intelligence is not enabled", systemImage: "xmark")
            case .unavailable(.modelNotReady):
                ContentUnavailableView("Model is not ready", systemImage: "xmark")
            @unknown default:
                ContentUnavailableView("Unavailable", systemImage: "xmark")
        }
    }

}
