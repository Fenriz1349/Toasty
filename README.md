# Toasty 🍞

[![Swift](https://img.shields.io/badge/Swift-6.2+-orange?style=flat-square&logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue?style=flat-square&logo=apple)](https://www.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-13.0+-lightgrey?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![Version](https://img.shields.io/badge/Version-1.3.0-blue?style=flat-square)](https://github.com/tonusername/Toasty/releases)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

A lightweight, accessible toast notification system for iOS and macOS. Show error, success, and info messages with minimal setup.

## Features ✨

- 🎯 Simple API — show messages with one line of code
- 🎨 Three built-in toast types: error, success, info
- 📱 Works on iOS 16+ and macOS 13+
- 🚀 Smooth animations and transitions
- ♿ Accessible dismiss button
- 🪟 Appears above sheets, fullScreenCover and system alerts via UIWindow overlay

## Installation 📦

Add Toasty to your `Package.swift`:

    .package(url: "https://github.com/yourusername/Toasty.git", from: "1.3.0")

Or use Xcode: File → Add Packages → Enter the repository URL.

## Quick Start 🚀

1. Wrap your root view with `ToastyContainer`:

    @main
    struct MyApp: App {
        @StateObject private var toasty = ToastyManager()

        var body: some Scene {
            WindowGroup {
                ToastyContainer(manager: toasty) {
                    ContentView()
                }
                .environmentObject(toasty)
            }
        }
    }

2. Show a toast anywhere in your app:

    @EnvironmentObject var toasty: ToastyManager

    toasty.showError(error)
    toasty.showError("Something went wrong.")
    toasty.showSuccess("Saved successfully.")
    toasty.showInfo("Sync completed.")
    toasty.show(message: "Hello", type: .error)

## Toast Types 🎨

| Type     | Color     | Icon                          |
|----------|-----------|-------------------------------|
| .error   | Red       | exclamationmark.triangle.fill |
| .success | Green     | checkmark.circle.fill         |
| .info    | Dark gray | None                          |

## API Reference 📖

    toasty.show(message:type:)
    toasty.showError(_ error: Error, fallbackMessage:)
    toasty.showError(_ message: String)
    toasty.showSuccess(_ message: String)
    toasty.showInfo(_ message: String)
    toasty.dismiss()
    toasty.hasToast       // Bool
    toasty.currentToast   // ToastyMessage?

## How it works 🔧

`ToastyContainer` uses a dedicated `UIWindow` overlay with `windowLevel = .alert + 1`. This ensures toasts appear above every SwiftUI presentation layer — sheets, `fullScreenCover`, and system alerts included.

- The overlay window is created on demand and released immediately after dismissal.
- A custom `PassthroughWindow` subclass ensures touches outside the toast are forwarded to the underlying app — the toast never blocks interaction with the rest of the UI.

> **iOS only** — the UIWindow approach is not available on macOS. On macOS, toasts fall back to a ZStack overlay.

## Requirements 📋

- iOS 16.0 or later
- macOS 13.0 or later
- Swift 6.2+

## License 📄

MIT License

## Support 💬

For issues or feature requests, open an issue on GitHub.
