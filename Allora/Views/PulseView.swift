import SwiftUI

struct PulseView: View {
    @EnvironmentObject var state: AppState

    let availIds = ["mat", "lumina", "foaie", "noua"]
    let availMeta = ["650 m · 20:00", "900 m · 20:30", "1.1 km · 20:15", "1.6 km · 20:30"]
    let cozyIds = ["cuib", "mat", "oraopt"]
    let cozyMeta = ["Hidden gem", "Candlelit", "For two"]
    let newIds = ["verde", "sare", "lumina"]
    let newMeta = ["New on Allora", "Pick of the night", "Just added"]

    var body: some View {
        ZStack(alignment: .top) {
            Color.alloraCream.ignoresSafeArea()

            // Ambient
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#BC5230").opacity(0.22), .clear], center: .center, startRadius: 0, endRadius: 88))
                    .blur(radius: 24).frame(width: 176, height: 176).offset(x: 90, y: 0)
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#9676B2").opacity(0.18), .clear], center: .center, startRadius: 0, endRadius: 73))
                    .blur(radius: 22).frame(width: 146, height: 146).offset(x: -90, y: 90)
            }
            .offset(y: 36)
            .allowsHitTesting(false)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Friday, 27 June".uppercased())
                            .font(AlloraFont.grotesk(11, weight: .bold))
                            .kerning(1.6)
                            .foregroundColor(.alloraGold)
                        (Text("Tonight in ").font(AlloraFont.newsreader(34, weight: .medium))
                         + Text("Bucharest").font(AlloraFont.newsreader(34, italic: true)).foregroundColor(.alloraTerracotta))
                            .foregroundColor(Color(hex: "#241D14"))
                            .padding(.top, 5)
                        Text("What the city is reaching for after dark.")
                            .font(AlloraFont.grotesk(13.5, weight: .medium))
                            .foregroundColor(.alloraMuted)
                            .padding(.top, 7)
                        HStack(spacing: 8) {
                            ZStack {
                                Circle().fill(Color.alloraTerracotta.opacity(0.5)).frame(width: 9, height: 9)
                                Circle().fill(Color.alloraTerracotta).frame(width: 7, height: 7)
                            }
                            Text("Lively across the city tonight")
                                .font(AlloraFont.grotesk(12, weight: .bold))
                                .foregroundColor(Color(hex: "#7A4026"))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(hex: "#FCF8F0").opacity(0.66))
                        .background(.ultraThinMaterial)
                        .overlay(Capsule().stroke(Color.white.opacity(0.55)))
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: "#3C2814").opacity(0.6), radius: 10, y: 5)
                        .padding(.top, 14)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 64)

                    // Pick of night
                    PickOfNightCard(restaurant: Restaurant.pickOfNight, action: { state.openDetail("sare") }, height: 250)
                        .padding(.horizontal, 20)
                        .padding(.top, 22)

                    // Best tables available now
                    pulseSection(title: "Best tables, available now", ids: availIds, metas: availMeta)

                    // Cozy this week
                    pulseSection(title: "Cozy this week", ids: cozyIds, metas: cozyMeta)

                    // New & hidden (list style)
                    Text("New & hidden")
                        .font(AlloraFont.newsreader(22, weight: .medium))
                        .foregroundColor(Color(hex: "#241D14"))
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 12)
                    VStack(spacing: 11) {
                        ForEach(Array(newIds.enumerated()), id: \.offset) { i, id in
                            let r = Restaurant.all[id]!
                            Button { state.openDetail(id) } label: {
                                HStack(spacing: 13) {
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color(hex: "#23160F"))
                                        .overlay(RestaurantPlaceholderImage(name: r.name, color: r.roleColor).clipShape(RoundedRectangle(cornerRadius: 13)))
                                        .frame(width: 60, height: 60)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(r.name)
                                            .font(AlloraFont.newsreader(20))
                                            .foregroundColor(Color(hex: "#241D14"))
                                        Text("\(r.kind) · \(r.area)")
                                            .font(AlloraFont.grotesk(12, weight: .semibold))
                                            .foregroundColor(Color(hex: "#7A7063"))
                                        Text(newMeta[i].uppercased())
                                            .font(AlloraFont.grotesk(11, weight: .bold))
                                            .kerning(0.4)
                                            .foregroundColor(Color(hex: "#9A4429"))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color(hex: "#C2B6A0"))
                                }
                                .padding(11)
                                .background(Color(hex: "#FCF8F0"))
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.08)))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(AlloraButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }

    private func pulseSection(title: String, ids: [String], metas: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AlloraFont.newsreader(22, weight: .medium))
                .foregroundColor(Color(hex: "#241D14"))
                .padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Array(ids.enumerated()), id: \.offset) { i, id in
                        RestaurantTileCard(restaurant: Restaurant.all[id]!, meta: metas[i]) { state.openDetail(id) }
                            .frame(width: 158)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 30)
    }
}
