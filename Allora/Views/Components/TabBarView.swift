import SwiftUI

/// Floating "liquid glass" navigation bar (Home / Ask / Pulse).
///
/// A translucent, blurred capsule that hovers above the content with a soft
/// drop shadow and inner highlight, plus a bottom fade so scrolling content
/// dissolves underneath it. The center "Ask" control is the orb-colored
/// primary action.
struct TabBarView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            // Bottom fade so content melts under the bar.
            LinearGradient(
                colors: [Color.alloraCream, Color.alloraCream.opacity(0)],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 104)
            .allowsHitTesting(false)

            HStack(spacing: 6) {
                tab(icon: "house", label: "Home", active: state.activeTab == .home) {
                    state.setTab(.home)
                }

                askButton

                tab(icon: "waveform.path", label: "Pulse", active: state.activeTab == .pulse) {
                    state.setTab(.pulse)
                }
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(Color(hex: "#FAF4E9").opacity(0.72))
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.6)))
                    .shadow(color: Color(hex: "#3C2412").opacity(0.5), radius: 23, y: 11)
            )
            .padding(.bottom, 22)
        }
        .ignoresSafeArea()
    }

    private func tab(icon: String, label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .regular))
                Text(label)
                    .font(AlloraFont.grotesk(10, weight: .bold))
                    .kerning(0.2)
            }
            .foregroundColor(active ? .alloraTerracotta : Color(hex: "#9A8E7B"))
            .padding(.horizontal, 17)
            .padding(.vertical, 9)
            .background(active ? Color.alloraTerracotta.opacity(0.12) : Color.clear)
            .clipShape(Capsule())
        }
        .buttonStyle(AlloraButtonStyle())
    }

    private var askButton: some View {
        Button { state.go(.composer) } label: {
            VStack(spacing: 3) {
                ZStack {
                    Circle()
                        .fill(RadialGradient(
                            colors: [Color(hex: "#D2693F"), Color(hex: "#A53E20")],
                            center: .init(x: 0.38, y: 0.30),
                            startRadius: 0, endRadius: 21
                        ))
                        .shadow(color: Color(hex: "#A53E20").opacity(0.6), radius: 10, y: 5)
                    Image(systemName: "sparkle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#FCEBD6"))
                }
                .frame(width: 42, height: 42)
                Text("Ask")
                    .font(AlloraFont.grotesk(10, weight: .bold))
                    .kerning(0.2)
                    .foregroundColor(Color(hex: "#A53E20"))
            }
            .padding(.horizontal, 6)
        }
        .buttonStyle(AlloraButtonStyle())
    }
}
