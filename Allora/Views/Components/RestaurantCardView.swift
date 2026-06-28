import SwiftUI
import UIKit

// Horizontal scroll card (home/pulse)
struct RestaurantTileCard: View {
    let restaurant: Restaurant
    let meta: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(hex: "#23160F"))
                        .frame(height: 120)
                        .overlay(
                            RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor, imageName: restaurant.imageName)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        )
                        .overlay(
                            LinearGradient(
                                colors: [.clear, Color.black.opacity(0.62)],
                                startPoint: .init(x: 0.5, y: 0.26), endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        )
                    Text(restaurant.name)
                        .font(AlloraFont.newsreader(20, weight: .medium))
                        .foregroundColor(Color(hex: "#F8EEDD"))
                        .shadow(color: .black.opacity(0.45), radius: 5, y: 1)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)
                }
                .frame(height: 120)
                .shadow(color: Color(hex: "#3C2814").opacity(0.5), radius: 11, y: 6)

                Text(restaurant.kind)
                    .font(AlloraFont.grotesk(12.5, weight: .semibold))
                    .foregroundColor(.alloraSubtext)
                    .padding(.top, 8)
                Text(meta)
                    .font(AlloraFont.grotesk(12, weight: .semibold))
                    .foregroundColor(.alloraFaint)
                    .padding(.top, 2)
            }
            .frame(width: 172)
        }
        .buttonStyle(AlloraButtonStyle())
    }
}

// Pick-of-night tall card
struct PickOfNightCard: View {
    let restaurant: Restaurant
    let action: () -> Void
    var height: CGFloat = 232

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "#23160F"))
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .overlay(
                        RestaurantPlaceholderImage(name: restaurant.name, color: restaurant.roleColor, imageName: restaurant.imageName)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    )
                    .overlay(
                        LinearGradient(
                            colors: [Color(hex: "#FFDEA8").opacity(0.4), .clear, Color.black.opacity(0.66)],
                            startPoint: .top, endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    )

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkle")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(hex: "#F2C98A"))
                        Text("A few tables · 21:00")
                            .font(AlloraFont.grotesk(11, weight: .bold))
                            .foregroundColor(Color(hex: "#F6E6CE"))
                            .kerning(0.2)
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.42))
                    .clipShape(Capsule())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 14)
                    .padding(.horizontal, 14)

                    Spacer()

                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(restaurant.kind) · \(restaurant.area)")
                            .font(AlloraFont.grotesk(12, weight: .semibold))
                            .foregroundColor(Color(hex: "#F0CFA8"))
                        Text(restaurant.name)
                            .font(AlloraFont.newsreader(30, weight: .medium))
                            .foregroundColor(Color(hex: "#FAF1E2"))
                            .shadow(color: .black.opacity(0.4), radius: 7, y: 2)
                        Text(restaurant.note)
                            .font(AlloraFont.newsreader(15, italic: true))
                            .foregroundColor(Color(hex: "#E7D2B6"))
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 16)
                }
            }
            .frame(height: height)
            .shadow(color: Color(hex: "#3C1E0C").opacity(0.6), radius: 18, y: 9)
        }
        .buttonStyle(AlloraButtonStyle())
    }
}

/// Venue imagery.
///
/// FINAL DESIGN DIRECTION: real restaurant / interior photography. Photos are
/// the "trust" half of the experience (the orb/glass/motion is the "magic"
/// half). To wire real photos in, drop an image set into `Assets.xcassets`
/// named to match the restaurant's `imageName` (e.g. `r-mat`, `r-kane`,
/// `r-sare`, …) and this view will use it automatically — no code changes.
///
/// PLACEHOLDER (temporary): when no matching asset is bundled, a warm
/// generated gradient with a faint speckle stands in so the app runs with no
/// external assets. These gradients are NOT a design direction — they exist
/// only so the prototype is self-contained. See `DESIGN_HANDOFF.md`.
struct RestaurantPlaceholderImage: View {
    /// Display label, used only for debugging/identification.
    var name: String = ""
    /// Fallback tint for the placeholder gradient (typically the role color).
    var color: Color
    /// Asset-catalog name of the real photo, if available.
    var imageName: String? = nil

    private var bundledImage: UIImage? {
        guard let imageName, !imageName.isEmpty else { return nil }
        return UIImage(named: imageName)
    }

    var body: some View {
        GeometryReader { geo in
            if let ui = bundledImage {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [color.opacity(0.8), Color(hex: "#1A0C07")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            // Faint speckle so flat gradients read as "atmosphere", not UI.
            Canvas { ctx, size in
                for _ in 0..<200 {
                    let x = Double.random(in: 0...size.width)
                    let y = Double.random(in: 0...size.height)
                    let r = Double.random(in: 0.5...2.5)
                    ctx.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                        with: .color(.white.opacity(Double.random(in: 0.02...0.08)))
                    )
                }
            }
        }
    }
}
