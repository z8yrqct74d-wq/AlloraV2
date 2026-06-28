import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState
    @State private var ringPulse1 = false
    @State private var ringPulse2 = false
    @State private var orbFloat = false

    let prompts = ["Cozy for two", "Date night", "Something lively", "New near me", "Good wine", "Available now"]
    let promptQueries: [String: String] = [
        "Cozy for two": "A cozy place nearby for two around 8, not too expensive",
        "Date night": "Somewhere romantic but relaxed for two tonight",
        "Something lively": "Somewhere lively with friends tonight",
        "New near me": "Show me somewhere new and memorable near me",
        "Good wine": "Good wine and a warm room, available now",
        "Available now": "Best table available near me right now",
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.alloraCream.ignoresSafeArea()

            // Ambient blobs
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#D4965A").opacity(0.36), .clear], center: .center, startRadius: 0, endRadius: 92))
                    .blur(radius: 22)
                    .frame(width: 184, height: 184)
                    .offset(x: -70, y: 0)
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#BC5230").opacity(0.26), .clear], center: .center, startRadius: 0, endRadius: 76))
                    .blur(radius: 22)
                    .frame(width: 152, height: 152)
                    .offset(x: 80, y: -70)
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#9676B2").opacity(0.2), .clear], center: .center, startRadius: 0, endRadius: 56))
                    .blur(radius: 20)
                    .frame(width: 112, height: 112)
                    .offset(x: 40, y: 160)
            }
            .frame(maxWidth: .infinity)
            .offset(y: 96)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Friday evening · 18° clear")
                                .font(AlloraFont.grotesk(11, weight: .bold))
                                .kerning(1.6)
                                .textCase(.uppercase)
                                .foregroundColor(.alloraGold)
                            Text("Good evening, Andrei")
                                .font(AlloraFont.newsreader(22))
                                .foregroundColor(Color(hex: "#3A3128"))
                        }
                        Spacer()
                        Button { state.go(.taste) } label: {
                            ZStack {
                                Circle()
                                    .fill(RadialGradient(
                                        colors: [Color(hex: "#CD8F5C"), Color(hex: "#7E4A2C")],
                                        center: .init(x: 0.32, y: 0.30),
                                        startRadius: 0, endRadius: 22
                                    ))
                                    .overlay(Circle().stroke(Color(hex: "#FCEBD6").opacity(0.35), lineWidth: 2))
                                    .shadow(color: .black.opacity(0.55), radius: 7, y: 3)
                                Text("A")
                                    .font(AlloraFont.grotesk(15, weight: .bold))
                                    .foregroundColor(Color(hex: "#F7ECDB"))
                            }
                            .frame(width: 44, height: 44)
                        }
                        .buttonStyle(CircleButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 64)

                    // Orb CTA button
                    Button { state.go(.composer) } label: {
                        VStack(spacing: 0) {
                            ZStack {
                                // Pulse rings
                                Circle()
                                    .stroke(Color(hex: "#BC5230").opacity(0.28), lineWidth: 1)
                                    .frame(width: 166, height: 166)
                                    .scaleEffect(ringPulse1 ? 1.55 : 0.6)
                                    .opacity(ringPulse1 ? 0 : 0.6)
                                Circle()
                                    .stroke(Color(hex: "#BC5230").opacity(0.2), lineWidth: 1)
                                    .frame(width: 166, height: 166)
                                    .scaleEffect(ringPulse2 ? 1.55 : 0.6)
                                    .opacity(ringPulse2 ? 0 : 0.6)

                                AlloraOrbView(mode: orbModeForState, size: 158)
                                    .offset(y: orbFloat ? -9 : 0)
                            }
                            .frame(width: 196, height: 196)

                            Text("Where should we go,\n")
                                .font(AlloraFont.newsreader(31))
                                .foregroundColor(Color(hex: "#241D14"))
                                + Text("tonight?")
                                .font(AlloraFont.newsreader(31, italic: true))
                                .foregroundColor(.alloraTerracotta)

                            HStack(spacing: 8) {
                                Image(systemName: "sparkle")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.alloraTerracotta)
                                Text("Type, speak, or tap a feeling")
                                    .font(AlloraFont.grotesk(13.5, weight: .semibold))
                                    .foregroundColor(Color(hex: "#7A6E5C"))
                            }
                            .padding(.horizontal, 17)
                            .padding(.vertical, 10)
                            .background(Color(hex: "#FCF8F0").opacity(0.66))
                            .background(.ultraThinMaterial)
                            .overlay(Capsule().stroke(Color.white.opacity(0.55)))
                            .clipShape(Capsule())
                            .shadow(color: Color(hex: "#3C2814").opacity(0.7), radius: 13, y: 6)
                            .padding(.top, 14)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }
                    .buttonStyle(AlloraButtonStyle())

                    // Prompt chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 9) {
                            ForEach(prompts, id: \.self) { prompt in
                                Button {
                                    state.pulseOrb()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        state.openComposerWith(promptQueries[prompt] ?? prompt)
                                    }
                                } label: {
                                    Text(prompt)
                                        .font(AlloraFont.grotesk(13.5, weight: .semibold))
                                        .foregroundColor(Color(hex: "#4A4136"))
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "#EAE0CF"))
                                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color(hex: "#221D17").opacity(0.06)))
                                        .clipShape(RoundedRectangle(cornerRadius: 13))
                                }
                                .buttonStyle(AlloraButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 2)
                    }
                    .padding(.top, 20)

                    // Memory card (show after booking)
                    if state.booked && !state.fedback {
                        Button { state.go(.feedback) } label: {
                            HStack(spacing: 13) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#23160F"))
                                    .overlay(RestaurantPlaceholderImage(name: "MAT", color: Color(hex: "#BC5230")).clipShape(RoundedRectangle(cornerRadius: 12)))
                                    .frame(width: 46, height: 46)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.06)))
                                VStack(alignment: .leading, spacing: 1) {
                                    SectionLabel(text: "Last night")
                                    Text("How was MAT?")
                                        .font(AlloraFont.newsreader(19))
                                        .foregroundColor(Color(hex: "#2A231A"))
                                    Text("Tell Allora, so tonight fits better")
                                        .font(AlloraFont.grotesk(12.5, weight: .medium))
                                        .foregroundColor(.alloraMuted)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.alloraTerracotta)
                            }
                            .padding(13)
                            .background(LinearGradient(colors: [Color(hex: "#F7ECDB"), Color(hex: "#F4E7D2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.alloraBorder))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(AlloraButtonStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }

                    // Allora's pick
                    VStack(alignment: .leading, spacing: 12) {
                        SectionLabel(text: "Allora's pick of the night")
                            .padding(.horizontal, 20)
                        PickOfNightCard(restaurant: Restaurant.pickOfNight) {
                            state.openDetail("sare")
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)

                    // Available now
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available now, near you")
                            .font(AlloraFont.newsreader(22, weight: .medium))
                            .foregroundColor(Color(hex: "#241D14"))
                            .padding(.horizontal, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                RestaurantTileCard(restaurant: Restaurant.all["mat"]!, meta: "8 min · 20:00") { state.openDetail("mat") }
                                RestaurantTileCard(restaurant: Restaurant.all["foaie"]!, meta: "14 min · 20:15") { state.openDetail("foaie") }
                                RestaurantTileCard(restaurant: Restaurant.all["lumina"]!, meta: "11 min · 20:30") { state.openDetail("lumina") }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 30)

                    // City pulse CTA
                    Button { state.setTab(.pulse) } label: {
                        HStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 2) {
                                SectionLabel(text: "Tonight in Bucharest")
                                Text("See what the city is doing")
                                    .font(AlloraFont.newsreader(21))
                                    .foregroundColor(Color(hex: "#F4EADB"))
                                    .padding(.top, 3)
                                Text("Best tables, hidden gems, terraces")
                                    .font(AlloraFont.grotesk(12.5, weight: .medium))
                                    .foregroundColor(Color(hex: "#B6A78C"))
                                    .padding(.top, 2)
                            }
                            Spacer()
                            Circle()
                                .fill(Color(hex: "#C2904A"))
                                .frame(width: 38, height: 38)
                                .overlay(Image(systemName: "arrow.right").font(.system(size: 16, weight: .semibold)).foregroundColor(Color(hex: "#241D14")))
                        }
                        .padding(18)
                        .background(Color(hex: "#241D14"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(AlloraButtonStyle())
                    .padding(.horizontal, 20)
                    .padding(.top, 30)

                    // Book again
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Book again")
                            .font(AlloraFont.newsreader(22, weight: .medium))
                            .foregroundColor(Color(hex: "#241D14"))
                            .padding(.horizontal, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                RestaurantTileCard(restaurant: Restaurant.all["kane"]!, meta: "Booked in May") { state.openDetail("kane") }
                                RestaurantTileCard(restaurant: Restaurant.all["oraopt"]!, meta: "Your kind of place") { state.openDetail("oraopt") }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: false)) { ringPulse1 = true }
            withAnimation(.easeInOut(duration: 3.6).delay(1.8).repeatForever(autoreverses: false)) { ringPulse2 = true }
            withAnimation(.easeInOut(duration: 5.6).repeatForever(autoreverses: true)) { orbFloat = true }
        }
    }

    private var orbModeForState: OrbDisplayMode {
        switch state.orbMode {
        case .thinking: return .thinking
        case .converge: return .converge
        case .idle: return .idle
        }
    }
}
