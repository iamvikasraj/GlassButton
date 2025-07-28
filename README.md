# Liquid Glass Button

A beautiful, interactive date selector component for SwiftUI featuring liquid glass-styled buttons and smooth animations.

https://github.com/user-attachments/assets/ebdbc649-573e-4d3e-a311-e9fe7272ecfe

## Features

- **Liquid Glass Buttons**: Navigate through dates using beautifully crafted liquid glass-effect arrow buttons
- **Smart Date Labels**: Displays "Today", "Tomorrow", "Yesterday" for relative dates, or formatted date strings for other dates
- **Custom Styling**: Beautiful gradient backgrounds and meticulously crafted button designs
- **Haptic Feedback**: Medium impact feedback when navigating between dates
- **Smooth Animations**: Spring animations for date transitions and text changes
- **Scalable Design**: Easily customizable button sizes and colors

## Screenshots

*Add your app screenshots here*

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

### Manual Installation

1. Copy the `LiquidGlassButton.swift` file to your Xcode project
2. Add an arrow image asset named "arrow" to your app's asset catalog
3. Import SwiftUI in your view controller or SwiftUI view

### Usage

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        ArrowDateSelectorView()
    }
}
```

## Components

### ArrowDateSelectorView
The main date selector component that handles date navigation and display.

**Key Properties:**
- `@State private var currentDate`: Tracks the currently selected date
- Smart date formatting logic for relative dates
- Haptic feedback integration

### ArrowButton (Liquid Glass Button)
A custom button component with sophisticated liquid glass styling including:
- Multiple gradient fills and stroke overlays
- Blur effects and reflective surfaces
- Rotation support for directional arrows
- Advanced blend modes for realistic glass depth and transparency

### Custom Color Extensions
Pre-defined color schemes and gradients:
- `customGradient`: Multi-stop linear gradient for backgrounds
- `buttonFill`: Consistent button fill color

## Customization

### Changing Colors
Modify the color values in the `Color` extension:

```swift
extension Color {
    static let customGradient = LinearGradient(
        gradient: Gradient(stops: [
            // Add your custom colors here
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
```

### Button Scaling
Adjust the button size by modifying the `scaleEffect` values:

```swift
ArrowButton(rotation: .degrees(180))
    .scaleEffect(0.6) // Change from 0.4 to your preferred size
```

### Animation Timing
Customize the spring animation parameters:

```swift
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: formattedLabel)
```

## Assets Required

Make sure to include an arrow image in your app's asset catalog:
- **Name**: "arrow" 
- **Format**: PDF, PNG, or SVG
- **Recommendations**: Simple arrow pointing right, preferably with transparency

## Architecture

The component follows SwiftUI best practices:
- **State Management**: Uses `@State` for local date tracking
- **View Composition**: Separates concerns with dedicated subviews
- **Reusability**: Modular design allows easy integration
- **Performance**: Efficient view updates with targeted animations

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is available under the MIT License. See the LICENSE file for more info.

## Author

Created by [@vraj247](https://twitter.com/vraj247)

⭐ **Star and follow [@vraj247](https://twitter.com/vraj247) on Twitter for more SwiftUI components and iOS design inspiration!**

## Acknowledgments

- Built with SwiftUI
- Inspired by modern iOS design principles and liquid glass aesthetics
- Uses haptic feedback for enhanced user experience
