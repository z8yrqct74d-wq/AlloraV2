import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(alignment: .bottom) {
                // Background gradient
            }
            .frame(height: 104)
            .background(
                LinearGradient(
                    colors: [Color.alloraCream, Color.alloraCream.opacity(0)],
                    startPoint: .bottom, endPoint: .top
                )
            )
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 6) {
                // Home tab
                Button {
                    state.setTab(.home)
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: "house")
                            .font(.system(size: 22, weight: .regular))
                        Text("Home")
                            .font(AlloraFont.grotesk(10, weight: .bold))
                            .kerning(0.2)
                    }
                    .foregroundColor(state.activeTab == .home ? .alloraTerracotta : Color(hex: "#9A8E7B"))
                    .padding(.horizontal, 17)
                    .padding(.vertical, 9)
                    .background(state.activeTab == .home ? Color.alloraTerracotta.opacity(0.12) : Color.clear)
                    .clipShape(Capsule())
                }
                .buttonStyle(AlloraButtonStyle())

                // Ask tab (center orb)
                Button {
                    state.go(.composer)
                } label: {
                    VStack(spacing: 3) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color(hex: "#D2693F"), Color(hex: "#A53E20")],
                                        center: .init(x: 0.38, y: 0.30),
                                        startRadius: 0, endRadius: 21
                                    )
                                )
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

                // Pulse tab
                Button {
                    state.setTab(.pulse)
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: "waveform.path")
                            .font(.system(size: 22, weight: .regular))
                        Text("Pulse")
                            .font(AlloraFont.grotesk(10, weight: .bold))
                            .kerning(0.2)
                    }
                    .foregroundColor(state.activeTab == .pulse ? .alloraTerracotta : Color(hex: "#9A8E7B"))
                    .padding(.horizontal, 17)
                    .padding(.vertical, 9)
                    .background(state.activeTab == .pulse ? Color.alloraTerracotta.opacity(0.12) : Color.clear)
                    .clipShape(Capsule())
                }
                .buttonStyle(AlloraButtonStyle())
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
    }
}
