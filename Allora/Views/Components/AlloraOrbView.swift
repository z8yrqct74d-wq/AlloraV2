import SwiftUI

/// Display modes for the Allora orb. See `AlloraOrbView` and the handoff doc
/// (`DESIGN_HANDOFF.md`) for the full state machine.
enum OrbDisplayMode: String {
    case idle       // calm, slow drift — Home resting state
    case thinking   // gathering energy, faster rotation, warm-up glow
    case converge   // particles pull to center, brightest — "answer forming"
}

/// Allora's signature warm dining orb.
///
/// A volumetric champagne/amber/candlelit particle sphere rendered with a
/// `Canvas` and driven by a per-frame timer. Motion quality is Apple-inspired
/// (smooth critically-damped easing, gentle breathing, depth-sorted additive
/// particles) but the palette and behavior are Allora's own: atmospheric,
/// warm, and alive rather than clinical.
///
/// State is eased toward per-mode targets every frame so transitions between
/// `idle → thinking → converge` are continuous, never cut. A `pulse` counter
/// fires a short transient (a small inward "breath" + glow swell) used when a
/// prompt chip is tapped.
struct AlloraOrbView: View {
    var mode: OrbDisplayMode = .idle
    var size: CGFloat = 158
    /// Increment to fire a one-shot pulse transient (e.g. on prompt-chip tap).
    var pulse: Int = 0

    @State private var time: Double = 0
    @State private var rotationAngle: Double = 0      // integrated, not derived
    @State private var rotationRate: Double = 0.16
    @State private var gather: Double = 0
    @State private var glowIntensity: Double = 0
    @State private var particles: [OrbParticle] = []
    @State private var pulseStart: Double = -9999
    @State private var lastPulse: Int = 0

    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Outer ambient bloom — sits behind the sphere
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#F4CA8E").opacity(0.42), .clear],
                        center: .center, startRadius: 0, endRadius: size * 0.7
                    )
                )
                .blur(radius: 10)
                .scaleEffect(1 + 0.06 * sin(time * 0.9))

            Canvas { ctx, canvasSize in
                drawOrb(ctx: ctx, size: canvasSize)
            }
            .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
        .onReceive(timer) { _ in updateAnimation() }
        .onAppear { if particles.isEmpty { particles = makeParticles() } }
        .onChange(of: pulse) { _, newValue in
            if newValue != lastPulse {
                lastPulse = newValue
                pulseStart = time
            }
        }
    }

    private func updateAnimation() {
        let dt = 1.0 / 60.0
        time += dt

        let targetRate: Double, targetGather: Double, targetGlow: Double
        switch mode {
        case .thinking: targetRate = 0.55; targetGather = 0.14; targetGlow = 0.34
        case .converge: targetRate = 0.92; targetGather = 1.00; targetGlow = 0.62
        case .idle:     targetRate = 0.16; targetGather = 0.00; targetGlow = 0.00
        }

        // Critically-damped smoothing, frame-rate independent (matches the
        // prototype's `k = 1 - 0.0025^dt`).
        let k = 1 - pow(0.0025, dt)
        rotationRate  += (targetRate   - rotationRate)  * k
        gather        += (targetGather - gather)        * k
        glowIntensity += (targetGlow   - glowIntensity) * k

        // Integrate the angle so changing the rate never snaps the rotation.
        rotationAngle += dt * rotationRate
    }

    private func drawOrb(ctx incomingCtx: GraphicsContext, size: CGSize) {
        // GraphicsContext is a value type; take a mutable copy so we can set
        // `blendMode` for the additive particle/glow passes.
        var ctx = incomingCtx
        let w = size.width, h = size.height
        let cx = w/2, cy = h/2
        let breathe = 1 + 0.028 * sin(time * 0.9)

        // One-shot pulse transient: a half-sine swell over ~620ms.
        var pulseGather = 0.0, pulseGlow = 0.0
        let pe = (time - pulseStart) / 0.62
        if pe >= 0 && pe <= 1 {
            let wv = sin(pe * .pi)
            pulseGather = 0.07 * wv
            pulseGlow = 0.5 * wv
        }

        let gatherNow = gather + pulseGather
        let glowNow = glowIntensity + pulseGlow
        let R = w * 0.42 * breathe * (1 - 0.5 * gatherNow)

        let ry = rotationAngle
        let cosRY = cos(ry), sinRY = sin(ry)
        let tx = -0.3, cosTX = cos(tx), sinTX = sin(tx)

        // Warm backing so the dust reads on light surfaces.
        let backPath = Path(ellipseIn: CGRect(x: cx - R*1.2, y: cy - R*1.2, width: R*2.4, height: R*2.4))
        ctx.fill(backPath, with: .radialGradient(
            Gradient(colors: [Color(hex: "#42221E").opacity(0.30), .clear]),
            center: CGPoint(x: cx, y: cy), startRadius: 0, endRadius: R * 1.2
        ))

        // Additive particle field (depth-shaded champagne → bronze).
        ctx.blendMode = .plusLighter
        let baseParticleSize = w * 0.02
        for p in particles {
            let x = p.dx * cosRY + p.dz * sinRY
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
            alpha *= (0.95 + glowNow * 0.6)
            guard alpha > 0.02 else { continue }
            alpha = min(1, alpha)
            let psz = baseParticleSize * p.size * (0.6 + depth * 0.85) * (1 + glowNow * 0.25)
            let rect = CGRect(x: sx - psz, y: sy - psz, width: psz*2, height: psz*2)
            ctx.fill(Path(ellipseIn: rect), with: .color(p.color.opacity(alpha)))
        }

        // Warm core glow.
        ctx.blendMode = .plusLighter
        let glowA = (0.3 + glowNow * 0.5) * (0.88 + 0.12 * sin(time * 1.5))
        let coreRect = CGRect(x: cx - R*0.95, y: cy - R*0.95, width: R*1.9, height: R*1.9)
        ctx.fill(Path(ellipseIn: coreRect), with: .radialGradient(
            Gradient(colors: [
                Color(hex: "#FFD296").opacity(glowA),
                Color(hex: "#EE9656").opacity(glowA * 0.45),
                Color(hex: "#EE9656").opacity(0)
            ]),
            center: CGPoint(x: cx, y: cy), startRadius: 0, endRadius: R * 0.95
        ))
    }

    private func makeParticles() -> [OrbParticle] {
        let n = Int(min(1800, max(140, size * 9)))
        // Warm dining palette: champagne, pearl, candlelight gold, amber,
        // copper, bronze, blush.
        let cols: [Color] = [
            Color(hex: "#F7E7C4"), Color(hex: "#FCF0DE"), Color(hex: "#FFCE80"),
            Color(hex: "#F0A660"), Color(hex: "#CE7C4C"), Color(hex: "#AC7048"),
            Color(hex: "#CA8074")
        ]
        // Bias toward the warmer/brighter end (center-dense look).
        let weights = [0,0,0,1,1,2,2,2,3,3,4,5,6]
        return (0..<n).map { _ in
            let u = Double.random(in: -1...1)
            let ph = Double.random(in: 0...(.pi*2))
            let sr = (1 - u*u).squareRoot()
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
