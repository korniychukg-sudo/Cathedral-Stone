import Foundation
import CoreGraphics

private let bossX = 512.0
private let bossY = 476.0

private let limestone = Tint(r: 0.780, g: 0.729, b: 0.639)

private let shadowCool = Tint(r: 0.098, g: 0.106, b: 0.137)
private let warmLight = Tint(r: 1.000, g: 0.965, b: 0.871)

private func stoneAt(_ v: Double) -> Tint {
    let c = max(0.0, min(1.0, v))
    if c < 0.5 { return shadowCool.mix(limestone, c * 2.0) }
    return limestone.mix(warmLight, (c - 0.5) * 2.0)
}

private let sunward = (x: -0.86, y: -0.51)

private func litFor(_ dx: Double, _ dy: Double) -> Double {
    let len = max(1e-6, (dx * dx + dy * dy).squareRoot())
    return (dx / len) * sunward.x + (dy / len) * sunward.y
}

private func bowed(_ a: CGPoint, _ b: CGPoint, bow: Double, steps: Int) -> [CGPoint] {
    let mx = (Double(a.x) + Double(b.x)) * 0.5
    let my = (Double(a.y) + Double(b.y)) * 0.5
    let dx = Double(b.x) - Double(a.x), dy = Double(b.y) - Double(a.y)
    let len = max(1e-6, (dx * dx + dy * dy).squareRoot())
    let nx = -dy / len, ny = dx / len
    let cx = mx + nx * bow, cy = my + ny * bow
    var pts: [CGPoint] = []
    for i in 0...steps {
        let t = Double(i) / Double(steps)
        let u = 1 - t
        pts.append(pnt(u * u * Double(a.x) + 2 * u * t * cx + t * t * Double(b.x),
                       u * u * Double(a.y) + 2 * u * t * cy + t * t * Double(b.y)))
    }
    return pts
}

private func ribProfile(_ t: Double) -> Double {
    if t < 0.05 { return 0.04 }
    if t < 0.18 { return 0.04 + (t - 0.05) / 0.13 * 0.56 }
    if t < 0.28 { return 0.60 - (t - 0.18) / 0.10 * 0.44 }
    if t < 0.44 { return 0.16 + (t - 0.28) / 0.16 * 0.90 }
    if t < 0.58 { return 1.06 - (t - 0.44) / 0.14 * 0.44 }
    if t < 0.70 { return 0.62 - (t - 0.58) / 0.12 * 0.50 }
    if t < 0.83 { return 0.12 + (t - 0.70) / 0.13 * 0.52 }
    if t < 0.93 { return 0.64 - (t - 0.83) / 0.10 * 0.52 }
    return 0.12 - (t - 0.93) / 0.07 * 0.08
}

private func drawRib(_ s: Course, _ a: CGPoint, _ b: CGPoint,
                     half: Double, bow: Double, seed: UInt64) {
    let spine = bowed(a, b, bow: bow, steps: 34)
    var norms: [(Double, Double)] = []
    for i in 0..<spine.count {
        let p = spine[max(0, i - 1)], q = spine[min(spine.count - 1, i + 1)]
        let dx = Double(q.x - p.x), dy = Double(q.y - p.y)
        let len = max(1e-6, (dx * dx + dy * dy).squareRoot())
        norms.append((-dy / len, dx / len))
    }

    func edge(_ off: Double) -> [CGPoint] {
        (0..<spine.count).map { i in
            pnt(Double(spine[i].x) + norms[i].0 * off,
                Double(spine[i].y) + norms[i].1 * off)
        }
    }

    let shadowSide = litFor(norms[spine.count / 2].0, norms[spine.count / 2].1) < 0 ? 1.0 : -1.0
    let castA = edge(shadowSide * half * 0.6)
    let castB = edge(shadowSide * (half + 21))
    s.poly(castA + castB.reversed(), Tint(r: 0.106, g: 0.090, b: 0.071, a: 0.54))

    let bands = 26
    for k in 0..<bands {
        let t0 = Double(k) / Double(bands)
        let t1 = Double(k + 1) / Double(bands)
        let o0 = -half + half * 2 * t0
        let o1 = -half + half * 2 * t1 + 0.8
        let side = (t0 + t1) * 0.5 < 0.5 ? -1.0 : 1.0
        let mid = spine.count / 2
        let lit = litFor(norms[mid].0 * side, norms[mid].1 * side)
        let v = ribProfile((t0 + t1) * 0.5) * (0.58 + max(0.0, lit) * 0.76) + 0.14
        s.poly(edge(o0) + edge(o1).reversed(), stoneAt(v))
    }

    var rng = Chisel(seed)
    for _ in 0..<26 {
        let i = rng.i(2, spine.count - 3)
        let o = rng.r(-half * 0.9, half * 0.9)
        let p = pnt(Double(spine[i].x) + norms[i].0 * o,
                    Double(spine[i].y) + norms[i].1 * o)
        let q = pnt(Double(spine[i + 1].x) + norms[i + 1].0 * o,
                    Double(spine[i + 1].y) + norms[i + 1].1 * o)
        s.line(p, q, rng.r(1.2, 2.8),
               rng.chance(0.5)
                ? Tint(r: 1.0, g: 0.96, b: 0.88, a: rng.r(0.05, 0.14))
                : Tint(r: 0.20, g: 0.17, b: 0.14, a: rng.r(0.06, 0.16)))
    }
}

private func drawBoss(_ s: Course, seed: UInt64) {
    let r = 118.0
    s.disc(bossX + 14, bossY + 20, r * 1.06, Tint(r: 0.145, g: 0.129, b: 0.106, a: 0.44))
    var rng = Chisel(seed)

    for lobeIndex in 0..<8 {
        let a = Double(lobeIndex) / 8.0 * 2 * .pi + 0.20
        let lx = bossX + cos(a) * r * 0.70
        let ly = bossY + sin(a) * r * 0.70
        var leaf: [CGPoint] = []
        for k in 0...22 {
            let t = Double(k) / 22.0 * 2 * .pi
            let rad = r * (0.46 + 0.16 * cos(t * 3 + a))
            leaf.append(pnt(lx + cos(t) * rad * 0.86, ly + sin(t) * rad * 0.72))
        }
        let lit = litFor(cos(a), sin(a))
        s.poly(leaf.map { pnt(Double($0.x) + 8, Double($0.y) + 11) },
               Tint(r: 0.161, g: 0.141, b: 0.118, a: 0.40))
        s.poly(leaf, stoneAt(0.50 + max(0.0, lit) * 0.44))
        s.ctx.setStrokeColor(cgt(Tint(r: 0.192, g: 0.169, b: 0.137, a: 0.52)))
        s.ctx.setLineWidth(3.0)
        s.ctx.addPath(polyPath(leaf))
        s.ctx.strokePath()
    }

    for k in stride(from: 66.0, through: 16.0, by: -4.0) {
        let t = (66.0 - k) / 50.0
        s.disc(bossX - 9 * (1 - t), bossY - 11 * (1 - t), k, stoneAt(0.36 + t * 0.50))
    }
    s.disc(bossX + 4, bossY + 5, 20, Tint(r: 0.310, g: 0.271, b: 0.220))
    s.disc(bossX - 4, bossY - 5, 12, stoneAt(0.86))
    _ = rng.d()
}

private func webCells(_ s: Course, spokes: [CGPoint]) {
    let n = spokes.count
    for i in 0..<n {
        let a = spokes[i]
        let b = spokes[(i + 1) % n]
        let mx = (Double(a.x) + Double(b.x)) * 0.5 - bossX
        let my = (Double(a.y) + Double(b.y)) * 0.5 - bossY
        let lit = litFor(mx, my)
        let cell = [pnt(bossX, bossY)] + bowed(a, b, bow: -150, steps: 24)
        let steps = 26
        for k in stride(from: steps, through: 1, by: -1) {
            let f = Double(k) / Double(steps)
            let shrunk = cell.map {
                pnt(bossX + (Double($0.x) - bossX) * f, bossY + (Double($0.y) - bossY) * f)
            }
            let v = (0.10 + max(0.0, lit) * 0.30) * (1.0 - f * 0.44) + 0.045
            s.poly(shrunk, stoneAt(v))
        }
    }
}

private func webbing(_ s: Course, spokes: [CGPoint], seed: UInt64) {
    var rng = Chisel(seed)
    let n = spokes.count
    for i in 0..<n {
        let a = spokes[i]
        let b = spokes[(i + 1) % n]
        for j in 1...8 {
            let f = Double(j) / 9.0
            let pa = pnt(bossX + (Double(a.x) - bossX) * f, bossY + (Double(a.y) - bossY) * f)
            let pb = pnt(bossX + (Double(b.x) - bossX) * f, bossY + (Double(b.y) - bossY) * f)
            let course = bowed(pa, pb, bow: -34 * f, steps: 20)
            s.ctx.setStrokeColor(cgt(Tint(r: 0.243, g: 0.216, b: 0.180,
                                          a: 0.30 + rng.r(0.0, 0.14))))
            s.ctx.setLineWidth(rng.r(2.4, 4.0))
            s.ctx.addPath(polyPath(course, close: false))
            s.ctx.strokePath()
            s.ctx.setStrokeColor(cgt(Tint(r: 1.0, g: 0.96, b: 0.88, a: 0.16)))
            s.ctx.setLineWidth(2.0)
            s.ctx.addPath(polyPath(course.map { pnt(Double($0.x) - 3, Double($0.y) - 4) },
                                   close: false))
            s.ctx.strokePath()
        }
    }
}

func renderCathedralIcon(_ dir: String) {
    let s = Course(1024, 1024)
    let seed = seedOf("cathedral-stone-icon-vault")

    s.fillAll(stoneAt(0.34))
    s.flipToTopDown()
    s.light = 2.24

    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Tint(r: 0.847, g: 0.784, b: 0.663)),
                                   cgt(Tint(r: 0.365, g: 0.337, b: 0.298)),
                                   cgt(Tint(r: 0.075, g: 0.078, b: 0.098))] as CFArray,
                          locations: [0, 0.38, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 176, y: 214), startRadius: 0,
                                 endCenter: CGPoint(x: 176, y: 214), endRadius: 1220,
                                 options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }

    var grit = Chisel(seed &+ 17)
    for _ in 0..<2600 {
        let x = grit.d() * 1024, y = grit.d() * 1024
        s.disc(x, y, grit.r(0.8, 2.6),
               grit.chance(0.5)
                ? Tint(r: 1.0, g: 0.97, b: 0.90, a: grit.r(0.02, 0.09))
                : Tint(r: 0.20, g: 0.17, b: 0.14, a: grit.r(0.02, 0.10)))
    }

    let corners = [pnt(-96, -96), pnt(1120, -96), pnt(1120, 1120), pnt(-96, 1120)]
    let mids = [pnt(512, -108), pnt(1132, 476), pnt(512, 1112), pnt(-108, 476)]
    var spokes: [CGPoint] = []
    for k in 0..<4 {
        spokes.append(mids[k])
        spokes.append(corners[(k + 1) % 4])
    }

    webCells(s, spokes: spokes)
    webbing(s, spokes: spokes, seed: seed &+ 41)

    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Tint(r: 0.99, g: 0.95, b: 0.86, a: 0.26)),
                                   cgt(Tint(r: 0.99, g: 0.95, b: 0.86, a: 0.0))] as CFArray,
                          locations: [0, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 130, y: 190), startRadius: 0,
                                 endCenter: CGPoint(x: 130, y: 190), endRadius: 700,
                                 options: [])
    }

    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Tint(r: 0.98, g: 0.93, b: 0.82, a: 0.26)),
                                   cgt(Tint(r: 0.98, g: 0.93, b: 0.82, a: 0.0))] as CFArray,
                          locations: [0, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 96, y: 132), startRadius: 0,
                                 endCenter: CGPoint(x: 96, y: 132), endRadius: 660,
                                 options: [])
    }

    for k in 0..<4 {
        let a = pnt(bossX + (Double(mids[k].x) - bossX) * 0.52,
                    bossY + (Double(mids[k].y) - bossY) * 0.52)
        let b = pnt(bossX + (Double(mids[(k + 1) % 4].x) - bossX) * 0.52,
                    bossY + (Double(mids[(k + 1) % 4].y) - bossY) * 0.52)
        drawRib(s, a, b, half: 17, bow: 0, seed: seed &+ UInt64(500 + k))
    }

    for k in 0..<4 {
        drawRib(s, corners[k], pnt(bossX, bossY), half: 32, bow: 0,
                seed: seed &+ UInt64(700 + k))
    }
    for k in 0..<4 {
        drawRib(s, mids[k], pnt(bossX, bossY), half: 26, bow: 0,
                seed: seed &+ UInt64(800 + k))
    }

    drawBoss(s, seed: seed &+ 909)

    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Tint(r: 0.055, g: 0.047, b: 0.039, a: 0.0)),
                                   cgt(Tint(r: 0.043, g: 0.035, b: 0.028, a: 0.80))] as CFArray,
                          locations: [0.26, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 396, y: 372), startRadius: 0,
                                 endCenter: CGPoint(x: 396, y: 372), endRadius: 820,
                                 options: [.drawsAfterEndLocation])
    }

    s.writePNG(dir, "AppIcon-1024")
}
