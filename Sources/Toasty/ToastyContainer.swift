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

    public init(manager: ToastyManager, @ViewBuilder content: () -> Content) {
        self.manager = manager
        self.content = content()
    }

    public var body: some View {
        content
            .background(ToastyWindowHost(manager: manager))
    }
}

// MARK: - UIKit Window Overlay

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
            // Hide any existing toast first
            hide()

            guard let windowScene = view.window?.windowScene else { return }

            let overlayWindow = PassthroughWindow(windowScene: windowScene)
            overlayWindow.windowLevel = .alert + 1
            overlayWindow.backgroundColor = .clear

            // Transparent root — its view is the passthrough target
            let rootVC = UIViewController()
            rootVC.view.backgroundColor = .clear

            // Toast hosted in a child controller constrained to the top
            let toastVC = UIHostingController(rootView:
                ToastyView(toast: toast) {
                    withAnimation(.easeOut(duration: 0.25)) { manager.dismiss() }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            )
            toastVC.sizingOptions = [.intrinsicContentSize]
            toastVC.view.backgroundColor = .clear
            toastVC.view.translatesAutoresizingMaskIntoConstraints = false

            rootVC.addChild(toastVC)
            rootVC.view.addSubview(toastVC.view)
            NSLayoutConstraint.activate([
                toastVC.view.topAnchor.constraint(equalTo: rootVC.view.safeAreaLayoutGuide.topAnchor, constant: 8),
                toastVC.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor, constant: 16),
                toastVC.view.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor, constant: -16)
            ])
            toastVC.didMove(toParent: rootVC)

            overlayWindow.rootViewController = rootVC
            overlayWindow.isHidden = false
            self.window = overlayWindow
        }

        func hide() {
            window?.isHidden = true
            window = nil
        }
    }
}

// MARK: - Passthrough Window

/// Forwards touches to the window below when they land on the transparent
/// background. Touches on the toast itself are handled normally.
private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let result = super.hitTest(point, with: event) else { return nil }
        // Pass through if the hit is on the window or the transparent root view
        if result === self || result === rootViewController?.view { return nil }
        return result
    }
}
