# Toasty 🍞

[![Swift](https://img.shields.io/badge/Swift-6.2+-orange?style=flat-square&logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue?style=flat-square&logo=apple)](https://www.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-13.0+-lightgrey?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square)](https://github.com/tonusername/Toasty/releases)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

A lightweight, accessible toast notification system for iOS and macOS. Show error messages and notifications with minimal setup.

## Features ✨

- 🎯 Simple API - show messages with one line of code
- 🎨 Customizable toast styles and types
- 📱 Works on iOS 16+ and macOS 13+
- 🚀 Smooth animations and transitions
- 🎭 Multiple toast types (error, success, info coming soon)

## Installation 📦

Add Toasty to your `Package.swift`:
```swift
.package(url: "https://github.com/yourusername/Toasty.git", from: "1.0.0")
```

Or use Xcode: File → Add Packages → Enter the repository URL.

## Quick Start 🚀

1. **Create a manager** at app level:
```swift
@main
struct MyApp: App {
    @StateObject private var toastyManager = ToastyManager()

    var body: some Scene {
        WindowGroup {
            ToastyContainer(manager: toastyManager) {
                ContentView()
            }
        }
    }
}
```

2. **Show a toast** anywhere in your app:
```swift
@EnvironmentObject var toastyManager: ToastyManager

Button("Show Error") {
    toastyManager.show(message: "Something went wrong!", type: .error)
}
```

3. **Show from an Error**:
```swift
do {
    try await fetchData()
} catch {
    toastyManager.showError(error, fallbackMessage: "Failed to load data")
}
```

## Usage 📖

### Show a Message
```swift
toastyManager.show(message: "Processing...", type: .error)
```

### Dismiss
```swift
toastyManager.dismiss()
```

### Check if Visible
```swift
if toastyManager.hasToast {
    // A toast is currently displayed
}
```

## Customization 🎨

Create custom toast types by extending `ToastyType`:
```swift
extension ToastyType {
    static var success: ToastyType {
        // Implement custom styling
    }
}
```

## Requirements 📋

- iOS 16.0 or later
- macOS 13.0 or later
- Swift 6.2+

## License 📄

MIT License

## Support 💬

For issues, feature requests, or questions, open an issue on GitHub.
