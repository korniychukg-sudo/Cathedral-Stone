import SwiftUI

struct ArchGlyph: View {
    var size: CGFloat = 24
    var colour: Color = Stone.ink

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.14, y: h * 0.92))
            p.addLine(to: CGPoint(x: w * 0.14, y: h * 0.48))
            p.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.10),
                           control: CGPoint(x: w * 0.18, y: h * 0.20))
            p.addQuadCurve(to: CGPoint(x: w * 0.86, y: h * 0.48),
                           control: CGPoint(x: w * 0.82, y: h * 0.20))
            p.addLine(to: CGPoint(x: w * 0.86, y: h * 0.92))
            ctx.stroke(p, with: .color(colour),
                       style: StrokeStyle(lineWidth: w * 0.10, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct SiteGlyph: View {
    var size: CGFloat = 24
    var colour: Color = Stone.ink

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            var arch = Path()
            arch.move(to: CGPoint(x: w * 0.24, y: h * 0.90))
            arch.addLine(to: CGPoint(x: w * 0.24, y: h * 0.52))
            arch.addQuadCurve(to: CGPoint(x: w * 0.56, y: h * 0.18),
                              control: CGPoint(x: w * 0.28, y: h * 0.26))
            arch.addQuadCurve(to: CGPoint(x: w * 0.88, y: h * 0.52),
                              control: CGPoint(x: w * 0.84, y: h * 0.26))
            arch.addLine(to: CGPoint(x: w * 0.88, y: h * 0.90))
            ctx.stroke(arch, with: .color(colour),
                       style: StrokeStyle(lineWidth: w * 0.085, lineCap: .round, lineJoin: .round))
            var scaff = Path()
            scaff.move(to: CGPoint(x: w * 0.08, y: h * 0.16))
            scaff.addLine(to: CGPoint(x: w * 0.08, y: h * 0.92))
            for k in 0..<3 {
                let y = h * (0.30 + Double(k) * 0.22)
                scaff.move(to: CGPoint(x: w * 0.04, y: y))
                scaff.addLine(to: CGPoint(x: w * 0.24, y: y))
            }
            ctx.stroke(scaff, with: .color(colour.opacity(0.7)),
                       style: StrokeStyle(lineWidth: w * 0.055, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct FabricGlyph: View {
    var size: CGFloat = 24
    var colour: Color = Stone.ink

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            for (k, hgt) in [0.52, 0.30, 0.62].enumerated() {
                let x = w * (0.14 + Double(k) * 0.28)
                var tower = Path()
                tower.addRect(CGRect(x: x, y: h * (1 - hgt) - h * 0.06,
                                     width: w * 0.20, height: h * hgt))
                ctx.stroke(tower, with: .color(colour),
                           style: StrokeStyle(lineWidth: w * 0.065, lineJoin: .round))
                var spire = Path()
                spire.move(to: CGPoint(x: x, y: h * (1 - hgt) - h * 0.06))
                spire.addLine(to: CGPoint(x: x + w * 0.10, y: h * (1 - hgt) - h * 0.22))
                spire.addLine(to: CGPoint(x: x + w * 0.20, y: h * (1 - hgt) - h * 0.06))
                ctx.stroke(spire, with: .color(colour),
                           style: StrokeStyle(lineWidth: w * 0.055, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
    }
}

struct LodgeGlyph: View {
    var size: CGFloat = 24
    var colour: Color = Stone.ink

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            for sgn in [-1.0, 1.0] {
                var page = Path()
                page.move(to: CGPoint(x: w * 0.50, y: h * 0.24))
                page.addCurve(to: CGPoint(x: w * (0.50 + sgn * 0.42), y: h * 0.20),
                              control1: CGPoint(x: w * (0.50 + sgn * 0.16), y: h * 0.14),
                              control2: CGPoint(x: w * (0.50 + sgn * 0.32), y: h * 0.14))
                page.addLine(to: CGPoint(x: w * (0.50 + sgn * 0.42), y: h * 0.78))
                page.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.82),
                              control1: CGPoint(x: w * (0.50 + sgn * 0.30), y: h * 0.74),
                              control2: CGPoint(x: w * (0.50 + sgn * 0.16), y: h * 0.74))
                page.closeSubpath()
                ctx.stroke(page, with: .color(colour),
                           style: StrokeStyle(lineWidth: w * 0.075, lineJoin: .round))
            }
            var compass = Path()
            compass.move(to: CGPoint(x: w * 0.72, y: h * 0.34))
            compass.addLine(to: CGPoint(x: w * 0.64, y: h * 0.62))
            compass.move(to: CGPoint(x: w * 0.72, y: h * 0.34))
            compass.addLine(to: CGPoint(x: w * 0.82, y: h * 0.62))
            ctx.stroke(compass, with: .color(colour.opacity(0.8)),
                       style: StrokeStyle(lineWidth: w * 0.05, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct RollsGlyph: View {
    var size: CGFloat = 24
    var colour: Color = Stone.ink

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            let page = Path(roundedRect: CGRect(x: w * 0.18, y: h * 0.10,
                                                width: w * 0.62, height: h * 0.80),
                            cornerRadius: w * 0.06)
            ctx.stroke(page, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.075))
            for k in 0..<4 {
                var line = Path()
                let y = h * (0.28 + Double(k) * 0.16)
                line.move(to: CGPoint(x: w * 0.28, y: y))
                line.addLine(to: CGPoint(x: w * (k == 3 ? 0.54 : 0.68), y: y))
                ctx.stroke(line, with: .color(colour.opacity(0.7)),
                           style: StrokeStyle(lineWidth: w * 0.055, lineCap: .round))
            }
            var pen = Path()
            pen.move(to: CGPoint(x: w * 0.64, y: h * 0.84))
            pen.addLine(to: CGPoint(x: w * 0.94, y: h * 0.24))
            ctx.stroke(pen, with: .color(colour),
                       style: StrokeStyle(lineWidth: w * 0.075, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}
