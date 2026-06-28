import SwiftUI

struct ComposerView: View {
    @EnvironmentObject var state: AppState
    @FocusState private var textFocused: Bool
    @State private var micRingScale: CGFloat = 1
    @State private var micRingOpacity: Double = 0.55

    let examples = [
        "Find me a cozy place nearby for two around 8, not too expensive",
        "Somewhere romantic but relaxed",
        "Good wine and a warm room, available now",
        "Somewhere lively with friends tonight",
    ]

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color(hex: "#F7F0E3"), Color(hex: "#EFE5D2")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // Ambient
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#D2693F").opacity(0.22), .clear], center: .center, startRadius: 0, endRadius: 120))
                    .blur(radius: 28)
                    .frame(width: 240, height: 240)
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#9676B2").opacity(0.18), .clear], center: .center, startRadius: 0, endRadius: 66))
                    .blur(radius: 22)
                    .frame(width: 132, height: 132)
                    .offset(x: 80, y: -30)
            }
            .offset(y: 64)
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    BackButton { state.back() }
                    Spacer()
                    Text("Ask Allora")
                        .font(AlloraFont.grotesk(12, weight: .bold))
                        .kerning(1.6)
                        .textCase(.uppercase)
                        .foregroundColor(.alloraGold)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 18)
                .padding(.top, 60)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Small orb
                        AlloraOrbView(mode: .idle, size: 84)
                            .padding(.top, 14)

                        Text("Tell me what tonight\n")
                            .font(AlloraFont.newsreader(28))
                            .foregroundColor(Color(hex: "#241D14"))
                            + Text("feels like.")
                            .font(AlloraFont.newsreader(28, italic: true))
                            .foregroundColor(.alloraTerracotta)

                        // Input card
                        VStack(spacing: 0) {
                            TextField("e.g. a cozy place for two, around 8…", text: $state.query, axis: .vertical)
                                .font(AlloraFont.grotesk(18, weight: .medium))
                                .foregroundColor(Color(hex: "#241D14"))
                                .lineLimit(3...6)
                                .focused($textFocused)
                                .padding(.horizontal, 17)
                                .padding(.top, 17)
                                .padding(.bottom, 8)

                            Divider()
                                .background(Color(hex: "#221D17").opacity(0.08))
                                .padding(.horizontal, 17)

                            // Mic row
                            HStack {
                                Button { state.simulateMic() } label: {
                                    HStack(spacing: 9) {
                                        ZStack {
                                            if state.listening {
                                                Circle()
                                                    .fill(Color.alloraTerracotta)
                                                    .frame(width: 34, height: 34)
                                                    .scaleEffect(micRingScale)
                                                    .opacity(micRingOpacity)
                                            }
                                            Circle()
                                                .fill(Color(hex: "#F0E3CE"))
                                                .frame(width: 34, height: 34)
                                            Image(systemName: "mic")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.alloraTerracotta)
                                        }
                                        Text(state.listening ? "Listening…" : "Speak")
                                            .font(AlloraFont.grotesk(13, weight: .semibold))
                                            .foregroundColor(.alloraMuted)
                                    }
                                }
                                .buttonStyle(AlloraButtonStyle())
                                Spacer()
                            }
                            .padding(.horizontal, 17)
                            .padding(.vertical, 11)
                        }
                        .background(Color(hex: "#FCF8F0").opacity(0.62))
                        .background(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.62)))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: Color(hex: "#3C2814").opacity(0.6), radius: 20, y: 10)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // Examples
                        VStack(alignment: .leading, spacing: 9) {
                            Text("Try saying")
                                .font(AlloraFont.grotesk(11, weight: .bold))
                                .kerning(1.4)
                                .textCase(.uppercase)
                                .foregroundColor(Color(hex: "#A2967F"))
                                .padding(.horizontal, 22)
                                .padding(.top, 26)

                            ForEach(examples, id: \.self) { example in
                                Button { state.query = example } label: {
                                    HStack(alignment: .top, spacing: 11) {
                                        Text("\u{201C}")
                                            .font(AlloraFont.newsreader(24))
                                            .foregroundColor(Color(hex: "#C9A06A"))
                                            .frame(height: 14)
                                        Text(example)
                                            .font(AlloraFont.grotesk(14.5, weight: .medium))
                                            .foregroundColor(Color(hex: "#463D31"))
                                            .multilineTextAlignment(.leading)
                                            .lineSpacing(3)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 13)
                                    .background(Color(hex: "#FBF6ED"))
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#221D17").opacity(0.07)))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                .buttonStyle(AlloraButtonStyle())
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }

                // Submit button
                if !state.query.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button { state.submit() } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkle")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#FBF3E6"))
                            Text("Find tables")
                                .font(AlloraFont.grotesk(16, weight: .bold))
                                .foregroundColor(Color(hex: "#FBF3E6"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color.alloraTerracotta)
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                        .shadow(color: Color.alloraTerracotta.opacity(0.65), radius: 15, y: 7)
                    }
                    .buttonStyle(AlloraButtonStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.alloraSpring, value: state.query)
                }
            }
        }
        .onAppear {
            if state.listening {
                withAnimation(.easeOut(duration: 1.3).repeatForever(autoreverses: false)) {
                    micRingScale = 2.1
                    micRingOpacity = 0
                }
            }
        }
    }
}
