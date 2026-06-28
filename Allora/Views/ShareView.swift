import SwiftUI

struct ShareView: View {
    @EnvironmentObject var state: AppState
    let restaurantId: String
    let isBooked: Bool
    @State private var cardAppeared = false

    private var restaurant: Restaurant { Restaurant.all[restaurantId] ?? Restaurant.all["mat"]! }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color(hex: "#2C2017"), Color(hex: "#181009")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Share")
                            .font(AlloraFont.grotesk(12, weight: .bold))
                            .kerning(1.6)
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: "#D9A95F"))
                        Spacer()
                        Button { state.back() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#EADFCB"))
                                .frame(width: 38, height: 38)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white.opacity(0.14)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)

                    // Share card
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(Color(hex: "#23160F"))
                                .frame(height: 240)
                                .overlay(RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor, imageName: restaurant.imageName))
                                .overlay(LinearGradient(colors: [Color(hex: "#FFDEA8").opacity(0.4), .clear, Color.black.opacity(0.62)], startPoint: .top, endPoint: .bottom))

                            VStack {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkle")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(hex: "#F4D6A4"))
                                    Text("Allora")
                                        .font(AlloraFont.grotesk(12, weight: .bold))
                                        .kerning(1.4)
                                        .textCase(.uppercase)
                                        .foregroundColor(Color(hex: "#F4E6CE"))
                                    Spacer()
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 0) {
                                    if isBooked {
                                        Text("We're booked for tonight".uppercased())
                                            .font(AlloraFont.grotesk(11, weight: .bold))
                                            .kerning(0.4)
                                            .foregroundColor(Color(hex: "#F0CFA8"))
                                    }
                                    Text(restaurant.name)
                                        .font(AlloraFont.newsreader(38, weight: .medium))
                                        .foregroundColor(Color(hex: "#FAF1E2"))
                                        .shadow(color: .black.opacity(0.4), radius: 7, y: 2)
                                        .padding(.top, 6)
                                    Text(restaurant.note)
                                        .font(AlloraFont.newsreader(15, italic: true))
                                        .foregroundColor(Color(hex: "#E7D2B6"))
                                        .padding(.top, 6)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(18)
                        }
                        .frame(height: 240)

                        // Details strip
                        VStack(spacing: 0) {
                            HStack(spacing: 22) {
                                shareDetail("When", "Fri · \(state.bookTime)")
                                shareDetail("Table", "For \(state.bookGuests)")
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Where".uppercased())
                                        .font(AlloraFont.grotesk(9.5, weight: .bold))
                                        .kerning(1)
                                        .foregroundColor(.alloraFaint)
                                    Text(restaurant.area)
                                        .font(AlloraFont.grotesk(12.5, weight: .semibold))
                                        .foregroundColor(Color(hex: "#241D14"))
                                }
                                Spacer()
                            }
                            HStack {
                                Text(restaurant.address)
                                    .font(AlloraFont.grotesk(12, weight: .semibold))
                                    .foregroundColor(.alloraMuted)
                                Spacer()
                                HStack(spacing: 5) {
                                    Text("Open in Allora")
                                        .font(AlloraFont.grotesk(12, weight: .bold))
                                    Image(systemName: "arrow.right").font(.system(size: 11, weight: .bold))
                                }
                                .foregroundColor(.alloraTerracotta)
                            }
                            .padding(.top, 16)
                            .overlay(Divider().background(Color(hex: "#221D17").opacity(0.1)), alignment: .top)
                            .padding(.top, 13)
                        }
                        .padding(18)
                        .background(Color(hex: "#FBF6ED"))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .shadow(color: .black.opacity(0.6), radius: 30, y: 15)
                    .padding(.horizontal, 24)
                    .padding(.top, 22)
                    .opacity(cardAppeared ? 1 : 0)
                    .offset(y: cardAppeared ? 0 : 36)

                    // Share targets
                    HStack(spacing: 20) {
                        shareTarget(icon: "message.fill", color: Color(hex: "#3FB950"), label: "WhatsApp") {}
                        shareTarget(icon: "camera.fill", gradient: LinearGradient(colors: [Color(hex: "#F9A825"), Color(hex: "#D81B60"), Color(hex: "#8E24AA")], startPoint: .topLeading, endPoint: .bottomTrailing), label: "Stories") {}
                        shareTarget(icon: "bubble.left.fill", color: Color(hex: "#0B84FF"), label: "Messages") {}
                        shareTarget(icon: "doc.on.doc", color: Color.white.opacity(0.1), bordered: true, label: "Copy link") { state.copyLink() }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 26)

                    if state.copied {
                        Text("Link copied ✓")
                            .font(AlloraFont.grotesk(13, weight: .semibold))
                            .foregroundColor(Color(hex: "#F4E6CE"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(Color.white.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.16)))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.top, 18)
                            .transition(.opacity)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { cardAppeared = true }
        }
        .animation(.easeInOut, value: state.copied)
    }

    private func shareDetail(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(AlloraFont.grotesk(9.5, weight: .bold))
                .kerning(1)
                .foregroundColor(.alloraFaint)
            Text(value)
                .font(AlloraFont.newsreader(18))
                .foregroundColor(Color(hex: "#241D14"))
        }
    }

    private func shareTarget(icon: String, color: Color = .clear, gradient: LinearGradient? = nil, bordered: Bool = false, label: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 7) {
            Button(action: action) {
                ZStack {
                    if let gradient = gradient {
                        Circle().fill(gradient)
                    } else {
                        Circle().fill(color)
                    }
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 54, height: 54)
                .overlay(bordered ? Circle().stroke(Color.white.opacity(0.16)) : nil)
            }
            .buttonStyle(CircleButtonStyle())
            Text(label)
                .font(AlloraFont.grotesk(11, weight: .semibold))
                .foregroundColor(Color(hex: "#C9BBA1"))
        }
    }
}
