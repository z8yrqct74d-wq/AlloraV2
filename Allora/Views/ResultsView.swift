import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            Color.alloraCream.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Nav
                        HStack {
                            BackButton { state.goHome() }
                            Spacer()
                            Text("3 tables for tonight")
                                .font(AlloraFont.grotesk(12, weight: .bold))
                                .kerning(1.6)
                                .textCase(.uppercase)
                                .foregroundColor(.alloraGold)
                            Spacer()
                            Color.clear.frame(width: 40, height: 40)
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 60)

                        // Allora intro
                        VStack(alignment: .leading, spacing: 9) {
                            HStack(spacing: 8) {
                                AlloraStarIcon(size: 17)
                                Text("Allora")
                                    .font(AlloraFont.grotesk(12, weight: .bold))
                                    .foregroundColor(.alloraTerracotta)
                            }
                            (Text("I found three that fit tonight — ")
                                .font(AlloraFont.newsreader(24))
                             + Text("warm, close, and easy on the bill.")
                                .font(AlloraFont.newsreader(24, italic: true)))
                                .foregroundColor(Color(hex: "#241D14"))
                                .lineSpacing(3)
                        }
                        .padding(.horizontal, 22)
                        .padding(.top, 18)

                        // Refine note
                        if let refine = state.selectedRefine {
                            HStack(alignment: .top, spacing: 9) {
                                AlloraStarIcon(size: 15)
                                Text(state.refineNotes[refine] ?? "")
                                    .font(AlloraFont.grotesk(13.5, weight: .medium))
                                    .foregroundColor(Color(hex: "#7A4026"))
                                    .lineSpacing(2)
                            }
                            .padding(.horizontal, 13)
                            .padding(.vertical, 11)
                            .background(Color(hex: "#F3E3D2"))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.alloraTerracotta.opacity(0.18)))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal, 20)
                            .padding(.top, 14)
                        }

                        // Result cards
                        VStack(spacing: 18) {
                            ForEach(Array(Restaurant.shortlist.enumerated()), id: \.element.id) { index, r in
                                ResultCard(restaurant: r, delay: Double(index) * 0.09)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 140)
                    }
                }

                // Bottom bar
                VStack(spacing: 11) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(state.refineOptions, id: \.self) { option in
                                let active = state.selectedRefine == option
                                Button {
                                    withAnimation { state.selectedRefine = active ? nil : option }
                                } label: {
                                    Text(option)
                                        .font(AlloraFont.grotesk(13, weight: .semibold))
                                        .foregroundColor(active ? Color(hex: "#F6ECDC") : Color(hex: "#4A4136"))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 9)
                                        .background(active ? Color(hex: "#241D14") : Color(hex: "#EFE6D5"))
                                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(active ? Color(hex: "#241D14") : Color(hex: "#221D17").opacity(0.08)))
                                        .clipShape(RoundedRectangle(cornerRadius: 13))
                                }
                                .buttonStyle(AlloraButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 11)
                    }

                    Button { state.openBooking("mat") } label: {
                        Text("Book the best match →")
                            .font(AlloraFont.grotesk(15.5, weight: .bold))
                            .foregroundColor(Color(hex: "#F6ECDC"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#241D14"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(AlloraButtonStyle())
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                .padding(.bottom, 12)
                .background(
                    LinearGradient(colors: [Color.alloraCream, Color.alloraCream.opacity(0)], startPoint: .bottom, endPoint: .top)
                )
            }
        }
    }
}

struct ResultCard: View {
    @EnvironmentObject var state: AppState
    let restaurant: Restaurant
    let delay: Double
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            // Hero image
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(hex: "#23160F"))
                    .frame(height: 178)
                    .overlay(RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor))
                    .overlay(
                        LinearGradient(colors: [.clear, .clear, Color.black.opacity(0.55)], startPoint: .top, endPoint: .bottom)
                    )

                VStack {
                    HStack {
                        Text(restaurant.role.uppercased())
                            .font(AlloraFont.grotesk(11, weight: .bold))
                            .kerning(0.5)
                            .foregroundColor(Color(hex: "#FCF3E6"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(restaurant.roleColor)
                            .clipShape(Capsule())
                        Spacer()
                        Button { state.go(.share(restaurant.id, state.booked)) } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(hex: "#F6ECDC"))
                                .frame(width: 36, height: 36)
                                .background(Color.black.opacity(0.34))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white.opacity(0.2)))
                        }
                    }
                    Spacer()
                    HStack {
                        HStack(spacing: 6) {
                            Circle().fill(Color(hex: "#7DD49B")).frame(width: 7, height: 7)
                                .shadow(color: Color(hex: "#7DD49B"), radius: 4)
                            Text("Table for 2 · \(restaurant.availNote)")
                                .font(AlloraFont.grotesk(11.5, weight: .bold))
                                .foregroundColor(Color(hex: "#F2E8D8"))
                        }
                        .padding(.horizontal, 11)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.16)))
                        Spacer()
                    }
                }
                .padding(13)
            }
            .frame(height: 178)

            // Body
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(restaurant.name)
                            .font(AlloraFont.newsreader(24, weight: .semibold))
                            .foregroundColor(Color(hex: "#241D14"))
                        Text("\(restaurant.kind) · \(restaurant.area) · \(restaurant.dist)")
                            .font(AlloraFont.grotesk(12.5, weight: .semibold))
                            .foregroundColor(Color(hex: "#7A7063"))
                    }
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#C2904A"))
                        Text(restaurant.rating)
                            .font(AlloraFont.grotesk(13, weight: .bold))
                            .foregroundColor(Color(hex: "#3A3128"))
                    }
                }

                HStack(spacing: 10) {
                    HStack(spacing: 0) {
                        Text(restaurant.priceOn).foregroundColor(Color(hex: "#3A3128"))
                        Text(restaurant.priceOff).foregroundColor(Color(hex: "#CFC3AC"))
                    }
                    .font(AlloraFont.grotesk(13, weight: .bold))
                    Text(restaurant.priceNote)
                        .font(AlloraFont.grotesk(12.5, weight: .medium))
                        .foregroundColor(Color(hex: "#9A8E7B"))
                }
                .padding(.top, 9)

                // Reason
                HStack(alignment: .top, spacing: 9) {
                    AlloraStarIcon(size: 14)
                    Text(restaurant.reason)
                        .font(AlloraFont.grotesk(13, weight: .medium))
                        .foregroundColor(Color(hex: "#5C5142"))
                        .lineSpacing(3)
                }
                .padding(11)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#F4E9D8").opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .padding(.top, 13)

                // Actions
                HStack(spacing: 10) {
                    Button { state.openBooking(restaurant.id) } label: {
                        Text("Book")
                            .font(AlloraFont.grotesk(14.5, weight: .bold))
                            .foregroundColor(Color(hex: "#FCF3E6"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(restaurant.roleColor)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(AlloraButtonStyle())
                    Button { state.openDetail(restaurant.id) } label: {
                        Text("Details")
                            .font(AlloraFont.grotesk(14.5, weight: .bold))
                            .foregroundColor(Color(hex: "#3A3128"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Color(hex: "#EFE6D5"))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#221D17").opacity(0.08)))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(AlloraButtonStyle())
                }
                .padding(.top, 14)
            }
            .padding(.horizontal, 16)
            .padding(.top, 15)
            .padding(.bottom, 16)
        }
        .background(Color(hex: "#FCF8F0").opacity(0.8))
        .background(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.5)))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color(hex: "#3C2814").opacity(0.5), radius: 26, y: 13)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 36)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8).delay(delay)) {
                appeared = true
            }
        }
    }
}
