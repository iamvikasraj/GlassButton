import SwiftUI
import CoreMotion
internal import Combine

// MARK: - Device Motion → Always-Up Arrow
final class MotionManager: ObservableObject {
    private let manager = CMMotionManager()
    private let queue   = OperationQueue()
    
    @Published var rotation: Angle = .degrees(0)   // angle for the arrow
    
    init() {
        manager.deviceMotionUpdateInterval = 1 / 30
        start()
    }
    
    private func start() {
        guard manager.isDeviceMotionAvailable else { return }
        
        manager.startDeviceMotionUpdates(to: queue) { [weak self] motion, _ in
            guard let yaw = motion?.attitude.yaw else { return }
            // negative yaw so arrow points toward device "top"
            DispatchQueue.main.async { self?.rotation = .radians(-yaw) }
        }
    }
    
    deinit { manager.stopDeviceMotionUpdates() }
}

// MARK: - Custom Colors & Gradients
extension Color {
    static let customGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 67/255, green: 80/255, blue: 89/255), location: 0.0),
            .init(color: Color(red: 93/255, green: 106/255, blue: 114/255), location: 0.30),
            .init(color: Color(red: 120/255, green: 133/255, blue: 141/255), location: 0.59),
            .init(color: Color(red: 116/255, green: 123/255, blue: 129/255), location: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let buttonFill = Color(red: 120/255, green: 133/255, blue: 141/255)
}

// MARK: - Press Gesture Extension
extension View {
    func onPressGesture(pressing: @escaping (Bool) -> Void, perform: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressing(true) }
                .onEnded { _ in
                    pressing(false)
                    perform()
                }
        )
    }
}

// MARK: - MultiStrokeButton with Motion Control
struct MultiStrokeButton: View {
    let rotation: Angle          // arrow rotation supplied by MotionManager
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            action()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }) {
            ZStack {
                // Blue circle inside
                Rectangle()
                               .foregroundColor(.clear)
                               .frame(width: 90, height: 90)
                               .background(
                               LinearGradient(
                               stops: [
                               Gradient.Stop(color: Color(red: 0.48, green: 0.52, blue: 0.55), location: 0.00),
                               Gradient.Stop(color: Color(red: 0.64, green: 0.67, blue: 0.7), location: 1.00),
                               ],
                               startPoint: UnitPoint(x: 0.5, y: 0),
                               endPoint: UnitPoint(x: 0.5, y: 1)
                               )
                               )
                               .cornerRadius(410)
                               .blur(radius: 8)
                               .offset(y: 14)
                
                // Arrow on top
                Image("arrow")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.white)
                    .rotationEffect(rotation)           // Apply motion rotation here
                    .shadow(color: .black.opacity(0.2), radius: 3, y: 8)
            }
            .frame(width: 125, height: 125)
            .background(Color.buttonFill)
            .clipShape(Circle())

                // Stroke 1: Top-left white highlight
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0.8), location: 0.0),  // bright top
                                    .init(color: Color.white.opacity(0.0), location: 0.3)   // fades out
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 3
                        )
                        .offset(x: 0, y: 0)       // slight downward shift to catch the light
                        .rotationEffect(rotation)  // Rotate with arrow
                        .blendMode(.normal)
                )
            
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.black.opacity(0.4), location: 0.0),   // strong dark at start
                                    .init(color: Color.black.opacity(0.0), location: 0.1)    // quick fade
                                ]),
                                startPoint: .leading,
                                endPoint: .topTrailing
                            ),
                            lineWidth: 3
                        )
                        .offset(x: 0, y: 0)
                        .rotationEffect(rotation)  // Rotate with arrow
                        .blendMode(.darken)
                )
            
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.black.opacity(0.4), location: 0.0),   // strong dark at start
                                    .init(color: Color.black.opacity(0.0), location: 0.1)    // quick fade
                                ]),
                                startPoint: .trailing,
                                endPoint: .topLeading
                            ),
                            lineWidth: 3
                        )
                        .offset(x: 0, y: 0)
                        .rotationEffect(rotation)  // Rotate with arrow
                        .blendMode(.darken)
                )
            
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0.8), location: 0.1),  // bright top
                                    .init(color: Color.white.opacity(0.0), location: 0.4)   // fades out
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            ),
                            lineWidth: 2
                        )
                        .offset(x: 0, y: 0)       // slight downward shift to catch the light
                        .rotationEffect(rotation)  // Rotate with arrow
                        .blendMode(.overlay)
                )
            }
        .buttonStyle(.plain)
//        .shadow(color: .white.opacity(isPressed ? 0.1 : 0.1), radius: isPressed ? 8 : 4, y: isPressed ? 8 :8)
        .scaleEffect(isPressed ? 0.94 : 1)
        .animation(.easeOut(duration: 0.25), value: isPressed)
        .onPressGesture(
            pressing: { pressing in isPressed = pressing },
            perform: {}
        )
        
    }
}

// MARK: - Demo Screen
struct ArrowUpDemoView: View {
    @StateObject private var motion = MotionManager()
    
    var body: some View {
        ZStack {
            Color.customGradient
                .ignoresSafeArea()
            
            MultiStrokeButton(rotation: motion.rotation) {
                print("Arrow button tapped")
            }
        }
    }
}

// MARK: - Preview
#Preview
{
ArrowUpDemoView()
}
