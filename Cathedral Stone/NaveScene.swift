import SwiftUI

struct NaveHue {
    let r: Double
    let g: Double
    let b: Double

    var colour: Color { Color(red: r, green: g, blue: b) }

    func at(_ a: Double) -> Color {
        Color(red: r, green: g, blue: b).opacity(max(0, min(1, a)))
    }

    func to(_ o: NaveHue, _ t: Double) -> NaveHue {
        let f = max(0, min(1, t))
        return NaveHue(r: r + (o.r - r) * f, g: g + (o.g - g) * f, b: b + (o.b - b) * f)
    }
}

struct NaveLight {
    let hour: Double
    let air: NaveHue
    let stone: NaveHue
    let shaft: NaveHue
    let strength: Double
    let shaftAcross: Double
    let candles: Double
    let caption: String
}

let naveKeys: [NaveLight] = [
    NaveLight(hour: 0, air: NaveHue(r: 0.078, g: 0.082, b: 0.098),
              stone: NaveHue(r: 0.235, g: 0.224, b: 0.204),
              shaft: NaveHue(r: 0.976, g: 0.847, b: 0.588),
              strength: 0.0, shaftAcross: 0.5, candles: 1.0, caption: "Matins"),
    NaveLight(hour: 7, air: NaveHue(r: 0.216, g: 0.220, b: 0.235),
              stone: NaveHue(r: 0.478, g: 0.451, b: 0.408),
              shaft: NaveHue(r: 0.976, g: 0.812, b: 0.616),
              strength: 0.52, shaftAcross: 0.16, candles: 0.62, caption: "Prime"),
    NaveLight(hour: 12, air: NaveHue(r: 0.451, g: 0.451, b: 0.443),
              stone: NaveHue(r: 0.761, g: 0.729, b: 0.667),
              shaft: NaveHue(r: 1.000, g: 0.965, b: 0.855),
              strength: 0.96, shaftAcross: 0.48, candles: 0.12, caption: "Sext"),
    NaveLight(hour: 16, air: NaveHue(r: 0.400, g: 0.388, b: 0.376),
              stone: NaveHue(r: 0.714, g: 0.678, b: 0.612),
              shaft: NaveHue(r: 0.992, g: 0.867, b: 0.671),
              strength: 0.80, shaftAcross: 0.72, candles: 0.20, caption: "None"),
    NaveLight(hour: 20, air: NaveHue(r: 0.169, g: 0.161, b: 0.169),
              stone: NaveHue(r: 0.373, g: 0.349, b: 0.318),
              shaft: NaveHue(r: 0.965, g: 0.741, b: 0.494),
              strength: 0.14, shaftAcross: 0.90, candles: 0.86, caption: "Compline"),
    NaveLight(hour: 24, air: NaveHue(r: 0.078, g: 0.082, b: 0.098),
              stone: NaveHue(r: 0.235, g: 0.224, b: 0.204),
              shaft: NaveHue(r: 0.976, g: 0.847, b: 0.588),
              strength: 0.0, shaftAcross: 0.5, candles: 1.0, caption: "Matins"),
]

func naveLight(hour: Double) -> NaveLight {
    let h = max(0, min(23.999, hour))
    var lo = naveKeys[0]
    var hi = naveKeys[naveKeys.count - 1]
    for i in 0..<(naveKeys.count - 1) where h >= naveKeys[i].hour && h <= naveKeys[i + 1].hour {
        lo = naveKeys[i]
        hi = naveKeys[i + 1]
    }
    let t = (h - lo.hour) / max(0.001, hi.hour - lo.hour)
    return NaveLight(hour: h,
                     air: lo.air.to(hi.air, t),
                     stone: lo.stone.to(hi.stone, t),
                     shaft: lo.shaft.to(hi.shaft, t),
                     strength: lo.strength + (hi.strength - lo.strength) * t,
                     shaftAcross: lo.shaftAcross + (hi.shaftAcross - lo.shaftAcross) * t,
                     candles: lo.candles + (hi.candles - lo.candles) * t,
                     caption: t < 0.5 ? lo.caption : hi.caption)
}

struct NaveScene: View {
    var hour: Double
    var seed: Int
    var pointed: Double

    var body: some View {
        let light = naveLight(hour: hour)
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let floor = h * 0.88

            ctx.fill(Path(CGRect(origin: .zero, size: size)),
                     with: .linearGradient(
                        Gradient(colors: [light.air.at(1.0),
                                          light.air.to(NaveHue(r: 0.05, g: 0.05, b: 0.06),
                                                       0.55).at(1.0)]),
                        startPoint: CGPoint(x: 0, y: 0),
                        endPoint: CGPoint(x: 0, y: h)))

            func arcade(_ cx: CGFloat, _ scale: CGFloat, _ tone: Color) {
                let halfSpan = w * 0.16 * scale
                let spring = floor - h * 0.34 * scale
                let apex = spring - halfSpan * CGFloat(1.0 + pointed * 0.85)
                var p = Path()
                p.move(to: CGPoint(x: cx - halfSpan, y: floor))
                p.addLine(to: CGPoint(x: cx - halfSpan, y: spring))
                p.addQuadCurve(to: CGPoint(x: cx, y: apex),
                               control: CGPoint(x: cx - halfSpan * CGFloat(1 - pointed * 0.7),
                                                y: spring - halfSpan * 0.7))
                p.addQuadCurve(to: CGPoint(x: cx + halfSpan, y: spring),
                               control: CGPoint(x: cx + halfSpan * CGFloat(1 - pointed * 0.7),
                                                y: spring - halfSpan * 0.7))
                p.addLine(to: CGPoint(x: cx + halfSpan, y: floor))
                ctx.stroke(p, with: .color(tone),
                           style: StrokeStyle(lineWidth: max(2, 9 * scale),
                                              lineCap: .round, lineJoin: .round))
            }

            for k in stride(from: 4, through: 1, by: -1) {
                let depth = CGFloat(k) / 4.0
                let scale = 0.42 + (1.0 - depth) * 0.62
                let shade = 0.28 + (1.0 - depth) * 0.52
                arcade(w * 0.50, CGFloat(scale),
                       light.stone.at(shade * (0.42 + light.strength * 0.66)))
            }

            let winX = w * (0.10 + light.shaftAcross * 0.16)
            let winTop = h * 0.10
            let winW = w * 0.10
            let winH = h * 0.30
            ctx.fill(Path(roundedRect: CGRect(x: winX, y: winTop,
                                              width: winW, height: winH),
                          cornerRadius: winW * 0.5),
                     with: .color(light.shaft.at(0.20 + light.strength * 0.74)))
            var mullion = Path()
            mullion.move(to: CGPoint(x: winX + winW / 2, y: winTop + winW * 0.4))
            mullion.addLine(to: CGPoint(x: winX + winW / 2, y: winTop + winH))
            ctx.stroke(mullion, with: .color(Color.black.opacity(0.46)),
                       style: StrokeStyle(lineWidth: 2.4))

            if light.strength > 0.05 {
                var beam = Path()
                beam.move(to: CGPoint(x: winX, y: winTop + winH))
                beam.addLine(to: CGPoint(x: winX + winW, y: winTop + winH * 0.20))
                beam.addLine(to: CGPoint(x: winX + w * 0.62, y: floor))
                beam.addLine(to: CGPoint(x: winX + w * 0.16, y: floor))
                beam.closeSubpath()
                ctx.fill(beam, with: .linearGradient(
                    Gradient(colors: [light.shaft.at(0.30 * light.strength),
                                      light.shaft.at(0.0)]),
                    startPoint: CGPoint(x: winX, y: winTop),
                    endPoint: CGPoint(x: winX + w * 0.5, y: floor)))

                var pool = Path()
                pool.addEllipse(in: CGRect(x: winX + w * 0.14, y: floor - h * 0.03,
                                           width: w * 0.46, height: h * 0.07))
                ctx.fill(pool, with: .color(light.shaft.at(0.24 * light.strength)))
            }

            ctx.fill(Path(CGRect(x: 0, y: floor, width: w, height: h - floor)),
                     with: .color(light.stone.to(NaveHue(r: 0.16, g: 0.15, b: 0.14),
                                                 0.50).at(1.0)))
            var rng = StoneSpin(seed &* 19 &+ 7)
            var fx = 0.0
            while fx < Double(w) {
                let step = rng.range(18, 40)
                var line = Path()
                line.move(to: CGPoint(x: CGFloat(fx), y: floor))
                line.addLine(to: CGPoint(x: CGFloat(fx) - 12, y: h))
                ctx.stroke(line, with: .color(Color.black.opacity(0.18)),
                           style: StrokeStyle(lineWidth: 1))
                fx += step
            }

            if light.candles > 0.10 {
                for k in 0..<3 {
                    let cx = w * (0.62 + Double(k) * 0.12)
                    let cy = floor - h * 0.10
                    for j in stride(from: 5, through: 1, by: -1) {
                        let rr = CGFloat(j) * 9
                        ctx.fill(Path(ellipseIn: CGRect(x: CGFloat(cx) - rr, y: cy - rr,
                                                        width: rr * 2, height: rr * 2)),
                                 with: .color(Color(red: 1.0, green: 0.85, blue: 0.56)
                                                .opacity(0.06 * light.candles)))
                    }
                    var stick = Path()
                    stick.move(to: CGPoint(x: CGFloat(cx), y: cy))
                    stick.addLine(to: CGPoint(x: CGFloat(cx), y: floor))
                    ctx.stroke(stick, with: .color(Color(red: 0.30, green: 0.26, blue: 0.20)),
                               style: StrokeStyle(lineWidth: 3))
                    ctx.fill(Path(ellipseIn: CGRect(x: CGFloat(cx) - 2.4, y: cy - 6,
                                                    width: 4.8, height: 8)),
                             with: .color(Color(red: 1.0, green: 0.90, blue: 0.66)
                                            .opacity(0.4 + 0.6 * light.candles)))
                }
            }
        }
        .drawingGroup()
    }
}

struct CollapseCanvas: View {
    let design: Design
    let analysis: Analysis
    var progress: Double

    var body: some View {
        Canvas { ctx, size in
            let rect = CGRect(origin: .zero, size: size)
            let w = rect.width, h = rect.height
            let ground = h * 0.90
            let metres = design.programme.span + analysis.baseWidth * 2 + 7.0
            let scale = min(w / CGFloat(metres),
                            ground / CGFloat(design.programme.vaultHeight * 0.80))
            let cx = w * 0.5
            let span = CGFloat(design.programme.span) * scale
            let spring = ground - CGFloat(design.programme.vaultHeight) * 0.54 * scale
            let apex = spring - CGFloat(analysis.rise) * scale * 0.72
            let base = CGFloat(analysis.baseWidth) * scale
            let t = max(0, min(1, progress))
            let ease = t * t

            ctx.fill(Path(rect), with: .color(Stone.night))
            ctx.fill(Path(CGRect(x: 0, y: ground, width: w, height: h - ground)),
                     with: .color(Stone.limeDark.opacity(0.44)))

            for sgn in [-1.0, 1.0] {
                let s = CGFloat(sgn)
                let pierX = cx + s * span * 0.5
                let pierW = max(6, CGFloat(design.pier.thickness) * scale)
                let butX = pierX + s * (base * 0.5 + span * 0.20)
                let lean = CGFloat(ease) * s * 0.40
                let drop = CGFloat(ease) * 22

                ctx.drawLayer { layer in
                    layer.translateBy(x: butX, y: ground)
                    layer.rotate(by: .radians(Double(lean)))
                    layer.translateBy(x: -butX, y: -ground)

                    var flyer = Path()
                    flyer.move(to: CGPoint(x: pierX + s * pierW * 0.4, y: spring + 8))
                    flyer.addQuadCurve(
                        to: CGPoint(x: butX - s * base * 0.3, y: spring + base * 1.5),
                        control: CGPoint(x: (pierX + butX) / 2, y: spring - base * 0.4))
                    layer.stroke(flyer, with: .color(Stone.limestone.opacity(0.86)),
                                 style: StrokeStyle(lineWidth: max(4, base * 0.42),
                                                    lineCap: .round))

                    var but = Path()
                    but.move(to: CGPoint(x: butX - base * 0.6, y: ground))
                    but.addLine(to: CGPoint(x: butX + base * 0.6, y: ground))
                    but.addLine(to: CGPoint(x: butX + base * 0.34, y: spring - drop))
                    but.addLine(to: CGPoint(x: butX - base * 0.34, y: spring - drop))
                    but.closeSubpath()
                    layer.fill(but, with: .color(Stone.limestone.opacity(0.90)))
                    layer.stroke(but, with: .color(Stone.ink.opacity(0.60)),
                                 style: StrokeStyle(lineWidth: 1.4))

                    var courses = Path()
                    var cy = ground - 10
                    while cy > spring - drop {
                        courses.move(to: CGPoint(x: butX - base * 0.55, y: cy))
                        courses.addLine(to: CGPoint(x: butX + base * 0.55, y: cy))
                        cy -= max(7, base * 0.30)
                    }
                    layer.stroke(courses, with: .color(Stone.ink.opacity(0.22)),
                                 style: StrokeStyle(lineWidth: 1))
                }

                let pier = CGRect(x: pierX - pierW / 2, y: spring,
                                  width: pierW, height: ground - spring)
                ctx.fill(Path(pier), with: .linearGradient(
                    Gradient(colors: [Stone.limestone, Stone.limeDark]),
                    startPoint: CGPoint(x: pier.minX, y: 0),
                    endPoint: CGPoint(x: pier.maxX, y: 0)))
                ctx.stroke(Path(pier), with: .color(Stone.ink.opacity(0.58)),
                           style: StrokeStyle(lineWidth: 1.4))
            }

            let blocks = 19
            var rng = StoneSpin(Int(design.programme.span * 1000)
                                &+ Int(analysis.thrust))
            for k in 0..<blocks {
                let f = Double(k) / Double(blocks - 1)
                let ang = Double.pi * f
                let bx = cx - CGFloat(cos(ang)) * span * 0.5
                let by = spring - CGFloat(sin(ang)) * (spring - apex)
                let fall = CGFloat(ease * ease) * CGFloat(rng.range(0.6, 1.6))
                    * (ground - by)
                let spin = ease * rng.range(-2.8, 2.8)
                let sway = CGFloat(ease) * CGFloat(rng.range(-52, 52))
                let bw = span / CGFloat(blocks) * 1.30
                let bh = bw * 0.80

                ctx.drawLayer { layer in
                    layer.translateBy(x: bx + sway, y: min(by + fall, ground - bh * 0.4))
                    layer.rotate(by: .radians(spin))
                    let r = CGRect(x: -bw / 2, y: -bh / 2, width: bw, height: bh)
                    layer.fill(Path(r), with: .linearGradient(
                        Gradient(colors: [Stone.limestone,
                                          Stone.limeDark.opacity(0.92)]),
                        startPoint: CGPoint(x: r.minX, y: r.minY),
                        endPoint: CGPoint(x: r.maxX, y: r.maxY)))
                    layer.stroke(Path(r), with: .color(Stone.ink.opacity(0.58)),
                                 style: StrokeStyle(lineWidth: 1.2))
                }
            }

            if ease > 0.10 {
                var rng2 = StoneSpin(77)
                for _ in 0..<140 {
                    let px = CGFloat(rng2.range(Double(cx - span * 0.9),
                                                Double(cx + span * 0.9)))
                    let py = ground - CGFloat(rng2.range(0, 130)) * CGFloat(ease)
                    let rr = CGFloat(rng2.range(1.5, 8)) * CGFloat(ease)
                    ctx.fill(Path(ellipseIn: CGRect(x: px, y: py, width: rr, height: rr)),
                             with: .color(Stone.limeDark.opacity(0.30 * ease)))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Stone.ink.opacity(0.26),
                                                           lineWidth: 1))
    }
}
