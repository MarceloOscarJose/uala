//
//  File.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import SwiftUI

public struct HomeRootView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var isLandscape: Bool = false

    private let autoStart: Bool

    public init(viewModel: HomeViewModel = HomeViewModel(), autoStart: Bool = true) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.autoStart = autoStart
    }

    public var body: some View {
        GeometryReader { geometry in
            Group {
                if isLandscape {
                    HomeRegularView(viewModel: viewModel)
                } else {
                    HomeCompactView(viewModel: viewModel)
                }
            }
            .task {
                if autoStart {
                    viewModel.start()
                }
            }
            .onChange(of: geometry.size) { _ in
                self.isLandscape = geometry.size.width > geometry.size.height
                viewModel.setPreviewEnabled(isLandscape)
            }
            .onAppear {
                self.isLandscape = geometry.size.width > geometry.size.height
                viewModel.setPreviewEnabled(isLandscape)
            }
        }
    }
}

#Preview() {
    HomeRootView(viewModel: HomeViewModel.preview(), autoStart: false)
}
