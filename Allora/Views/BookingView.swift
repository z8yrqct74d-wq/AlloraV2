import SwiftUI

struct BookingView: View {
    @EnvironmentObject var state: AppState
    let restaurantId: String
    @FocusState private var specialFocused: Bool

    private var restaurant: Restaurant { Restaurant.all[restaurantId] ?? Restaurant.all["mat"]! }

    var body: some View {
        ZStack {
            Color.alloraCream.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Nav
                        HStack {
                            BackButton { state.back() }
                            Spacer()
                            Text("Confirm your table")
                                .font(AlloraFont.grotesk(12, weight: .bold))
                                .kerning(1.6)
                                .textCase(.uppercase)
                                .foregroundColor(.alloraGold)
                            Spacer()
                            Color.clear.frame(width: 40, height: 40)
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 60)

                        // Restaurant header
                        HStack(spacing: 13) {
                            RoundedRectangle(cornerRadius: 13)
                                .fill(Color(hex: "#23160F"))
                                .overlay(RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor, imageName: restaurant.imageName).clipShape(RoundedRectangle(cornerRadius: 13)))
                                .frame(width: 54, height: 54)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(restaurant.name)
                                    .font(AlloraFont.newsreader(20))
                                    .foregroundColor(Color(hex: "#241D14"))
                                Text("\(restaurant.kind) · \(restaurant.area) · \(restaurant.dist)")
                                    .font(AlloraFont.grotesk(12, weight: .semibold))
                                    .foregroundColor(.alloraMuted)
                            }
                            Spacer()
                        }
                        .padding(13)
                        .background(Color(hex: "#FCF8F0"))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.08)))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // When / Time / Guests
                        VStack(alignment: .leading, spacing: 0) {
                            fieldLabel("When")
                            HStack(spacing: 9) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#9A4429"))
                                Text("Tonight · Fri 27 Jun")
                                    .font(AlloraFont.grotesk(14, weight: .bold))
                                    .foregroundColor(Color(hex: "#3A3128"))
                            }
                            .padding(.horizontal, 13)
                            .padding(.vertical, 11)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#F4E9D8"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.top, 9)

                            fieldLabel("Time").padding(.top, 16)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(restaurant.times) { slot in
                                        TimeSlotButton(slot: slot, selected: slot.available && slot.time == state.bookTime) {
                                            if slot.available { state.bookTime = slot.time }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 9)

                            HStack {
                                fieldLabel("Guests")
                                Spacer()
                                HStack(spacing: 16) {
                                    stepperButton(icon: "minus") { state.bookGuests = max(1, state.bookGuests - 1) }
                                    Text("\(state.bookGuests)")
                                        .font(AlloraFont.newsreader(24))
                                        .foregroundColor(Color(hex: "#241D14"))
                                        .frame(minWidth: 22)
                                    stepperButton(icon: "plus") { state.bookGuests = min(12, state.bookGuests + 1) }
                                }
                            }
                            .padding(.top, 18)
                        }
                        .padding(16)
                        .background(Color(hex: "#FCF8F0"))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.08)))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                        // Contact
                        VStack(spacing: 0) {
                            contactRow("Name", "Andrei P.", divider: true)
                            contactRow("Phone", "+40 7•• ••• 214", divider: false)
                        }
                        .padding(.horizontal, 16)
                        .background(Color(hex: "#FCF8F0"))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.08)))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                        // Special request
                        VStack(alignment: .leading, spacing: 8) {
                            fieldLabel("Special request")
                            TextField("A quiet corner, celebrating something…", text: $state.specialRequest, axis: .vertical)
                                .font(AlloraFont.grotesk(14.5, weight: .medium))
                                .foregroundColor(Color(hex: "#241D14"))
                                .lineLimit(2...4)
                                .focused($specialFocused)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#FCF8F0"))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#221D17").opacity(0.08)))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                        // Live confirmation
                        if restaurant.confirmedLive {
                            HStack(spacing: 9) {
                                Circle().fill(Color(hex: "#4F9C6B")).frame(width: 8, height: 8)
                                    .shadow(color: Color(hex: "#6FBF8C"), radius: 4)
                                Text("Confirmed live with the restaurant — instant booking.")
                                    .font(AlloraFont.grotesk(13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#3E6B4C"))
                            }
                            .padding(.horizontal, 13)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#E7F0E4"))
                            .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color(hex: "#BFD8B8")))
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        }

                        Spacer().frame(height: 120)
                    }
                }

                // Bottom confirm
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(state.bookGuests) guests")
                            .font(AlloraFont.grotesk(11, weight: .semibold))
                            .foregroundColor(.alloraFaint)
                        Text("\(state.bookTime) tonight")
                            .font(AlloraFont.newsreader(19))
                            .foregroundColor(Color(hex: "#2A231A"))
                    }
                    Button { state.confirm() } label: {
                        Text("Confirm reservation")
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
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(AlloraFont.grotesk(10, weight: .bold))
            .kerning(1.2)
            .foregroundColor(.alloraFaint)
    }

    private func stepperButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#3A3128"))
                .frame(width: 34, height: 34)
                .background(Color(hex: "#EFE6D5"))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(hex: "#221D17").opacity(0.1)))
        }
        .buttonStyle(CircleButtonStyle())
    }

    private func contactRow(_ label: String, _ value: String, divider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(label)
                    .font(AlloraFont.grotesk(14, weight: .semibold))
                    .foregroundColor(Color(hex: "#7A7063"))
                Spacer()
                Text(value)
                    .font(AlloraFont.grotesk(14, weight: .semibold))
                    .foregroundColor(Color(hex: "#241D14"))
            }
            .padding(.vertical, 13)
            if divider { Divider().background(Color(hex: "#221D17").opacity(0.07)) }
        }
    }
}
