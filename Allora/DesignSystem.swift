import SwiftUI

// MARK: - Colors
extension Color {
    static let alloraCream = Color(hex: "#F3ECDF")
    static let alloraDark = Color(hex: "#241D14")
    static let alloraTerracotta = Color(hex: "#BC5230")
    static let alloraGold = Color(hex: "#B07A3F")
    static let alloraGoldLight = Color(hex: "#C99A5E")
    static let alloraMuted = Color(hex: "#8A7E6C")
    static let alloraFaint = Color(hex: "#A2967F")
    static let alloraWarm = Color(hex: "#F0E3CE")
    static let alloraSurface = Color(hex: "#FCF8F0")
    static let alloraBorder = Color(hex: "#E4C7A0")
    static let alloraChip = Color(hex: "#EAE0CF")
    static let alloraText = Color(hex: "#3A3128")
    static let alloraSubtext = Color(hex: "#6B6155")
    static let alloraGreen = Color(hex: "#4F9C6B")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - Typography
struct AlloraFont {
    static func newsreader(_ size: CGFloat, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        if italic {
            return .custom("Newsreader-Italic", size: size)
        }
        switch weight {
        case .light: return .custom("Newsreader-Light", size: size)
        case .medium: return .custom("Newsreader-Medium", size: size)
        case .semibold: return .custom("Newsreader-SemiBold", size: size)
        default: return .custom("Newsreader-Regular", size: size)
        }
    }
    static func grotesk(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .semibold: return .custom("HankenGrotesk-SemiBold", size: size)
        case .bold: return .custom("HankenGrotesk-Bold", size: size)
        case .heavy: return .custom("HankenGrotesk-ExtraBold", size: size)
        case .medium: return .custom("HankenGrotesk-Medium", size: size)
        default: return .custom("HankenGrotesk-Regular", size: size)
        }
    }
}

// MARK: - Gradients
extension LinearGradient {
    static let creamBackground = LinearGradient(
        colors: [Color(hex: "#E7DFCE"), Color(hex: "#D6CCB8"), Color(hex: "#C6BBA3")],
        startPoint: .top, endPoint: .bottom
    )
    static let splashBackground = LinearGradient(
        colors: [Color(hex: "#3C2B1E"), Color(hex: "#241811"), Color(hex: "#150E0A")],
        startPoint: .top, endPoint: .bottom
    )
    static let composerBackground = LinearGradient(
        colors: [Color(hex: "#F7F0E3"), Color(hex: "#EFE5D2")],
        startPoint: .top, endPoint: .bottom
    )
}

// MARK: - View Modifiers
struct AlloraButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Shared Components
struct AlloraStarIcon: View {
    var color: Color = .alloraTerracotta
    var size: CGFloat = 15
    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: size - 2, weight: .semibold))
            .foregroundColor(color)
    }
}

struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(AlloraFont.grotesk(11, weight: .bold))
            .kerning(1.8)
            .foregroundColor(.alloraGold)
    }
}

struct BackButton: View {
    let action: () -> Void
    var dark: Bool = false
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(dark ? Color.black.opacity(0.36) : Color.alloraChip)
                    .overlay(dark ? Circle().stroke(Color.white.opacity(0.2)) : nil)
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(dark ? Color(hex: "#F6ECDC") : .alloraText)
            }
            .frame(width: 40, height: 40)
        }
        .buttonStyle(CircleButtonStyle())
    }
}

struct LiveBadge: View {
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Color(hex: "#4F9C6B"))
                .frame(width: 7, height: 7)
                .shadow(color: Color(hex: "#6FBF8C"), radius: 3)
            Text("LIVE")
                .font(AlloraFont.grotesk(11, weight: .bold))
                .foregroundColor(Color(hex: "#4F7C5A"))
                .kerning(0.5)
        }
    }
}

// MARK: - Animations
extension Animation {
    static let alloraSpring = Animation.spring(response: 0.5, dampingFraction: 0.75)
    static let alloraEase = Animation.easeInOut(duration: 0.42)
}
