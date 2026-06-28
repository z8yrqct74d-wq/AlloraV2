import SwiftUI

enum OrbDisplayMode: String {
    case idle, thinking, converge
}

struct AlloraOrbView: View {
    var mode: OrbDisplayMode = .idle
    var size: CGFloat = 158

    @State private var time: Double = 0
    @State private var rotation: Double = 0
    @State private var gather: Double = 0
    @State private var glowIntensity: Double = 0
    @State private var particles: [OrbParticle] = []

    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#F4CA8E").opacity(0.42), .clear],
                        center: .center, startRadius: 0, endRadius: size * 0.7
                    )
                )
                .blur(radius: 10)
                .scaleEffect(1 + 0.06 * sin(time * 0.9))

            // Canvas particle sphere
            Canvas { ctx, canvasSize in
                drawOrb(ctx: ctx, size: canvasSize)
            }
            .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
        .onReceive(timer) { _ in
            updateAnimation()
        }
        .onAppear {
            particles = makeParticles()
        }
    }

    private func updateAnimation() {
        time += 1/60
        let targetRot: Double
        let targetGather: Double
        let targetGlow: Double
        switch mode {
        case .thinking: targetRot = 0.55; targetGather = 0.14; targetGlow = 0.34
        case .converge: targetRot = 0.92; targetGather = 1.0;  targetGlow = 0.62
        case .idle:     targetRot = 0.16; targetGather = 0;    targetGlow = 0
        }
        let k = 1 - pow(0.0025, 1/60.0)
        rotation += (targetRot - rotation) * k * 0.016 * 60
        gather += (targetGather - gather) * k
        glowIntensity += (targetGlow - glowIntensity) * k
    }

    private func drawOrb(ctx: GraphicsContext, size: CGSize) {
        let w = size.width, h = size.height
        let cx = w/2, cy = h/2
        let breathe = 1 + 0.028 * sin(time * 0.9)
        let R = w * 0.42 * breathe * (1 - 0.5 * gather)
        let ry = time * rotation
        let cosRY = cos(ry), sinRY = sin(ry)
        let tx = -0.3, cosTX = cos(tx), sinTX = sin(tx)

        // Backing glow
        let backPath = Path(ellipseIn: CGRect(x: cx - R*1.2, y: cy - R*1.2, width: R*2.4, height: R*2.4))
        ctx.fill(backPath, with: .color(Color(hex: "#42221280").opacity(0.34)))

        let baseParticleSize = w * 0.02

        for p in particles {
            var x = p.dx * cosRY + p.dz * sinRY
            var z = -p.dx * sinRY + p.dz * cosRY
            var y = p.dy
            let y2 = y * cosTX - z * sinTX
            let z2 = y * sinTX + z * cosTX
            y = y2; z = z2
            let depth = (z + 1) / 2
            let m = p.mass * (1 + 0.05 * sin(time * p.driftSpeed + p.twistPhase))
            let rad = R * m
            let sx = cx + x * rad
            let sy = cy + y * rad
            let tw = 0.62 + 0.38 * sin(time * p.twistSpeed + p.twistPhase)
            var alpha = p.baseAlpha * (0.45 + depth * 0.62) * tw * (1 - 0.42 * m * m)
            alpha *= (0.95 + glowIntensity * 0.6)
            guard alpha > 0.02 else { continue }
            alpha = min(1, alpha)
            let psz = baseParticleSize * p.size * (0.6 + depth * 0.85) * (1 + glowIntensity * 0.25)
            let particleRect = CGRect(x: sx - psz, y: sy - psz, width: psz*2, height: psz*2)
            let pPath = Path(ellipseIn: particleRect)
            ctx.fill(pPath, with: .color(p.color.opacity(alpha)))
        }

        // Core glow
        let glowA = (0.3 + glowIntensity * 0.5) * (0.88 + 0.12 * sin(time * 1.5))
        let coreRect = CGRect(x: cx - R*0.95, y: cy - R*0.95, width: R*1.9, height: R*1.9)
        let corePath = Path(ellipseIn: coreRect)
        ctx.fill(corePath, with: .color(Color(hex: "#FFD296").opacity(glowA * 0.4)))
    }

    private func makeParticles() -> [OrbParticle] {
        let N = Int(min(1800, max(140, size * 9)))
        let cols: [Color] = [
            Color(hex: "#F7E7C4"), Color(hex: "#FCF0DE"), Color(hex: "#FFCE80"),
            Color(hex: "#F0A660"), Color(hex: "#CE7C4C"), Color(hex: "#AC7048"), Color(hex: "#CA8074")
        ]
        let weights = [0,0,0,1,1,2,2,2,3,3,4,5,6]
        return (0..<N).map { _ in
            let u = Double.random(in: -1...1)
            let ph = Double.random(in: 0...(.pi*2))
            let sr = sqrt(1 - u*u)
            let m = pow(Double.random(in: 0...1), 1.15)
            let ci = weights[Int.random(in: 0..<weights.count)]
            return OrbParticle(
                dx: sr * cos(ph), dy: u, dz: sr * sin(ph),
                mass: m, color: cols[ci],
                size: 0.55 + Double.random(in: 0...1.05),
                baseAlpha: 0.5 + Double.random(in: 0...0.45),
                twistPhase: Double.random(in: 0...(.pi*2)),
                twistSpeed: 0.5 + Double.random(in: 0...1.6),
                driftSpeed: 0.4 + Double.random(in: 0...1.1)
            )
        }
    }
}

struct OrbParticle {
    let dx, dy, dz: Double
    let mass: Double
    let color: Color
    let size: Double
    let baseAlpha: Double
    let twistPhase: Double
    let twistSpeed: Double
    let driftSpeed: Double
}
