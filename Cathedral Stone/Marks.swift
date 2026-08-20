import SwiftUI

struct StarMark: View {
    var size: CGFloat = 18
    var colour: Color = Stone.amber
    var filled: Bool = true

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            var p = Path()
            let cx = w / 2, cy = h / 2
            for k in 0..<10 {
                let a = Double(k) * .pi / 5 - .pi / 2
                let r = k % 2 == 0 ? Double(w) * 0.48 : Double(w) * 0.20
                let pt = CGPoint(x: cx + CGFloat(cos(a) * r), y: cy + CGFloat(sin(a) * r))
                if k == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
            }
            p.closeSubpath()
            if filled {
                ctx.fill(p, with: .color(colour))
            } else {
                ctx.stroke(p, with: .color(colour.opacity(0.55)),
                           style: StrokeStyle(lineWidth: w * 0.08, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
    }
}

struct ChevronMark: View {
    var size: CGFloat = 14
    var colour: Color = Stone.inkPale
    var pointsLeft: Bool = false

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            var p = Path()
            if pointsLeft {
                p.move(to: CGPoint(x: w * 0.68, y: h * 0.16))
                p.addLine(to: CGPoint(x: w * 0.30, y: h * 0.50))
                p.addLine(to: CGPoint(x: w * 0.68, y: h * 0.84))
            } else {
                p.move(to: CGPoint(x: w * 0.34, y: h * 0.16))
                p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.50))
                p.addLine(to: CGPoint(x: w * 0.34, y: h * 0.84))
            }
            ctx.stroke(p, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.16,
                                                                    lineCap: .round,
                                                                    lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct CloseMark: View {
    var size: CGFloat = 18
    var colour: Color = Stone.inkSoft

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.22, y: h * 0.22))
            p.addLine(to: CGPoint(x: w * 0.78, y: h * 0.78))
            p.move(to: CGPoint(x: w * 0.78, y: h * 0.22))
            p.addLine(to: CGPoint(x: w * 0.22, y: h * 0.78))
            ctx.stroke(p, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.13,
                                                                    lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct TickMark: View {
    var size: CGFloat = 16
    var colour: Color = Stone.moss

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.18, y: h * 0.52))
            p.addLine(to: CGPoint(x: w * 0.42, y: h * 0.76))
            p.addLine(to: CGPoint(x: w * 0.84, y: h * 0.24))
            ctx.stroke(p, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.15,
                                                                    lineCap: .round,
                                                                    lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct AnchorGlyph: View {
    var size: CGFloat = 22
    var colour: Color = Stone.amber

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width, h = rect.height
            ctx.stroke(Path(ellipseIn: CGRect(x: w * 0.40, y: h * 0.08,
                                              width: w * 0.20, height: h * 0.20)),
                       with: .color(colour), style: StrokeStyle(lineWidth: w * 0.08))
            var shank = Path()
            shank.move(to: CGPoint(x: w * 0.50, y: h * 0.26))
            shank.addLine(to: CGPoint(x: w * 0.50, y: h * 0.80))
            ctx.stroke(shank, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.08,
                                                                       lineCap: .round))
            var stock = Path()
            stock.move(to: CGPoint(x: w * 0.26, y: h * 0.36))
            stock.addLine(to: CGPoint(x: w * 0.74, y: h * 0.36))
            ctx.stroke(stock, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.075,
                                                                       lineCap: .round))
            var arms = Path()
            arms.move(to: CGPoint(x: w * 0.16, y: h * 0.58))
            arms.addCurve(to: CGPoint(x: w * 0.84, y: h * 0.58),
                          control1: CGPoint(x: w * 0.22, y: h * 0.94),
                          control2: CGPoint(x: w * 0.78, y: h * 0.94))
            ctx.stroke(arms, with: .color(colour), style: StrokeStyle(lineWidth: w * 0.08,
                                                                       lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}
