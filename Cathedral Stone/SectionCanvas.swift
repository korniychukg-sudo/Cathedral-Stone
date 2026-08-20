import SwiftUI

struct SectionView: View {
    let design: Design
    let analysis: Analysis
    var built: Set<String>
    var showThrust: Bool
    var phase: Double = 0

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                draw(ctx, CGRect(origin: .zero, size: size))
            }
        }
    }

    private func draw(_ ctx: GraphicsContext, _ rect: CGRect) {
        let w = rect.width, h = rect.height
        let cx = rect.midX
        let groundY = h * 0.90
        let heightRange = 52.0
        let scale = (groundY - h * 0.10) / heightRange

        func y(_ metres: Double) -> CGFloat { groundY - CGFloat(metres * scale) }
        func poly(_ pts: [CGPoint]) -> Path {
            var p = Path()
            guard let f = pts.first else { return p }
            p.move(to: f)
            for q in pts.dropFirst() { p.addLine(to: q) }
            p.closeSubpath()
            return p
        }
        func block(_ pts: [CGPoint], _ tone: Color, _ shade: Double) {
            let path = poly(pts)
            ctx.fill(path, with: .color(tone))
            let box = path.boundingRect
            if box.width > 3 && box.height > 3 {
                var inner = ctx
                inner.clip(to: path)
                inner.fill(Path(CGRect(x: box.minX, y: box.minY,
                                       width: box.width * 0.20, height: box.height)),
                           with: .color(tone.opacity(1).darkened(0.14)))
                inner.fill(Path(CGRect(x: box.minX + box.width * 0.28, y: box.minY,
                                       width: box.width * 0.16, height: box.height)),
                           with: .color(tone.lightened(0.20)))
                inner.fill(Path(CGRect(x: box.minX + box.width * 0.76, y: box.minY,
                                       width: box.width * 0.24, height: box.height)),
                           with: .color(tone.darkened(0.16 + shade * 0.14)))
            }
            ctx.stroke(path, with: .color(Stone.ink.opacity(0.72)),
                       style: StrokeStyle(lineWidth: 1.2, lineJoin: .round))
        }

        let span = design.programme.span
        let vh = design.programme.vaultHeight
        let mScale = min(w / 46.0, CGFloat(scale))
        func x(_ metres: Double) -> CGFloat { cx + CGFloat(metres) * mScale }

        var ground = Path()
        ground.move(to: CGPoint(x: 0, y: groundY))
        ground.addLine(to: CGPoint(x: w, y: groundY))
        ctx.stroke(ground, with: .color(Stone.ink.opacity(0.5)),
                   style: StrokeStyle(lineWidth: 2))
        for k in stride(from: 0, to: Int(w), by: 12) {
            var tick = Path()
            tick.move(to: CGPoint(x: CGFloat(k), y: groundY))
            tick.addLine(to: CGPoint(x: CGFloat(k) - 7, y: groundY + 8))
            ctx.stroke(tick, with: .color(Stone.ink.opacity(0.20)),
                       style: StrokeStyle(lineWidth: 1))
        }

        let halfNave = span / 2.0
        let pierW = design.pier.thickness
        let aisleOut = halfNave + pierW + span * 0.62
        let bBase = analysis.baseWidth

        var envelope = Path()
        let rise0 = halfNave * (1 + design.arch.pointed * 0.62)
        envelope.move(to: CGPoint(x: x(-halfNave), y: groundY))
        envelope.addLine(to: CGPoint(x: x(-halfNave), y: y(vh)))
        for i in 0...30 {
            let t = Double(i) / 30.0
            let px = -halfNave + span * t
            let u = px / halfNave
            let semi = max(0, 1 - u * u).squareRoot()
            let point = 1 - abs(u)
            let shape = semi * (1 - design.arch.pointed) + pow(point, 0.72) * design.arch.pointed
            envelope.addLine(to: CGPoint(x: x(px), y: y(vh + rise0 * shape)))
        }
        envelope.addLine(to: CGPoint(x: x(halfNave), y: groundY))
        ctx.stroke(envelope, with: .color(Stone.ink.opacity(0.24)),
                   style: StrokeStyle(lineWidth: 1.4, dash: [6, 6]))
        for mark in [10.0, 20.0, 30.0, 40.0] where mark < vh + 8 {
            var tick = Path()
            tick.move(to: CGPoint(x: 8, y: y(mark)))
            tick.addLine(to: CGPoint(x: 20, y: y(mark)))
            ctx.stroke(tick, with: .color(Stone.ink.opacity(0.22)),
                       style: StrokeStyle(lineWidth: 1))
            ctx.draw(Text(String(format: "%.0f", mark))
                        .font(StoneFont.body(9))
                        .foregroundColor(Stone.inkPale),
                     at: CGPoint(x: 30, y: y(mark)))
        }

        for sgn in [-1.0, 1.0] {
            if built.contains("buttress") {
                let bx = aisleOut + bBase / 2
                let butt = [CGPoint(x: x(sgn * (bx - bBase / 2)), y: groundY),
                            CGPoint(x: x(sgn * (bx + bBase / 2)), y: groundY),
                            CGPoint(x: x(sgn * (bx + bBase * 0.30)), y: y(vh * 0.86)),
                            CGPoint(x: x(sgn * (bx - bBase * 0.42)), y: y(vh * 0.86))]
                block(butt, Stone.limestone, 0.4)

                if design.buttress.relief > 0.05 {
                    let tiers = design.buttress.relief > 0.25 ? 2 : 1
                    for t in 0..<tiers {
                        let fy = vh * (0.78 - Double(t) * 0.20)
                        var flyer = Path()
                        let x0 = x(sgn * (bx - bBase * 0.40))
                        let y0 = y(vh * 0.84 - Double(t) * vh * 0.14)
                        let x1 = x(sgn * halfNave)
                        let y1 = y(fy)
                        flyer.move(to: CGPoint(x: x0, y: y0))
                        flyer.addQuadCurve(to: CGPoint(x: x1, y: y1),
                                           control: CGPoint(x: (x0 + x1) / 2,
                                                            y: min(y0, y1) - 26))
                        ctx.stroke(flyer, with: .color(Stone.limestone),
                                   style: StrokeStyle(lineWidth: 11, lineCap: .round))
                        ctx.stroke(flyer, with: .color(Stone.ink.opacity(0.62)),
                                   style: StrokeStyle(lineWidth: 1.4))
                    }
                }
            }
            if built.contains("pinnacle") && design.pinnacle.weight > 1 {
                let bx = aisleOut + bBase / 2
                let px = x(sgn * (bx - bBase * 0.06))
                let ph = CGFloat(design.pinnacle.weight / 260.0) * 30 + 12
                var pin = Path()
                pin.move(to: CGPoint(x: px - 8, y: y(vh * 0.86)))
                pin.addLine(to: CGPoint(x: px + 8, y: y(vh * 0.86)))
                pin.addLine(to: CGPoint(x: px + 4, y: y(vh * 0.86) - ph * 0.44))
                pin.addLine(to: CGPoint(x: px, y: y(vh * 0.86) - ph))
                pin.addLine(to: CGPoint(x: px - 4, y: y(vh * 0.86) - ph * 0.44))
                pin.closeSubpath()
                ctx.fill(pin, with: .color(Stone.limestone.lightened(0.10)))
                ctx.stroke(pin, with: .color(Stone.ink.opacity(0.72)),
                           style: StrokeStyle(lineWidth: 1.2, lineJoin: .round))
            }
            if built.contains("pier") {
                let pier = [CGPoint(x: x(sgn * halfNave), y: groundY),
                            CGPoint(x: x(sgn * (halfNave + pierW)), y: groundY),
                            CGPoint(x: x(sgn * (halfNave + pierW)), y: y(vh)),
                            CGPoint(x: x(sgn * halfNave), y: y(vh))]
                block(pier, Stone.limestone, 0.3)
                let aisle = [CGPoint(x: x(sgn * (halfNave + pierW)), y: groundY),
                             CGPoint(x: x(sgn * aisleOut), y: groundY),
                             CGPoint(x: x(sgn * aisleOut), y: y(vh * 0.42)),
                             CGPoint(x: x(sgn * (halfNave + pierW)), y: y(vh * 0.46))]
                block(aisle, Stone.limestone.darkened(0.05), 0.5)
            }
        }

        if built.contains("arch") {
            let springY = vh * 0.44
            var arch = Path()
            let steps = 40
            for i in 0...steps {
                let t = Double(i) / Double(steps)
                let px = -halfNave + span * t
                let u = px / halfNave
                let semi = max(0, 1 - u * u).squareRoot()
                let point = 1 - abs(u)
                let shape = semi * (1 - design.arch.pointed)
                    + pow(point, 0.72) * design.arch.pointed
                let rise = halfNave * (1 + design.arch.pointed * 0.62)
                let p = CGPoint(x: x(px), y: y(springY + rise * shape))
                if i == 0 { arch.move(to: p) } else { arch.addLine(to: p) }
            }
            ctx.stroke(arch, with: .color(Stone.limestone),
                       style: StrokeStyle(lineWidth: 12, lineCap: .round))
            ctx.stroke(arch, with: .color(Stone.ink.opacity(0.62)),
                       style: StrokeStyle(lineWidth: 1.4))
        }

        if built.contains("vault") {
            var vault = Path()
            let steps = 40
            let rise = halfNave * (1 + design.arch.pointed * 0.62)
            for i in 0...steps {
                let t = Double(i) / Double(steps)
                let px = -halfNave + span * t
                let u = px / halfNave
                let semi = max(0, 1 - u * u).squareRoot()
                let point = 1 - abs(u)
                let shape = semi * (1 - design.arch.pointed)
                    + pow(point, 0.72) * design.arch.pointed
                let p = CGPoint(x: x(px), y: y(vh + rise * shape))
                if i == 0 { vault.move(to: p) } else { vault.addLine(to: p) }
            }
            let thickness = CGFloat(design.vault.weight / 26.0) * 13 + 5
            ctx.stroke(vault, with: .color(Stone.limestone.lightened(0.08)),
                       style: StrokeStyle(lineWidth: thickness, lineCap: .round))
            ctx.stroke(vault, with: .color(Stone.ink.opacity(0.60)),
                       style: StrokeStyle(lineWidth: 1.4))

            var roof = Path()
            let crown = y(vh + rise) - thickness / 2
            roof.move(to: CGPoint(x: x(-halfNave - 0.6), y: crown))
            roof.addLine(to: CGPoint(x: cx, y: crown - CGFloat(span * 0.30) * mScale))
            roof.addLine(to: CGPoint(x: x(halfNave + 0.6), y: crown))
            roof.closeSubpath()
            ctx.fill(roof, with: .color(Stone.lead.opacity(0.62)))
            ctx.stroke(roof, with: .color(Stone.ink.opacity(0.60)),
                       style: StrokeStyle(lineWidth: 1.3, lineJoin: .round))
        }

        guard showThrust, built.contains("buttress") else { return }

        let colour: Color
        switch analysis.verdict {
        case .safe: colour = Stone.moss
        case .cracked: colour = Stone.amber
        default: colour = Stone.oxblood
        }
        let anim = min(1.0, max(0.0, phase))

        for sgn in [-1.0, 1.0] {
            let bx = aisleOut + bBase / 2
            let footOffset = min(bBase / 2 * 1.30, analysis.eccentricity)
            var pts: [CGPoint] = []
            let rise = halfNave * (1 + design.arch.pointed * 0.62)
            pts.append(CGPoint(x: cx, y: y(vh + rise * 0.92)))
            pts.append(CGPoint(x: x(sgn * halfNave * 0.60), y: y(vh + rise * 0.52)))
            pts.append(CGPoint(x: x(sgn * halfNave), y: y(vh * 0.98)))
            pts.append(CGPoint(x: x(sgn * (halfNave + pierW + span * 0.24)),
                               y: y(vh * (0.84 - design.buttress.relief * 0.30))))
            pts.append(CGPoint(x: x(sgn * (bx - bBase * 0.10)), y: y(vh * 0.50)))
            pts.append(CGPoint(x: x(sgn * (bx + footOffset)), y: groundY))

            var line = Path()
            let n = 60
            for i in 0...n {
                let t = Double(i) / Double(n)
                if t > anim { break }
                let seg = t * Double(pts.count - 1)
                let i0 = min(pts.count - 2, Int(seg))
                let f = CGFloat(seg - Double(i0))
                let a = pts[i0], b = pts[i0 + 1]
                let p = CGPoint(x: a.x + (b.x - a.x) * f, y: a.y + (b.y - a.y) * f)
                if i == 0 { line.move(to: p) } else { line.addLine(to: p) }
            }
            ctx.stroke(line, with: .color(colour),
                       style: StrokeStyle(lineWidth: 3.6, lineCap: .round, lineJoin: .round))

            if anim >= 0.98 {
                let foot = CGPoint(x: x(sgn * (bx + footOffset)), y: groundY)
                ctx.fill(Path(ellipseIn: CGRect(x: foot.x - 6, y: foot.y - 6,
                                                width: 12, height: 12)),
                         with: .color(colour))
                let third = CGFloat(analysis.middleThird) * mScale
                var band = Path()
                band.addRect(CGRect(x: x(sgn * bx) - third, y: groundY - 8,
                                    width: third * 2, height: 16))
                ctx.stroke(band, with: .color(Stone.moss.opacity(0.55)),
                           style: StrokeStyle(lineWidth: 1.4, dash: [4, 4]))
            }
        }
    }
}

extension Color {
    func lightened(_ t: Double) -> Color {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        let k = CGFloat(max(0, min(1, t)))
        return Color(red: Double(r + (1 - r) * k), green: Double(g + (1 - g) * k),
                     blue: Double(b + (1 - b) * k))
    }

    func darkened(_ t: Double) -> Color {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        let k = CGFloat(max(0, min(1, t)))
        return Color(red: Double(r * (1 - k)), green: Double(g * (1 - k)),
                     blue: Double(b * (1 - k)))
    }
}
