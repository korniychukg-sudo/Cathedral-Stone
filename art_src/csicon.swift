import Foundation
import CoreGraphics

func renderCathedralIcon(_ dir: String) {
    let s = Course(1024, 1024)
    let seed = seedOf("cathedral-stone-icon")
    s.fillAll(Tint(r: 0.086, g: 0.094, b: 0.114))

    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Tint(r: 0.216, g: 0.239, b: 0.290)),
                                   cgt(Tint(r: 0.055, g: 0.063, b: 0.078))] as CFArray,
                          locations: [0, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 512, y: 640), startRadius: 20,
                                 endCenter: CGPoint(x: 512, y: 560), endRadius: 800,
                                 options: [.drawsAfterEndLocation])
    }

    s.flipToTopDown()
    s.light = 2.24

    let cx = 512.0
    let baseY = 892.0
    let springY = 560.0
    let halfSpan = 250.0
    let rise = 330.0

    let arch = archBand(cx: cx, springY: springY, halfSpan: halfSpan, rise: rise,
                        pointed: 0.86, thickness: 74)
    stone(s, arch, depth: 0.28, tone: Tint(r: 0.855, g: 0.827, b: 0.749), seed: seed)
    voussoirs(s, cx: cx, springY: springY, halfSpan: halfSpan, rise: rise,
              pointed: 0.86, thickness: 74, count: 18, seed: seed &+ 3)

    for sgn in [-1.0, 1.0] {
        let pier = [pnt(cx + sgn * halfSpan, springY),
                    pnt(cx + sgn * (halfSpan + 74), springY),
                    pnt(cx + sgn * (halfSpan + 74), baseY),
                    pnt(cx + sgn * halfSpan, baseY)]
        stone(s, pier, depth: 0.42, tone: Tint(r: 0.808, g: 0.780, b: 0.706),
              seed: seed &+ UInt64(10 + Int(sgn * 3)))
        let pin = pinnacleShape(cx: cx + sgn * (halfSpan + 37), baseY: springY,
                                width: 108, height: 150)
        stone(s, pin, depth: 0.24, tone: Tint(r: 0.878, g: 0.851, b: 0.780),
              seed: seed &+ UInt64(20 + Int(sgn * 3)), courses: false)
    }

    let inner = archPoints(cx: cx, springY: springY, halfSpan: halfSpan, rise: rise,
                           pointed: 0.86)
    let opening = inner + [pnt(cx + halfSpan, baseY), pnt(cx - halfSpan, baseY)]
    s.poly(opening, Tint(r: 0.055, g: 0.063, b: 0.086))

    lancetWindow(s, cx: cx, top: springY - rise * 0.72, bottom: baseY - 40,
                 halfWidth: 150, lights: 3, seed: seed &+ 41)
    roseWindow(s, cx: cx, cy: springY - rise * 0.42, r: 96, spokes: 12, seed: seed &+ 51)

    var line: [CGPoint] = [pnt(cx, springY - rise - 40)]
    line.append(pnt(cx + halfSpan * 0.60, springY - rise * 0.34))
    line.append(pnt(cx + halfSpan + 20, springY + 60))
    line.append(pnt(cx + halfSpan + 42, baseY))
    penStroke(s, resample(line, count: 44), weight: 12.0,
              colour: Tint(r: 0.812, g: 0.376, b: 0.278, a: 0.92),
              wobble: 0.6, taper: false, seed: seed &+ 61)
    let mirror: [CGPoint] = line.map { pnt(cx - (Double($0.x) - cx), Double($0.y)) }
    penStroke(s, resample(mirror, count: 44), weight: 12.0,
              colour: Tint(r: 0.812, g: 0.376, b: 0.278, a: 0.92),
              wobble: 0.6, taper: false, seed: seed &+ 63)
    s.disc(cx + halfSpan + 42, baseY, 20, Tint(r: 0.812, g: 0.376, b: 0.278))
    s.disc(cx - halfSpan - 42, baseY, 20, Tint(r: 0.812, g: 0.376, b: 0.278))
    _ = mirror

    penStroke(s, [pnt(60, baseY), pnt(964, baseY)], weight: 8.0,
              colour: Tint(r: 0.071, g: 0.078, b: 0.098), wobble: 1.4,
              taper: false, seed: seed &+ 71)

    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Tint(r: 0, g: 0, b: 0, a: 0)),
                                   cgt(Tint(r: 0, g: 0, b: 0, a: 0.44))] as CFArray,
                          locations: [0.56, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 512, y: 512), startRadius: 0,
                                 endCenter: CGPoint(x: 512, y: 512), endRadius: 780,
                                 options: [.drawsAfterEndLocation])
    }

    s.writePNG(dir, "AppIcon-1024")
}
