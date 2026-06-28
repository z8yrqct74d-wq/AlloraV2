import SwiftUI

struct SplashView: View {
    @EnvironmentObject var state: AppState
    @State private var glowPulse = false
    @State private var starFloat = false
    @State private var appeared = false

    var body: some View {
        ZStack {
            // Dark background
            LinearGradient(
                colors: [Color(hex: "#3C2B1E"), Color(hex: "#241811"), Color(hex: "#150E0A")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Ambient glow
            Circle()
                .fill(RadialGradient(
                    colors: [Color(hex: "#C06731").opacity(0.42), .clear],
                    center: .center, startRadius: 0, endRadius: 170
                ))
                .blur(radius: 8)
                .scaleEffect(glowPulse ? 1.08 : 1.0)
                .opacity(glowPulse ? 0.95 : 0.45)
                .frame(width: 340, height: 340)
                .offset(y: -UIScreen.main.bounds.height * 0.18)

            VStack {
                Spacer()
                VStack(spacing: 0) {
                    // City tag
                    Text("Bucharest")
                        .font(AlloraFont.grotesk(12, weight: .bold))
                        .kerning(3.4)
                        .textCase(.uppercase)
                        .foregroundColor(Color(hex: "#C99A5E"))
                        .padding(.bottom, 26)

                    // Logo
                    Text("Allora")
                        .font(AlloraFont.newsreader(74, weight: .light))
                        .foregroundColor(Color(hex: "#F6ECDC"))
                        .kerning(-0.9)

                    // Tagline
                    Text("where should we\ngo tonight?")
                        .font(AlloraFont.newsreader(23, italic: true))
                        .foregroundColor(Color(hex: "#D8C3A6"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.top, 20)
                }
                Spacer()

                // Tap to begin
                VStack(spacing: 14) {
                    Image(systemName: "sparkle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#C99A5E"))
                    Text("Tap to begin")
                        .font(AlloraFont.grotesk(13, weight: .semibold))
                        .kerning(0.5)
                        .foregroundColor(Color(hex: "#B6A488"))
                }
                .offset(y: starFloat ? -5 : 0)
                .padding(.bottom, 60)
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .onTapGesture {
            state.replace(.home)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { appeared = true }
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
            withAnimation(.easeInOut(duration: 3.4).repeatForever(autoreverses: true)) {
                starFloat = true
            }
        }
    }
}
