import Foundation
import CoreGraphics

func shrinkPoly(_ pts: [CGPoint], by t: Double) -> [CGPoint] {
    guard pts.count > 2 else { return [] }
    var cx = 0.0, cy = 0.0
    for p in pts { cx += Double(p.x); cy += Double(p.y) }
    cx /= Double(pts.count); cy /= Double(pts.count)
    return pts.map { pnt(cx + (Double($0.x) - cx) * (1 - t), cy + (Double($0.y) - cy) * (1 - t)) }
}

func stone(_ s: Course, _ pts: [CGPoint], depth: Double, tone: Tint = Quarry.limestone,
           seed: UInt64, courses: Bool = true) {
    guard pts.count > 2 else { return }
    let t = min(0.98, max(0.02, depth))
    let body: Tint = t < 0.5 ? tone.lt((0.5 - t) * 0.86) : tone.dk((t - 0.5) * 1.10)
    s.poly(pts, body)
    let path = polyPath(pts)
    let box = path.boundingBox
    if box.width > 3 && box.height > 3 {
        s.clip(path) {
            let x0 = Double(box.minX), w = Double(box.width)
            let y0 = Double(box.minY), h = Double(box.height)
            s.rect(x0, y0, w * 0.14, h, tone.dk(0.14 + t * 0.22))
            s.rect(x0 + w * 0.22, y0, w * 0.18, h, tone.lt(0.30 - t * 0.22))
            s.rect(x0 + w * 0.74, y0, w * 0.26, h, tone.dk(0.12 + t * 0.30))
            if courses {
                var rng = Chisel(seed &+ 7)
                var y = y0 + rng.r(h * 0.10, h * 0.22)
                while y < y0 + h {
                    penStroke(s, [pnt(x0 - 2, y), pnt(x0 + w + 2, y + rng.signed() * 1.4)],
                              weight: 1.2, colour: Quarry.ink.al(rng.r(0.14, 0.30)),
                              wobble: 0.5, taper: false, seed: seed &+ u64(Int(y)))
                    y += max(7.0, h * rng.r(0.10, 0.18))
                }
                var rr = Chisel(seed &+ 31)
                for _ in 0..<Int(w * h / 900) {
                    let px = x0 + rr.d() * w
                    let py = y0 + rr.d() * h
                    s.disc(px, py, rr.r(0.8, 2.4), Quarry.ink.al(rr.r(0.05, 0.16)))
                }
            }
        }
    }
    s.ctx.saveGState()
    s.ctx.setStrokeColor(cgt(Quarry.ink.al(0.82)))
    s.ctx.setLineWidth(2.0)
    s.ctx.setLineJoin(.round)
    s.ctx.addPath(path)
    s.ctx.strokePath()
    s.ctx.restoreGState()
}

func archPoints(cx: Double, springY: Double, halfSpan: Double, rise: Double,
                pointed: Double, steps: Int = 30) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0...steps {
        let t = Double(i) / Double(steps)
        let x = cx - halfSpan + 2 * halfSpan * t
        let u = (x - cx) / halfSpan
        let semi = (1 - u * u).squareRoot()
        let point = 1 - abs(u)
        let shape = semi * (1 - pointed) + pow(point, 0.72) * pointed
        out.append(pnt(x, springY - rise * shape))
    }
    return out
}

func archBand(cx: Double, springY: Double, halfSpan: Double, rise: Double,
              pointed: Double, thickness: Double) -> [CGPoint] {
    let outer = archPoints(cx: cx, springY: springY, halfSpan: halfSpan + thickness,
                           rise: rise + thickness, pointed: pointed)
    let inner = archPoints(cx: cx, springY: springY, halfSpan: halfSpan,
                           rise: rise, pointed: pointed)
    return outer + inner.reversed()
}

func voussoirs(_ s: Course, cx: Double, springY: Double, halfSpan: Double, rise: Double,
               pointed: Double, thickness: Double, count: Int, seed: UInt64) {
    for i in 0...count {
        let t = Double(i) / Double(count)
        let x = cx - halfSpan + 2 * halfSpan * t
        let u = (x - cx) / halfSpan
        let semi = (1 - u * u).squareRoot()
        let point = 1 - abs(u)
        let shape = semi * (1 - pointed) + pow(point, 0.72) * pointed
        let yi = springY - rise * shape
        let xo = cx + u * (halfSpan + thickness)
        let yo = springY - (rise + thickness) * shape
        penStroke(s, [pnt(x, yi), pnt(xo, yo)], weight: 1.4,
                  colour: Quarry.ink.al(0.42), wobble: 0.3, taper: false,
                  seed: seed &+ UInt64(i))
    }
}

func lancetWindow(_ s: Course, cx: Double, top: Double, bottom: Double, halfWidth: Double,
                  lights: Int, seed: UInt64) {
    let rise = halfWidth * 1.5
    let springY = top + rise
    let outline = archPoints(cx: cx, springY: springY, halfSpan: halfWidth,
                             rise: rise, pointed: 0.85)
        + [pnt(cx + halfWidth, bottom), pnt(cx - halfWidth, bottom)]
    s.poly(outline, Quarry.paperNight.al(0.86))
    var rng = Chisel(seed)
    let cols = max(1, lights)
    for c in 0..<cols {
        let w = 2 * halfWidth / Double(cols)
        let x0 = cx - halfWidth + Double(c) * w
        var y = top + rise * 0.30
        while y < bottom {
            let hgt = rng.r(14, 30)
            let tone: Tint = rng.chance(0.34) ? Quarry.glassRed
                : (rng.chance(0.5) ? Quarry.glassBlue : Quarry.glassGold)
            let cell = [pnt(x0 + 3, y), pnt(x0 + w - 3, y),
                        pnt(x0 + w - 3, min(bottom - 2, y + hgt)),
                        pnt(x0 + 3, min(bottom - 2, y + hgt))]
            s.poly(cell, tone.al(rng.r(0.62, 0.95)))
            y += hgt + 3
        }
        if c > 0 {
            penStroke(s, [pnt(x0, top + rise * 0.24), pnt(x0, bottom)],
                      weight: 3.2, colour: Quarry.ink, wobble: 0.4, taper: false,
                      seed: seed &+ UInt64(c))
        }
    }
    penContour(s, outline, weight: 3.4, colour: Quarry.ink, seed: seed &+ 41)
}

func roseWindow(_ s: Course, cx: Double, cy: Double, r: Double, spokes: Int, seed: UInt64) {
    let ring = ellipsePoints(cx: cx, cy: cy, rx: r, ry: r, steps: 60)
    s.poly(ring, Quarry.paperNight.al(0.88))
    var rng = Chisel(seed)
    for k in 0..<spokes {
        let a0 = Double(k) / Double(spokes) * 6.283185
        let a1 = Double(k + 1) / Double(spokes) * 6.283185
        let tone: Tint = k % 3 == 0 ? Quarry.glassRed : (k % 3 == 1 ? Quarry.glassBlue : Quarry.glassGold)
        let petal = [pnt(cx + cos(a0) * r * 0.34, cy + sin(a0) * r * 0.34),
                     pnt(cx + cos(a0) * r * 0.92, cy + sin(a0) * r * 0.92),
                     pnt(cx + cos((a0 + a1) / 2) * r * 0.98, cy + sin((a0 + a1) / 2) * r * 0.98),
                     pnt(cx + cos(a1) * r * 0.92, cy + sin(a1) * r * 0.92),
                     pnt(cx + cos(a1) * r * 0.34, cy + sin(a1) * r * 0.34)]
        s.poly(petal, tone.al(rng.r(0.62, 0.92)))
        penContour(s, petal, weight: 2.0, colour: Quarry.ink, seed: seed &+ UInt64(k))
    }
    let hub = ellipsePoints(cx: cx, cy: cy, rx: r * 0.24, ry: r * 0.24, steps: 26)
    s.poly(hub, Quarry.glassGold.al(0.90))
    penContour(s, hub, weight: 2.4, colour: Quarry.ink, seed: seed &+ 91)
    s.ring(cx, cy, r, 4.0, Quarry.ink)
    s.ring(cx, cy, r * 1.10, 2.2, Quarry.ink.al(0.6))
}

func pinnacleShape(cx: Double, baseY: Double, width: Double, height: Double) -> [CGPoint] {
    [pnt(cx - width / 2, baseY), pnt(cx + width / 2, baseY),
     pnt(cx + width * 0.30, baseY - height * 0.42),
     pnt(cx, baseY - height),
     pnt(cx - width * 0.30, baseY - height * 0.42)]
}

func flyingButtress(_ s: Course, fromX: Double, fromY: Double, toX: Double, toY: Double,
                    depth: Double, seed: UInt64) {
    let dx = toX - fromX
    let sag = abs(dx) * 0.30
    var upper: [CGPoint] = []
    var lower: [CGPoint] = []
    for i in 0...22 {
        let t = Double(i) / 22.0
        let x = fromX + dx * t
        let y = fromY + (toY - fromY) * t - sin(t * .pi) * sag
        upper.append(pnt(x, y))
        lower.append(pnt(x, y + depth))
    }
    stone(s, upper + lower.reversed(), depth: 0.42, seed: seed, courses: true)
    for i in stride(from: 1, to: 22, by: 3) {
        penStroke(s, [upper[i], lower[i]], weight: 1.3,
                  colour: Quarry.ink.al(0.36), wobble: 0.3, taper: false,
                  seed: seed &+ UInt64(i))
    }
}

func naveSection(_ s: Course, cx: Double, groundY: Double, unit: Double,
                 pointed: Double, flyers: Int, pinnacle: Bool, seed: UInt64) {
    let halfNave = unit * 1.30
    let pierW = unit * 0.34
    let pierTop = groundY - unit * 2.30
    let vaultSpring = groundY - unit * 3.90
    let vaultCrown = vaultSpring - unit * 1.30

    let aisleOuter = cx + unit * 3.30
    let buttW = unit * 0.62
    let buttTop = groundY - unit * 2.90

    for sgn in [-1.0, 1.0] {
        let bx = cx + sgn * (aisleOuter - cx)
        let butt = [pnt(bx - sgn * buttW, groundY), pnt(bx + sgn * buttW * 0.30, groundY),
                    pnt(bx + sgn * buttW * 0.18, buttTop), pnt(bx - sgn * buttW * 0.86, buttTop)]
        stone(s, butt, depth: 0.44, seed: seed &+ UInt64(3 + Int(sgn * 2)))
        if pinnacle {
            let pin = pinnacleShape(cx: bx - sgn * buttW * 0.34, baseY: buttTop,
                                    width: buttW * 0.70, height: unit * 1.10)
            stone(s, pin, depth: 0.30, seed: seed &+ UInt64(9 + Int(sgn * 2)), courses: false)
        }
        for k in 0..<max(0, flyers) {
            let fy = vaultSpring + Double(k) * unit * 0.72
            flyingButtress(s, fromX: bx - sgn * buttW * 0.60, fromY: buttTop + unit * 0.20 + Double(k) * unit * 0.60,
                           toX: cx + sgn * halfNave, toY: fy,
                           depth: unit * 0.16, seed: seed &+ UInt64(20 + k * 3 + Int(sgn)))
        }
        let aisleWall = [pnt(bx - sgn * buttW * 0.86, groundY),
                         pnt(cx + sgn * (halfNave + pierW), groundY),
                         pnt(cx + sgn * (halfNave + pierW), groundY - unit * 1.90),
                         pnt(bx - sgn * buttW * 0.86, groundY - unit * 2.10)]
        stone(s, aisleWall, depth: 0.52, seed: seed &+ UInt64(40 + Int(sgn * 3)))
        lancetWindow(s, cx: (bx + cx + sgn * halfNave) / 2, top: groundY - unit * 1.70,
                     bottom: groundY - unit * 0.40, halfWidth: unit * 0.26,
                     lights: 2, seed: seed &+ UInt64(60 + Int(sgn * 5)))

        let pier = [pnt(cx + sgn * halfNave, groundY), pnt(cx + sgn * (halfNave + pierW), groundY),
                    pnt(cx + sgn * (halfNave + pierW), pierTop), pnt(cx + sgn * halfNave, pierTop)]
        stone(s, pier, depth: 0.32, seed: seed &+ UInt64(80 + Int(sgn * 3)))

        let clerestory = [pnt(cx + sgn * halfNave, pierTop),
                          pnt(cx + sgn * (halfNave + pierW), pierTop),
                          pnt(cx + sgn * (halfNave + pierW), vaultSpring),
                          pnt(cx + sgn * halfNave, vaultSpring)]
        stone(s, clerestory, depth: 0.36, seed: seed &+ UInt64(100 + Int(sgn * 3)))
        lancetWindow(s, cx: cx + sgn * (halfNave + pierW * 0.5),
                     top: vaultSpring + unit * 0.10,
                     bottom: pierTop - unit * 0.16, halfWidth: pierW * 0.30,
                     lights: 1, seed: seed &+ UInt64(120 + Int(sgn * 5)))
    }

    let arcade = archBand(cx: cx, springY: pierTop, halfSpan: halfNave,
                          rise: unit * 1.10, pointed: pointed, thickness: unit * 0.22)
    stone(s, arcade, depth: 0.30, seed: seed &+ 141)
    voussoirs(s, cx: cx, springY: pierTop, halfSpan: halfNave, rise: unit * 1.10,
              pointed: pointed, thickness: unit * 0.22, count: 16, seed: seed &+ 143)

    let vault = archBand(cx: cx, springY: vaultSpring, halfSpan: halfNave,
                         rise: vaultSpring - vaultCrown, pointed: pointed,
                         thickness: unit * 0.20)
    stone(s, vault, depth: 0.26, seed: seed &+ 151)
    voussoirs(s, cx: cx, springY: vaultSpring, halfSpan: halfNave,
              rise: vaultSpring - vaultCrown, pointed: pointed,
              thickness: unit * 0.20, count: 18, seed: seed &+ 153)

    let roof = [pnt(cx - halfNave - unit * 0.16, vaultCrown - unit * 0.04),
                pnt(cx + halfNave + unit * 0.16, vaultCrown - unit * 0.04),
                pnt(cx, vaultCrown - unit * 0.78)]
    stone(s, roof, depth: 0.34, tone: Quarry.lead.lt(0.18), seed: seed &+ 161, courses: false)
    var rng = Chisel(seed &+ 171)
    for k in 0..<16 {
        let t = Double(k) / 16.0
        penStroke(s, [pnt(cx - halfNave - unit * 0.14 + t * (halfNave * 2 + unit * 0.28),
                          vaultCrown - unit * 0.04),
                      pnt(cx, vaultCrown - unit * 0.76)],
                  weight: 1.1, colour: Quarry.ink.al(rng.r(0.14, 0.30)),
                  wobble: 0.3, taper: false, seed: seed &+ UInt64(180 + k))
    }
}

func thrustLine(_ s: Course, cx: Double, groundY: Double, unit: Double,
                escape: Double, seed: UInt64) {
    let halfNave = unit * 1.30
    let vaultSpring = groundY - unit * 3.90
    let vaultCrown = vaultSpring - unit * 1.30
    let aisleOuter = cx + unit * 3.30
    let buttW = unit * 0.62

    for sgn in [-1.0, 1.0] {
        var pts: [CGPoint] = [pnt(cx, vaultCrown + unit * 0.10)]
        pts.append(pnt(cx + sgn * halfNave * 0.62, vaultCrown + unit * 0.42))
        pts.append(pnt(cx + sgn * halfNave, vaultSpring))
        pts.append(pnt(cx + sgn * (halfNave + unit * 1.10), vaultSpring + unit * 0.60))
        pts.append(pnt(cx + sgn * (aisleOuter - cx) - sgn * buttW * 0.50,
                       groundY - unit * 2.60))
        let footX = cx + sgn * (aisleOuter - cx) - sgn * buttW * (0.50 - escape)
        pts.append(pnt(footX, groundY))
        let smooth = resample(pts, count: 60)
        penStroke(s, smooth, weight: 4.0,
                  colour: escape > 0.5 ? Quarry.oxblood : Quarry.moss.dk(0.10),
                  wobble: 0.5, taper: false, seed: seed &+ UInt64(Int(sgn * 7) + 11))
        s.disc(footX, groundY, unit * 0.09, escape > 0.5 ? Quarry.oxblood : Quarry.moss.dk(0.10))
    }
}
