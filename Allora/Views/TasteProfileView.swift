import SwiftUI

struct TasteProfileView: View {
    @EnvironmentObject var state: AppState
    @State private var glowPulse = false

    let sigTags = ["Candlelit", "Intimate", "Wine-led", "Walkable"]
    let tasteMoods = ["Cozy for two", "Date night", "Good wine", "Somewhere new"]
    let stats = [("12", "Evenings"), ("6", "Saved"), ("5", "Areas")]
    let hoods = [("Lipscani", "5 visits", 1.0), ("Old Town", "3 visits", 0.6), ("Cotroceni", "2 visits", 0.4)]
    let lovedIds = ["mat", "oraopt", "kane"]
    let lovedMeta = ["Booked twice · loved", "Your kind of place", "A regular"]
    let tryIds = ["lumina", "cuib"]
    let tryMeta = ["Wine-led, like you", "Hidden & intimate"]

    var body: some View {
        ZStack(alignment: .top) {
            Color.alloraCream.ignoresSafeArea()

            // Ambient
            ZStack {
                Circle().fill(RadialGradient(colors: [Color(hex: "#D2693F").opacity(0.2), .clear], center: .center, startRadius: 0, endRadius: 120))
                    .blur(radius: 28).frame(width: 240, height: 240).offset(y: 0)
                Circle().fill(RadialGradient(colors: [Color(hex: "#9676B2").opacity(0.16), .clear], center: .center, startRadius: 0, endRadius: 75))
                    .blur(radius: 22).frame(width: 150, height: 150).offset(x: 90, y: 100)
            }
            .offset(y: 54)
            .allowsHitTesting(false)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Nav
                    HStack {
                        BackButton { state.back() }
                        Spacer()
                        Text("Your Allora")
                            .font(AlloraFont.grotesk(12, weight: .bold))
                            .kerning(1.6)
                            .textCase(.uppercase)
                            .foregroundColor(.alloraGold)
                        Spacer()
                        Color.clear.frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 60)

                    // Avatar
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(RadialGradient(colors: [Color(hex: "#D2693F").opacity(0.4), .clear], center: .center, startRadius: 0, endRadius: 40))
                                .blur(radius: 5)
                                .frame(width: 80, height: 80)
                                .scaleEffect(glowPulse ? 1.05 : 1.0)
                            Circle()
                                .fill(RadialGradient(colors: [Color(hex: "#CD8F5C"), Color(hex: "#7E4A2C")], center: .init(x: 0.32, y: 0.30), startRadius: 0, endRadius: 32))
                                .frame(width: 64, height: 64)
                                .overlay(Text("A").font(AlloraFont.grotesk(24, weight: .bold)).foregroundColor(Color(hex: "#F7ECDB")))
                                .shadow(color: Color(hex: "#78371C").opacity(0.5), radius: 14, y: 7)
                        }
                        Text("Andrei's taste")
                            .font(AlloraFont.newsreader(28, weight: .medium))
                            .foregroundColor(Color(hex: "#241D14"))
                            .padding(.top, 14)
                        Text("Bucharest · 12 evenings together")
                            .font(AlloraFont.newsreader(14.5, italic: true))
                            .foregroundColor(.alloraMuted)
                            .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                    // Usual vibe card
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 7) {
                            AlloraStarIcon(size: 14)
                            Text("Your usual vibe".uppercased())
                                .font(AlloraFont.grotesk(11, weight: .bold))
                                .kerning(0.4)
                                .foregroundColor(.alloraTerracotta)
                        }
                        Text("\u{201C}Warm rooms, low light, and a good wine list. You lean intimate over loud — and you'd rather walk ten minutes than settle for somewhere that doesn't fit the evening.\u{201D}")
                            .font(AlloraFont.newsreader(19))
                            .foregroundColor(Color(hex: "#2A231A"))
                            .lineSpacing(5)
                            .padding(.top, 9)
                        FlowLayout(spacing: 7) {
                            ForEach(sigTags, id: \.self) { tag in
                                Text(tag)
                                    .font(AlloraFont.grotesk(12.5, weight: .semibold))
                                    .foregroundColor(Color(hex: "#7A4026"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(Color(hex: "#F0E3CE"))
                                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color(hex: "#221D17").opacity(0.06)))
                                    .clipShape(RoundedRectangle(cornerRadius: 11))
                            }
                        }
                        .padding(.top, 13)
                    }
                    .padding(18)
                    .background(Color(hex: "#FCF8F0").opacity(0.7))
                    .background(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.55)))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: Color(hex: "#3C2814").opacity(0.5), radius: 20, y: 10)
                    .padding(.horizontal, 20)
                    .padding(.top, 22)

                    // Stats
                    HStack(spacing: 10) {
                        ForEach(stats, id: \.0) { stat in
                            VStack(spacing: 5) {
                                Text(stat.0)
                                    .font(AlloraFont.newsreader(24, weight: .medium))
                                    .foregroundColor(Color(hex: "#241D14"))
                                Text(stat.1)
                                    .font(AlloraFont.grotesk(10.5, weight: .semibold))
                                    .foregroundColor(Color(hex: "#9A8E7B"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Color(hex: "#FBF6ED"))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#221D17").opacity(0.07)))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)

                    // Places you loved
                    sectionTitle("Places you loved")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Array(lovedIds.enumerated()), id: \.offset) { i, id in
                                let r = Restaurant.all[id]!
                                Button { state.openDetail(id) } label: {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ZStack(alignment: .topTrailing) {
                                            ZStack(alignment: .bottomLeading) {
                                                RoundedRectangle(cornerRadius: 18).fill(Color(hex: "#23160F"))
                                                    .overlay(RestaurantPlaceholderImage(name: r.name, color: r.roleColor).clipShape(RoundedRectangle(cornerRadius: 18)))
                                                    .frame(height: 120)
                                                Text(r.name)
                                                    .font(AlloraFont.newsreader(20, weight: .medium))
                                                    .foregroundColor(Color(hex: "#F8EEDD"))
                                                    .shadow(color: .black.opacity(0.45), radius: 5, y: 1)
                                                    .padding(.horizontal, 12).padding(.bottom, 10)
                                            }
                                            Image(systemName: "heart.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(hex: "#E8836A"))
                                                .frame(width: 28, height: 28)
                                                .background(Color.black.opacity(0.42))
                                                .clipShape(Circle())
                                                .padding(9)
                                        }
                                        .frame(height: 120)
                                        Text(lovedMeta[i])
                                            .font(AlloraFont.grotesk(12, weight: .semibold))
                                            .foregroundColor(Color(hex: "#9A4429"))
                                            .padding(.top, 7)
                                    }
                                    .frame(width: 172)
                                }
                                .buttonStyle(AlloraButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    // What you ask for most
                    sectionTitle("What you ask for most")
                    FlowLayout(spacing: 8) {
                        ForEach(tasteMoods, id: \.self) { mood in
                            Text(mood)
                                .font(AlloraFont.grotesk(13.5, weight: .semibold))
                                .foregroundColor(Color(hex: "#4A4136"))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color(hex: "#EAE0CF"))
                                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color(hex: "#221D17").opacity(0.06)))
                                .clipShape(RoundedRectangle(cornerRadius: 13))
                        }
                    }
                    .padding(.horizontal, 20)

                    // Neighbourhoods
                    sectionTitle("Your neighbourhoods")
                    VStack(spacing: 12) {
                        ForEach(hoods, id: \.0) { hood in
                            HStack(spacing: 12) {
                                Text(hood.0)
                                    .font(AlloraFont.grotesk(13.5, weight: .semibold))
                                    .foregroundColor(Color(hex: "#3A3128"))
                                    .frame(width: 90, alignment: .leading)
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color(hex: "#E7DCC8")).frame(height: 8)
                                        Capsule()
                                            .fill(LinearGradient(colors: [Color(hex: "#D2693F"), Color(hex: "#A53E20")], startPoint: .leading, endPoint: .trailing))
                                            .frame(width: geo.size.width * hood.2, height: 8)
                                    }
                                }
                                .frame(height: 8)
                                Text(hood.1)
                                    .font(AlloraFont.grotesk(12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#9A8E7B"))
                                    .frame(width: 56, alignment: .trailing)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Allora thinks you'll love
                    HStack(spacing: 8) {
                        AlloraStarIcon(size: 16)
                        Text("Allora thinks you'll love")
                            .font(AlloraFont.newsreader(22, weight: .medium))
                            .foregroundColor(Color(hex: "#241D14"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 12)

                    VStack(spacing: 11) {
                        ForEach(Array(tryIds.enumerated()), id: \.offset) { i, id in
                            let r = Restaurant.all[id]!
                            Button { state.openDetail(id) } label: {
                                HStack(spacing: 13) {
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color(hex: "#23160F"))
                                        .overlay(RestaurantPlaceholderImage(name: r.name, color: r.roleColor).clipShape(RoundedRectangle(cornerRadius: 13)))
                                        .frame(width: 62, height: 62)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(r.name).font(AlloraFont.newsreader(20)).foregroundColor(Color(hex: "#241D14"))
                                        Text("\(r.kind) · \(r.area)").font(AlloraFont.grotesk(12, weight: .semibold)).foregroundColor(Color(hex: "#7A7063"))
                                        Text(tryMeta[i]).font(AlloraFont.grotesk(11, weight: .bold)).foregroundColor(Color(hex: "#9A4429"))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.system(size: 15, weight: .semibold)).foregroundColor(Color(hex: "#C2B6A0"))
                                }
                                .padding(11)
                                .background(Color(hex: "#FCF8F0").opacity(0.7))
                                .background(.ultraThinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.5)))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(AlloraButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)

                    // Living memory
                    HStack(alignment: .top, spacing: 11) {
                        AlloraStarIcon(color: Color(hex: "#D9A95F"), size: 16)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your living memory".uppercased())
                                .font(AlloraFont.grotesk(10, weight: .bold))
                                .kerning(1)
                                .foregroundColor(Color(hex: "#D9A95F"))
                            Text("This grows every time you tell Allora how an evening went. The more you share, the better tonight fits.")
                                .font(AlloraFont.grotesk(13.5, weight: .medium))
                                .foregroundColor(Color(hex: "#D8CBB4"))
                                .lineSpacing(3)
                        }
                    }
                    .padding(16)
                    .background(Color(hex: "#241D14"))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) { glowPulse = true }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(AlloraFont.newsreader(22, weight: .medium))
            .foregroundColor(Color(hex: "#241D14"))
            .padding(.horizontal, 20)
            .padding(.top, 28)
            .padding(.bottom, 12)
    }
}
