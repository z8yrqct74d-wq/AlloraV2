import SwiftUI

struct ConfirmedView: View {
    @EnvironmentObject var state: AppState
    @State private var checkPopped = false
    @State private var glowPulse = false

    private var restaurant: Restaurant { state.currentRestaurant }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color(hex: "#F8F1E4"), Color(hex: "#ECE2D0")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // Ambient green glow
            Circle()
                .fill(RadialGradient(colors: [Color(hex: "#4F9C6B").opacity(0.2), .clear], center: .center, startRadius: 0, endRadius: 125))
                .blur(radius: 28)
                .frame(width: 250, height: 250)
                .offset(y: 46)
                .scaleEffect(glowPulse ? 1.08 : 1.0)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Check mark
                    ZStack {
                        Circle()
                            .fill(RadialGradient(colors: [Color(hex: "#4F7C5A").opacity(0.28), .clear], center: .center, startRadius: 0, endRadius: 42))
                            .opacity(glowPulse ? 0.95 : 0.45)
                        Circle()
                            .fill(Color(hex: "#4F9C6B"))
                            .frame(width: 64, height: 64)
                            .shadow(color: Color(hex: "#4F7C5A").opacity(0.7), radius: 13, y: 6)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(hex: "#F6ECDC"))
                            )
                    }
                    .frame(width: 84, height: 84)
                    .scaleEffect(checkPopped ? 1 : 0.7)
                    .opacity(checkPopped ? 1 : 0)
                    .padding(.top, 84)

                    Text("Your table is set.")
                        .font(AlloraFont.newsreader(32, weight: .medium))
                        .foregroundColor(Color(hex: "#241D14"))
                        .padding(.top, 24)
                    Text("\(restaurant.name) is holding your table. The evening can begin.")
                        .font(AlloraFont.newsreader(16, italic: true))
                        .foregroundColor(Color(hex: "#7A7063"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.top, 9)
                        .padding(.horizontal, 40)

                    // Reservation card
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(Color(hex: "#23160F"))
                                .frame(height: 96)
                                .overlay(RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor, imageName: restaurant.imageName))
                                .overlay(LinearGradient(colors: [.clear, Color.black.opacity(0.55)], startPoint: .top, endPoint: .bottom))
                            Text(restaurant.name)
                                .font(AlloraFont.newsreader(26, weight: .medium))
                                .foregroundColor(Color(hex: "#FAF1E2"))
                                .shadow(color: .black.opacity(0.4), radius: 6, y: 2)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
                        }
                        .frame(height: 96)

                        VStack(spacing: 0) {
                            resRow("When", "Tonight · Fri 27 Jun · \(state.bookTime)", divider: true)
                            resRow("Guests", "\(state.bookGuests) people", divider: true)
                            resRow("Where", restaurant.address, divider: true)
                            resRow("Confirmation", "ALLORA-7K2Q", divider: false, valueColor: Color(hex: "#9A4429"))
                        }
                        .padding(.horizontal, 18)
                    }
                    .background(Color(hex: "#FCF8F0"))
                    .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color(hex: "#221D17").opacity(0.08)))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: Color(hex: "#3C2814").opacity(0.55), radius: 20, y: 10)
                    .padding(.horizontal, 22)
                    .padding(.top, 30)

                    // Actions
                    VStack(spacing: 11) {
                        Button { state.go(.share(restaurant.id, true)) } label: {
                            HStack(spacing: 9) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 15, weight: .medium))
                                Text("Share reservation")
                                    .font(AlloraFont.grotesk(16, weight: .bold))
                            }
                            .foregroundColor(Color(hex: "#FBF3E6"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.alloraTerracotta)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.alloraTerracotta.opacity(0.6), radius: 15, y: 7)
                        }
                        .buttonStyle(AlloraButtonStyle())

                        Button { } label: {
                            Text("Add to calendar")
                                .font(AlloraFont.grotesk(15, weight: .bold))
                                .foregroundColor(Color(hex: "#3A3128"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color(hex: "#EFE6D5"))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#221D17").opacity(0.08)))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(AlloraButtonStyle())

                        HStack(spacing: 18) {
                            Button { state.goHome() } label: {
                                Text("Done")
                                    .font(AlloraFont.grotesk(14, weight: .bold))
                                    .foregroundColor(Color(hex: "#7A7063"))
                                    .padding(8)
                            }
                            Text("·").foregroundColor(Color(hex: "#CFC3AC"))
                            Button { state.go(.feedback) } label: {
                                HStack(spacing: 5) {
                                    Text("Preview after-dinner")
                                        .font(AlloraFont.grotesk(13, weight: .semibold))
                                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .semibold))
                                }
                                .foregroundColor(.alloraFaint)
                                .padding(8)
                            }
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 22)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.6)) { checkPopped = true }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { glowPulse = true }
        }
    }

    private func resRow(_ label: String, _ value: String, divider: Bool, valueColor: Color = Color(hex: "#241D14")) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(AlloraFont.grotesk(13, weight: .semibold))
                    .foregroundColor(.alloraMuted)
                Spacer()
                Text(value)
                    .font(AlloraFont.grotesk(13, weight: .bold))
                    .foregroundColor(valueColor)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 190, alignment: .trailing)
            }
            .padding(.vertical, 13)
            if divider { Divider().background(Color(hex: "#221D17").opacity(0.07)) }
        }
    }
}
