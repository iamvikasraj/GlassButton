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

// MARK: - Shake Animation Modifier
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

// MARK: - Counter View
struct CounterView: View {
    @State private var count: Int = 1
    @State private var shake: CGFloat = 0
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            // Number Display
            // Arrow Buttons
            HStack(spacing: 0) {
                // Decrement Button
                Button {
                    if count > 1 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            count -= 1
                            showError = false
                        }
                    }
                } label: {
                    ArrowButton(rotation: .degrees(180))
                        .scaleEffect(0.5)
                }
                .accessibilityLabel("Decrease count")
                
                
                VStack(spacing: 12) {
                    Text("\(count)")
                        .font(.system(size: 72, weight: .bold, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white.opacity(0.9), .white.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width:40,height: 70 )
                        .modifier(ShakeEffect(animatableData: shake))
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: count)
      
                }

                // Increment Button
                Button {
                    if count < 4 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            count += 1
                            showError = false
                        }
                    } else {
                        // Shake animation when limit exceeded
                        withAnimation(.default) {
                            shake += 1
                        }
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showError = true
                        }
                    }
                } label: {
                    ArrowButton(rotation: .degrees(0))
                        .scaleEffect(0.5)
                }
                .accessibilityLabel("Increase count")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(red: 67/255, green: 80/255, blue: 89/255)
            .ignoresSafeArea()
        
        CounterView()
    }
}

