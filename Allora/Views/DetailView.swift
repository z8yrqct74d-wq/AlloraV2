import SwiftUI

struct DetailView: View {
    @EnvironmentObject var state: AppState
    let restaurantId: String

    private var restaurant: Restaurant { Restaurant.all[restaurantId] ?? Restaurant.all["mat"]! }

    let galleryGradients: [Color] = [Color(hex: "#3A2418"), Color(hex: "#4A2E1C"), Color(hex: "#2C1B12"), Color(hex: "#5A3826")]

    var body: some View {
        ZStack(alignment: .top) {
            Color.alloraCream.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(Color(hex: "#23160F"))
                                .frame(height: 354)
                                .overlay(RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor))
                                .overlay(
                                    LinearGradient(colors: [Color(hex: "#FFDEA8").opacity(0.4), .clear, Color.black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                                )
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(restaurant.role) · \(restaurant.area)".uppercased())
                                    .font(AlloraFont.grotesk(11, weight: .bold))
                                    .kerning(1.4)
                                    .foregroundColor(Color(hex: "#F0CFA8"))
                                Text(restaurant.name)
                                    .font(AlloraFont.newsreader(46, weight: .medium))
                                    .foregroundColor(Color(hex: "#FAF1E2"))
                                    .shadow(color: .black.opacity(0.45), radius: 9, y: 3)
                                    .padding(.top, 7)
                                Text(restaurant.note)
                                    .font(AlloraFont.newsreader(17, italic: true))
                                    .foregroundColor(Color(hex: "#EBD7BB"))
                                    .lineSpacing(3)
                                    .padding(.top, 9)
                                Text(restaurant.vibe)
                                    .font(AlloraFont.grotesk(12.5, weight: .semibold))
                                    .foregroundColor(Color(hex: "#E4CFAF"))
                                    .kerning(0.2)
                                    .padding(.top, 11)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 26)
                        }
                        .frame(height: 354)

                        // Content sheet
                        VStack(alignment: .leading, spacing: 0) {
                            // Why picked
                            HStack(alignment: .top, spacing: 10) {
                                AlloraStarIcon(size: 17)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Why Allora picked this".uppercased())
                                        .font(AlloraFont.grotesk(11, weight: .bold))
                                        .kerning(0.4)
                                        .foregroundColor(.alloraTerracotta)
                                    Text(restaurant.reason)
                                        .font(AlloraFont.grotesk(14, weight: .medium))
                                        .foregroundColor(Color(hex: "#5C5142"))
                                        .lineSpacing(3)
                                }
                            }
                            .padding(14)
                            .background(Color(hex: "#FCF8F0"))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.alloraTerracotta.opacity(0.16)))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color(hex: "#3C2814").opacity(0.5), radius: 16, y: 8)

                            // Availability
                            HStack {
                                Text("Tonight's availability")
                                    .font(AlloraFont.newsreader(21, weight: .medium))
                                    .foregroundColor(Color(hex: "#241D14"))
                                Spacer()
                                if restaurant.confirmedLive { LiveBadge() }
                            }
                            .padding(.top, 26)
                            .padding(.bottom, 12)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 9) {
                                    ForEach(restaurant.times) { slot in
                                        TimeSlotButton(slot: slot, selected: slot.available && slot.time == state.bookTime, minWidth: 64) {
                                            if slot.available { state.bookTime = slot.time }
                                        }
                                    }
                                }
                            }

                            // Stats grid
                            HStack(spacing: 11) {
                                statBox(label: "Distance", value: restaurant.dist, sub: restaurant.walk)
                                statBox(label: "Typical price", valuePrice: (restaurant.priceOn, restaurant.priceOff), sub: restaurant.priceNote)
                            }
                            .padding(.top, 24)

                            // Gallery
                            Text("A look inside")
                                .font(AlloraFont.newsreader(21, weight: .medium))
                                .foregroundColor(Color(hex: "#241D14"))
                                .padding(.top, 26)
                                .padding(.bottom, 12)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(0..<4, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color(hex: "#23160F"))
                                            .overlay(RestaurantPlaceholderImage(name: "", color: galleryGradients[i]).clipShape(RoundedRectangle(cornerRadius: 14)))
                                            .frame(width: 128, height: 96)
                                    }
                                }
                            }

                            // Menu
                            HStack(alignment: .firstTextBaseline) {
                                Text("Menu preview")
                                    .font(AlloraFont.newsreader(21, weight: .medium))
                                    .foregroundColor(Color(hex: "#241D14"))
                                Spacer()
                                Text("A few favourites")
                                    .font(AlloraFont.grotesk(11, weight: .semibold))
                                    .foregroundColor(.alloraFaint)
                            }
                            .padding(.top, 26)
                            .padding(.bottom, 12)

                            VStack(spacing: 0) {
                                ForEach(Array(restaurant.menu.enumerated()), id: \.element.id) { idx, item in
                                    HStack(alignment: .firstTextBaseline) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name)
                                                .font(AlloraFont.newsreader(16))
                                                .foregroundColor(Color(hex: "#2A231A"))
                                            Text(item.description)
                                                .font(AlloraFont.grotesk(12.5, weight: .medium))
                                                .foregroundColor(.alloraMuted)
                                        }
                                        Spacer()
                                        Text(item.price)
                                            .font(AlloraFont.grotesk(13, weight: .bold))
                                            .foregroundColor(Color(hex: "#9A4429"))
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 13)
                                    if idx < restaurant.menu.count - 1 {
                                        Divider().background(Color(hex: "#221D17").opacity(0.06))
                                    }
                                }
                            }
                            .background(Color(hex: "#FCF8F0"))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.07)))
                            .clipShape(RoundedRectangle(cornerRadius: 18))

                            // Where
                            Text("Where")
                                .font(AlloraFont.newsreader(21, weight: .medium))
                                .foregroundColor(Color(hex: "#241D14"))
                                .padding(.top, 26)
                                .padding(.bottom, 12)
                            mapBlock

                            // Rating block
                            HStack(spacing: 16) {
                                VStack(spacing: 3) {
                                    Text(restaurant.rating)
                                        .font(AlloraFont.newsreader(34, weight: .medium))
                                        .foregroundColor(Color(hex: "#F4EADB"))
                                    Text("\(restaurant.ratingCount) reviews")
                                        .font(AlloraFont.grotesk(10.5, weight: .semibold))
                                        .foregroundColor(Color(hex: "#B6A78C"))
                                }
                                Rectangle().fill(Color.white.opacity(0.12)).frame(width: 1, height: 42)
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Loved for".uppercased())
                                        .font(AlloraFont.grotesk(10, weight: .bold))
                                        .kerning(1)
                                        .foregroundColor(Color(hex: "#D9A95F"))
                                    FlowLayout(spacing: 6) {
                                        ForEach(restaurant.lovedFor, id: \.self) { tag in
                                            Text(tag)
                                                .font(AlloraFont.grotesk(12, weight: .semibold))
                                                .foregroundColor(Color(hex: "#EADFCB"))
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color.white.opacity(0.08))
                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.12)))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding(16)
                            .background(Color(hex: "#241D14"))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.top, 26)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 120)
                        .background(Color.alloraCream)
                        .clipShape(RoundedCorner(radius: 26, corners: [.topLeft, .topRight]))
                        .offset(y: -26)
                    }
                }

                // Bottom book bar
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Tonight")
                            .font(AlloraFont.grotesk(11, weight: .semibold))
                            .foregroundColor(.alloraFaint)
                        Text("\(state.bookTime) · 2")
                            .font(AlloraFont.newsreader(19))
                            .foregroundColor(Color(hex: "#2A231A"))
                    }
                    Button { state.openBooking(restaurant.id) } label: {
                        Text("Book a table")
                            .font(AlloraFont.grotesk(16, weight: .bold))
                            .foregroundColor(Color(hex: "#FBF3E6"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.alloraTerracotta)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.alloraTerracotta.opacity(0.6), radius: 15, y: 7)
                    }
                    .buttonStyle(AlloraButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(LinearGradient(colors: [Color.alloraCream, Color.alloraCream.opacity(0)], startPoint: .bottom, endPoint: .top))
            }

            // Floating nav buttons
            HStack {
                Button { state.back() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#F6ECDC"))
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.36))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.2)))
                }
                Spacer()
                Button { state.go(.share(restaurant.id, state.booked)) } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#F6ECDC"))
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.36))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.2)))
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 58)
        }
    }

    private var mapBlock: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(colors: [Color(hex: "#E7DFCD"), Color(hex: "#D8CDB6")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 128)
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.alloraTerracotta)
            }
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(restaurant.address)
                        .font(AlloraFont.grotesk(13.5, weight: .semibold))
                        .foregroundColor(Color(hex: "#3A3128"))
                    Text("Approximate location · \(restaurant.walk)")
                        .font(AlloraFont.grotesk(11.5, weight: .medium))
                        .foregroundColor(.alloraFaint)
                }
                Spacer()
                Text("Open in Maps")
                    .font(AlloraFont.grotesk(12.5, weight: .bold))
                    .foregroundColor(.alloraTerracotta)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .background(Color(hex: "#FCF8F0"))
        }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.08)))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func statBox(label: String, value: String? = nil, valuePrice: (String, String)? = nil, sub: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label.uppercased())
                .font(AlloraFont.grotesk(10, weight: .bold))
                .kerning(1)
                .foregroundColor(.alloraFaint)
            if let value = value {
                Text(value)
                    .font(AlloraFont.newsreader(18))
                    .foregroundColor(Color(hex: "#2A231A"))
                    .padding(.top, 3)
            } else if let vp = valuePrice {
                HStack(spacing: 0) {
                    Text(vp.0).foregroundColor(Color(hex: "#2A231A"))
                    Text(vp.1).foregroundColor(Color(hex: "#CFC3AC"))
                }
                .font(AlloraFont.newsreader(18))
                .padding(.top, 3)
            }
            Text(sub)
                .font(AlloraFont.grotesk(12, weight: .medium))
                .foregroundColor(.alloraMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(Color(hex: "#FBF6ED"))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#221D17").opacity(0.07)))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct TimeSlotButton: View {
    let slot: TimeSlot
    let selected: Bool
    var minWidth: CGFloat = 62
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(slot.time)
                .font(AlloraFont.grotesk(14, weight: .bold))
                .foregroundColor(fg)
                .strikethrough(!slot.available)
                .frame(minWidth: minWidth)
                .padding(.vertical, 11)
                .background(bg)
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(border))
                .clipShape(RoundedRectangle(cornerRadius: 13))
        }
        .disabled(!slot.available)
    }

    private var bg: Color {
        if !slot.available { return Color(hex: "#ECE4D5") }
        if selected { return Color(hex: "#241D14") }
        return Color(hex: "#FCF8F0")
    }
    private var fg: Color {
        if !slot.available { return Color(hex: "#B7AB92") }
        if selected { return Color(hex: "#F6ECDC") }
        return Color(hex: "#3A3128")
    }
    private var border: Color {
        if !slot.available { return Color(hex: "#221D17").opacity(0.06) }
        if selected { return Color(hex: "#241D14") }
        return Color(hex: "#221D17").opacity(0.14)
    }
}

// Rounded specific corners helper
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    }
}
