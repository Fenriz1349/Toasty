//
//  ToastyContainer.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import SwiftUI

/// Wrap your app root view to enable toast notifications above all presentations.
/// Uses a UIWindow overlay (windowLevel = .alert + 1) so toasts appear above
/// sheets, fullScreenCover, and system alerts.
public struct ToastyContainer<Content: View>: View {
    @ObservedObject private var manager: ToastyManager
    private let content: Content

    /// Creates a container.
    /// - Parameters:
    ///   - manager: Shared ToastyManager instance.
    ///   - content: Your root view.
    public init(manager: ToastyManager, @ViewBuilder content: () -> Content) {
        self.manager = manager
        self.content = content()
    }

    public var body: some View {
        content
            .background(ToastyWindowHost(manager: manager))
    }
}

// MARK: - Passthrough Window

/// A UIWindow subclass that forwards touches to the window below
/// when they don't land on an interactive subview (i.e. outside the toast).
private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == hitView ? nil : hitView
    }
}

// MARK: - UIKit Window Overlay

/// UIViewRepresentable bridge that presents the toast in a dedicated UIWindow
/// sitting above all SwiftUI sheets and modals.
private struct ToastyWindowHost: UIViewRepresentable {
    @ObservedObject var manager: ToastyManager

    func makeUIView(context: Context) -> UIView { UIView() }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let toast = manager.currentToast {
            context.coordinator.show(toast: toast, manager: manager, from: uiView)
        } else {
            context.coordinator.hide()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    @MainActor
    final class Coordinator {
        private var window: UIWindow?

        func show(toast: ToastyMessage, manager: ToastyManager, from view: UIView) {
            guard window == nil,
                  let windowScene = view.window?.windowScene else { return }

            let overlayWindow = PassthroughWindow(windowScene: windowScene)
            overlayWindow.windowLevel = .alert + 1
            overlayWindow.backgroundColor = .clear
            overlayWindow.isUserInteractionEnabled = true

            let controller = UIHostingController(rootView:
                VStack {
                    ToastyView(toast: toast) {
                        withAnimation(.easeOut(duration: 0.25)) { manager.dismiss() }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
                .animation(.spring(response: 0.55, dampingFraction: 0.85), value: manager.hasToast)
                .padding(.top, 8)
            )
            controller.view.backgroundColor = .clear
            overlayWindow.rootViewController = controller
            overlayWindow.isHidden = false
            self.window = overlayWindow
        }

        func hide() {
            window?.isHidden = true
            window = nil
        }
    }
}
