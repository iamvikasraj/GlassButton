import SwiftUI

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

// MARK: - Arrow Button View
struct ArrowButton: View {
    var rotation: Angle = .zero

    var body: some View {
        ZStack {
            // Base Fill Circle + Stroke Overlays
            Circle()
                .fill(Color.buttonFill)
                .frame(width: 125, height: 125)
                .overlay(strokeOverlay) // ✅ Single overlay layer

            // Blurred Reflection Layer Behind
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 90, height: 90)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.48, green: 0.52, blue: 0.55), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.64, green: 0.67, blue: 0.7), location: 1.00),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(410)
                .blur(radius: 8)
                .offset(y: 14)

            // Arrow Image
            Image("arrow")
                .rotationEffect(rotation)
                .shadow(color: .black.opacity(0.1), radius: 1, y: 1)
        }
        .contentShape(Circle())
    }

    // MARK: - Stroke Overlay Layer (Single Application)
    var strokeOverlay: some View {
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
        // ✅ Ensures it's all part of a single overlay — NOT stacked circles.
    }
}


struct ArrowDateSelectorView: View {
    @State private var currentDate = Date()

    var body: some View {
        ZStack {
            Color.customGradient
                .ignoresSafeArea()

            HStack(spacing: -30) {
                // Decrement Button (Previous Day)
                
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    ArrowButton(rotation: .degrees(180))
                        .scaleEffect(0.4)
                }

                // Date Display
                VStack(spacing: 4) {
                    // Top Label: "Today", "Tomorrow", "Yesterday", or Date
                    Text(formattedLabel)
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.25, dampingFraction: 0.5), value: formattedLabel)
                        

                    // Bottom Label: Visible only for Today, Tomorrow, Yesterday
                    if showsDetailedDate {
                        Text(currentDate.formatted(.dateTime.weekday().month().day()))
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.white.opacity(0.6))
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: formattedLabel)
                            
                    }
                }
                .frame(width: 120)

                // Increment Button (Next Day)
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    ArrowButton(rotation: .degrees(0))
                        .scaleEffect(0.4)
                }
            }
            .padding()
        }
    }

    // Top Label Logic
    private var formattedLabel: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(currentDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(currentDate) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(currentDate) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMMMd") // e.g., "July 21"
            return formatter.string(from: currentDate)
        }
    }

    // Should we show the detailed label below?
    private var showsDetailedDate: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(currentDate)
            || calendar.isDateInTomorrow(currentDate)
            || calendar.isDateInYesterday(currentDate)
    }
}




struct AnimatedCounterText: View {
    let number: Int
    @State private var animate = false

    var body: some View {
        Text(String(number))
            .font(.system(size: 60, weight: .regular, design: .default))
            .contentTransition(.numericText())
            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: animate)
    }
}

// MARK: - Preview
#Preview {
    ArrowDateSelectorView()
}
