//
//  ToastyContainer.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import SwiftUI

/// Wrap your app UI and display a toast on top.
public struct ToastyContainer<Content: View>: View {
    @ObservedObject private var manager: ToastyManager
    private let content: Content

    /// Creates a container.
    /// - Parameters:
    ///   - manager: Shared ToastyManager instance.
    ///   - content: Your main content.
    public init(manager: ToastyManager, @ViewBuilder content: () -> Content) {
        self.manager = manager
        self.content = content()
    }

    public var body: some View {
        ZStack {
            content

            VStack {
                if let toast = manager.currentToast {
                    ToastyView(toast: toast) {
                        withAnimation(.easeOut(duration: 0.25)) {
                            manager.dismiss()
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
            .animation(.spring(response: 0.55, dampingFraction: 0.85), value: manager.hasToast)
            .zIndex(999)
        }
    }
}
