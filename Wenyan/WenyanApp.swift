//
//  WenyanApp.swift
//  Wenyan
//
//  Created by Kuixi Song on 6/9/25.
//

import SwiftUI

@main
struct WenyanApp: App {

    init() {
        WenyanGenerator.shared.prewarm()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

}
