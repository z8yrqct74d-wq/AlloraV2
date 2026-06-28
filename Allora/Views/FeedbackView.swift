import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var state: AppState

    private var restaurant: Restaurant { state.currentRestaurant }

    let options = ["Perfect", "Good, but not my vibe", "Too expensive", "Too far", "Too quiet", "Too loud", "Would go again"]
    let memoryNotes: [String: String] = [
        "Perfect": "Noted — you and MAT are a match. I'll keep finding rooms this warm.",
        "Would go again": "Saved to your favourites. I'll watch this place for tables.",
        "Good, but not my vibe": "Got it. I'll lean a little different next time.",
        "Too expensive": "Understood — I'll aim gentler on the bill from now on.",
        "Too far": "Noted — I'll keep things closer to you.",
        "Too quiet": "I'll bring a touch more energy next time.",
        "Too loud": "I'll steer you somewhere calmer next time.",
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#F8F1E4"), Color(hex: "#ECE2D0")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "#23160F"))
                            .overlay(RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor, imageName: restaurant.imageName).clipShape(RoundedRectangle(cornerRadius: 16)))
                            .frame(width: 62, height: 62)
                            .shadow(color: Color(hex: "#3C1E0C").opacity(0.5), radius: 14, y: 7)
                        Text("\(restaurant.name) · last night".uppercased())
                            .font(AlloraFont.grotesk(11, weight: .bold))
                            .kerning(1.4)
                            .foregroundColor(.alloraGold)
                            .padding(.top, 18)
                        Text("Was this the right pick?")
                            .font(AlloraFont.newsreader(30, weight: .medium))
                            .foregroundColor(Color(hex: "#241D14"))
                            .padding(.top, 8)
                        Text("A tap is all it takes — I'll remember for next time.")
                            .font(AlloraFont.newsreader(15, italic: true))
                            .foregroundColor(.alloraMuted)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.top, 8)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 78)

                    // Feedback chips
                    FlowLayout(spacing: 9) {
                        ForEach(options, id: \.self) { option in
                            let active = state.feedbackChoice == option
                            Button {
                                withAnimation { state.chooseFeedback(option) }
                            } label: {
                                Text(option)
                                    .font(AlloraFont.grotesk(14, weight: .semibold))
                                    .foregroundColor(active ? Color(hex: "#FBF3E6") : Color(hex: "#3A3128"))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(active ? Color.alloraTerracotta : Color(hex: "#FCF8F0"))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(active ? Color.alloraTerracotta : Color(hex: "#221D17").opacity(0.14)))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(AlloraButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 26)

                    // Memory response
                    if let choice = state.feedbackChoice {
                        VStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 11) {
                                AlloraStarIcon(size: 18)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Allora is learning".uppercased())
                                        .font(AlloraFont.grotesk(11, weight: .bold))
                                        .kerning(0.4)
                                        .foregroundColor(.alloraTerracotta)
                                    Text(memoryNotes[choice] ?? "")
                                        .font(AlloraFont.grotesk(14, weight: .medium))
                                        .foregroundColor(Color(hex: "#5C5142"))
                                        .lineSpacing(3)
                                }
                            }
                            .padding(16)
                            .background(Color(hex: "#FCF8F0"))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.alloraTerracotta.opacity(0.18)))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color(hex: "#3C2814").opacity(0.5), radius: 16, y: 8)

                            Button { state.finishFeedback() } label: {
                                Text("Done")
                                    .font(AlloraFont.grotesk(15.5, weight: .bold))
                                    .foregroundColor(Color(hex: "#F6ECDC"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(hex: "#241D14"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(AlloraButtonStyle())
                            .padding(.top, 14)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 26)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer().frame(height: 50)
                }
            }
        }
        .animation(.easeInOut, value: state.feedbackChoice)
    }
}
