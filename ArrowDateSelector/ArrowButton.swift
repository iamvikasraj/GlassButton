import SwiftUI

// MARK: - Stroke Overlay Modifier
private struct CircularSteelStrokeOverlay: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(strokeLayer)
    }

    private var strokeLayer: some View {
        ZStack {
            // Stroke 1
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black.opacity(0.4), location: 0.0),
                            .init(color: .black.opacity(0.0), location: 0.1)
                        ]),
                        startPoint: .leading,
                        endPoint: .topTrailing
                    ),
                    lineWidth: 3
                )
                .blendMode(.darken)

            // Stroke 2
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black.opacity(0.4), location: 0.0),
                            .init(color: .black.opacity(0.0), location: 0.1)
                        ]),
                        startPoint: .trailing,
                        endPoint: .topLeading
                    ),
                    lineWidth: 3
                )
                .blendMode(.darken)

            // Stroke 3
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.8), location: 0.1),
                            .init(color: .white.opacity(0.0), location: 0.4)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    ),
                    lineWidth: 3
                )
                .blendMode(.overlay)

            // Stroke 4
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.8), location: 0.0),
                            .init(color: .white.opacity(0.0), location: 0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 3
                )
                .blendMode(.normal)
        }
        .compositingGroup() // render as a single overlay group
    }
}

private extension View {
    func circularSteelStrokeOverlay() -> some View {
        modifier(CircularSteelStrokeOverlay())
    }
}

// MARK: - Arrow Button View
struct ArrowButton: View {
    var rotation: Angle = .zero

    var body: some View {
        ZStack {
            // Base Fill Circle + Stroke Overlays
            Circle()
                .fill(Color(red: 120/255, green: 133/255, blue: 141/255))
                .frame(width: 125, height: 125)
                .circularSteelStrokeOverlay()

            // Blurred Reflection Layer Behind
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.48, green: 0.52, blue: 0.55), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.64, green: 0.67, blue: 0.70), location: 1.00),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 90, height: 90)
                .blur(radius: 8)
                .offset(y: 14)

            // Arrow Image
            Image("arrow")
                .rotationEffect(rotation)
                .shadow(color: .black.opacity(0.1),
                        radius: 1,
                        y: 1)
                .accessibilityHidden(true)
        }
        .contentShape(Circle())
        .accessibilityLabel("Arrow button")
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(red: 67/255, green: 80/255, blue: 89/255)
            .ignoresSafeArea()
        
        ArrowButton()
    }
}

