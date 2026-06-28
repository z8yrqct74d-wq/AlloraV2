import SwiftUI

struct ThinkingView: View {
    @EnvironmentObject var state: AppState
    @State private var ringPulse1 = false
    @State private var ringPulse2 = false
    @State private var barProgress: CGFloat = 0

    let intent = [
        ("Cozy", 0.0), ("For two", 0.11), ("Around 20:00", 0.22),
        ("Near you", 0.33), ("Not too expensive", 0.44), ("Available tonight", 0.55)
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#F7F0E3"), Color(hex: "#ECE2D0")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Orb with rings
                ZStack {
                    Circle()
                        .stroke(Color(hex: "#BC5230").opacity(0.3), lineWidth: 1)
                        .frame(width: 108, height: 108)
                        .scaleEffect(ringPulse1 ? 1.55 : 0.6)
                        .opacity(ringPulse1 ? 0 : 0.6)
                    Circle()
                        .stroke(Color(hex: "#BC5230").opacity(0.22), lineWidth: 1)
                        .frame(width: 108, height: 108)
                        .scaleEffect(ringPulse2 ? 1.55 : 0.6)
                        .opacity(ringPulse2 ? 0 : 0.6)

                    let orbMode: OrbDisplayMode = {
                        switch state.orbMode {
                        case .thinking: return .thinking
                        case .converge: return .converge
                        case .idle: return .idle
                        }
                    }()
                    AlloraOrbView(mode: orbMode, size: 108)
                }
                .frame(width: 128, height: 128)
                .padding(.bottom, 24)

                Text("Reading the evening…")
                    .font(AlloraFont.newsreader(25))
                    .foregroundColor(Color(hex: "#2A231A"))

                Text("\u{201C}A cozy place nearby for two, around 8, not too expensive.\u{201D}")
                    .font(AlloraFont.newsreader(15, italic: true))
                    .foregroundColor(.alloraMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.top, 10)
                    .padding(.horizontal, 40)

                // Intent chips
                FlowLayout(spacing: 8) {
                    ForEach(intent, id: \.0) { label, delay in
                        Text(label)
                            .font(AlloraFont.grotesk(13, weight: .semibold))
                            .foregroundColor(Color(hex: "#9A4429"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(hex: "#FBF6ED"))
                            .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color(hex: "#BC5230").opacity(0.22)))
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                    }
                }
                .padding(.horizontal, 50)
                .padding(.top, 26)

                // Progress bar
                VStack(spacing: 12) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#221D17").opacity(0.1))
                            .frame(width: 200, height: 4)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.alloraTerracotta)
                            .frame(width: 200 * barProgress, height: 4)
                    }
                    Text("Checking real availability…")
                        .font(AlloraFont.grotesk(12, weight: .semibold))
                        .foregroundColor(.alloraFaint)
                        .kerning(0.2)
                }
                .padding(.top, 32)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: false)) { ringPulse1 = true }
            withAnimation(.easeInOut(duration: 2.4).delay(1.2).repeatForever(autoreverses: false)) { ringPulse2 = true }
            withAnimation(.timingCurve(0.5, 0, 0.2, 1, duration: 2.1)) { barProgress = 1 }
        }
    }
}

// Simple flow layout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, maxH: CGFloat = 0
        for sv in subviews {
            let s = sv.sizeThatFits(.unspecified)
            if x + s.width > width && x > 0 { y += maxH + spacing; x = 0; maxH = 0 }
            x += s.width + spacing; maxH = max(maxH, s.height)
        }
        return CGSize(width: width, height: y + maxH)
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, maxH: CGFloat = 0
        for sv in subviews {
            let s = sv.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX && x > bounds.minX { y += maxH + spacing; x = bounds.minX; maxH = 0 }
            sv.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
            x += s.width + spacing; maxH = max(maxH, s.height)
        }
    }
}
