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
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - JSB View (Jordan Singer Button)
struct JSBView: View {
    @State private var count: Int = 1
    @State private var shake: CGFloat = 0
    @State private var showError: Bool = false

    var body: some View {
        HStack(spacing: -12) {
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
                    .scaleEffect(0.30)
            }
            .buttonStyle(ScaleButtonStyle())
            .accessibilityLabel("Decrease count")
            
            HStack(){
                Text("\(count)")
                    .font(.system(size: 30, weight: .semibold, design: .monospaced))
                    .modifier(ShakeEffect(animatableData: shake))
                    .contentTransition(.numericText(countsDown: (count != 0)))
                    .animation(.spring(response: 0.8, dampingFraction: 0.9), value: count)
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
                ArrowButton(rotation: .degrees(0), imageName: "plus")
                    .scaleEffect(0.30)
            }
            .buttonStyle(ScaleButtonStyle())
            
            .accessibilityLabel("Increase count")
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        MetalBackground(shaderType: .animatedMetallic)
        JSBView()
    }
}

