//
//  SmartCityExplorationApp.swift
//  SmartCityExploration
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import SwiftUI
import SCFeatureHome
import SCBaseNetworking

@main
struct SmartCityExplorationApp: App {

    init() {
        // TODO: Change this to plist
        let env = NetworkingEnvironment(baseURL: "https://gist.github.com/hernan-uala")
        Task { await Networking.shared.configure(environment: env) }
    }

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.arguments.contains("UITEST_HOME_PREVIEW") {
                let fixture = ProcessInfo.processInfo.environment["HOME_FIXTURE"] ?? "preview-cities"
                let view = HomeRootView(viewModel: HomeViewModel.preview(file: fixture), autoStart: false)
                view
            } else {
                HomeRootView()
            }
        }
    }
}
