import SwiftUI

// MARK: - Stroke Overlay Modifier
private struct CircularSteelStrokeOverlay: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(strokeLayer)
    }

    private var strokeLayer: some View {
        ZStack {
            // Stroke 1 - ~45° (diagonal, left to top-right)
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

            // Stroke 2 - ~135° (diagonal, right to top-left)
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

            // Stroke 3 - 180° (vertical, bottom to top)
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
                    lineWidth: 8
                )
                .blendMode(.normal)

            // Stroke 4 - 90° (vertical, top to bottom)
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.8), location: 0.1),
                            .init(color: .white.opacity(0.0), location: 0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 8
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
    var imageName: String = "jd"

    var body: some View {
        ZStack {
            // Base Fill Circle + Stroke Overlays
            Circle()
                .fill(
                  
                    LinearGradient(
                    stops: [
                    Gradient.Stop(color: Color(red: 0.73, green: 0.73, blue: 0.73), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.51, green: 0.51, blue: 0.51), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0.07),
                    endPoint: UnitPoint(x: 0.5, y: 1)
)   
                    )
                .frame(width: 125, height: 125)
                .overlay(
                Circle()
                .inset(by: 0)
                .stroke(.white, lineWidth: 3)
                )
                .blendMode(.overlay)
            
                .overlay(
                Circle()
                .inset(by: -2)
                .stroke(.black, lineWidth: 4)
                )
                .blendMode(.overlay)
                .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 16)
                .circularSteelStrokeOverlay()

            
// Blurred Reflection Layer Behind
//            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                .fill(
//                    LinearGradient(
//                        stops: [
//                            Gradient.Stop(color: Color(red: 0.48, green: 0.52, blue: 0.55), location: 0.00),
//                            Gradient.Stop(color: Color(red: 0.64, green: 0.67, blue: 0.70), location: 1.00),
//                        ],
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//                .frame(width: 90, height: 90)
//                .blur(radius: 8)
//                .offset(y: 14)

            // Arrow Image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:48)
                .rotationEffect(rotation)
                .shadow(color: .black.opacity(0.7),
                        radius: 1,
                        y: -4)
                .accessibilityHidden(true)
        }
        .contentShape(Circle())
        .accessibilityLabel("Arrow button")
    }
}

// MARK: - Shake Animation Modifier
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 3
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
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
                    ArrowButton(rotation: .degrees(0), imageName: "minus")
                        .scaleEffect(0.5)
                }
                .buttonStyle(ScaleButtonStyle())
                .accessibilityLabel("Decrease count")
                
                HStack(){
                    Text("\(count)")
                        .font(.system(size: 72, weight: .bold, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.black.opacity(0.9), .gray.opacity(1.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .modifier(ShakeEffect(animatableData: shake))
                        .contentTransition(.numericText())
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.9), value: count)
                }
                .frame(width: 60)
                
                

                // Increment Button
                Button {
                    if count < 9 {
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
                    ArrowButton(rotation: .degrees(0), imageName: "plus")
                        .scaleEffect(0.5)
                }
                .buttonStyle(ScaleButtonStyle())
                .accessibilityLabel("Increase count")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(Color(red: 0.92, green: 0.92, blue: 0.92))
            .ignoresSafeArea()
        
        CounterView()
    }
}

