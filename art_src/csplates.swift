import Foundation
import CoreGraphics

struct CathedralPlate {
    let slug: String
    let name: String
    let place: String
    let dates: String
    let pointed: Double
    let flyers: Int
    let pinnacle: Bool
    let heightNote: String
}

let cathedralPlates: [CathedralPlate] = cathedralsA + cathedralsB

let cathedralsA: [CathedralPlate] = [
    CathedralPlate(slug: "durham", name: "Durham", place: "England", dates: "1093–1133",
                   pointed: 0.12, flyers: 1, pinnacle: false,
                   heightNote: "Vault 22 m — the first ribbed high vault in Europe"),
    CathedralPlate(slug: "notredame", name: "Notre-Dame de Paris", place: "France",
                   dates: "1163–1345", pointed: 0.62, flyers: 1, pinnacle: false,
                   heightNote: "Vault 33 m — the first true flying buttresses"),
    CathedralPlate(slug: "chartres", name: "Chartres", place: "France", dates: "1194–1220",
                   pointed: 0.78, flyers: 2, pinnacle: true,
                   heightNote: "Vault 37 m — the pattern every later cathedral copied"),
    CathedralPlate(slug: "reims", name: "Reims", place: "France", dates: "1211–1275",
                   pointed: 0.80, flyers: 2, pinnacle: true,
                   heightNote: "Vault 38 m — bar tracery invented here"),
]

let cathedralsB: [CathedralPlate] = [
    CathedralPlate(slug: "amiens", name: "Amiens", place: "France", dates: "1220–1270",
                   pointed: 0.86, flyers: 2, pinnacle: true,
                   heightNote: "Vault 42 m — the tallest completed nave in France"),
    CathedralPlate(slug: "beauvais", name: "Beauvais", place: "France", dates: "1225–1272",
                   pointed: 0.90, flyers: 2, pinnacle: true,
                   heightNote: "Choir 48 m — and it fell down in 1284"),
    CathedralPlate(slug: "salisbury", name: "Salisbury", place: "England", dates: "1220–1258",
                   pointed: 0.70, flyers: 1, pinnacle: true,
                   heightNote: "Vault 26 m — built low and wide, and still standing"),
    CathedralPlate(slug: "cologne", name: "Cologne", place: "Germany", dates: "1248–1880",
                   pointed: 0.88, flyers: 2, pinnacle: true,
                   heightNote: "Vault 43 m — begun in the Middle Ages, finished by the Victorians"),
]

func drawCathedralPlate(_ c: CathedralPlate, dir: String) {
    let course = Course(2400, 1800)
    let seed = seedOf("cath-" + c.slug)
    layPaper(course, seed: seed, tone: Quarry.paperWarm)
    course.flipToTopDown()
    course.light = 2.28

    let W = course.w, H = course.h
    plateBorder(course, inset: W * 0.036, seed: seed &+ 3)

    let groundY = H * 0.735
    let unit = min(W * 0.088, H * 0.118)

    let skyBand = [pnt(W * 0.06, H * 0.11), pnt(W * 0.94, H * 0.11),
                   pnt(W * 0.94, groundY), pnt(W * 0.06, groundY)]
    wash(course, skyBand, Quarry.sky, strength: 0.16, bleed: 8, seed: seed &+ 5)

    naveSection(course, cx: W * 0.50, groundY: groundY, unit: unit,
                pointed: c.pointed, flyers: c.flyers, pinnacle: c.pinnacle,
                seed: seed &+ 101)

    penStroke(course, [pnt(W * 0.06, groundY), pnt(W * 0.94, groundY)],
              weight: 3.4, colour: Quarry.ink, wobble: 0.8, taper: false, seed: seed &+ 7)
    hatch(course, polyPath([pnt(W * 0.06, groundY), pnt(W * 0.94, groundY),
                            pnt(W * 0.94, groundY + H * 0.030), pnt(W * 0.06, groundY + H * 0.030)]),
          angle: 0.6, spacing: 7.0, weight: 1.1, colour: Quarry.inkSoft.al(0.44),
          coverage: 0.8, seed: seed &+ 11)

    penStroke(course, [pnt(W * 0.22, H * 0.795), pnt(W * 0.78, H * 0.795)],
              weight: 2.4, colour: Quarry.ink, wobble: 0.6, taper: true, seed: seed &+ 13)
    label(course, c.name.uppercased(), at: W / 2, H * 0.848,
          size: 40, colour: Quarry.ink, face: "Georgia-Bold", align: .centre, tracking: 5.0)
    label(course, (c.place + " · " + c.dates).uppercased(), at: W / 2, H * 0.890,
          size: 21, colour: Quarry.inkSoft, face: "Georgia", align: .centre, tracking: 3.4)
    label(course, c.heightNote, at: W / 2, H * 0.930,
          size: 24, colour: Quarry.inkPale, face: "Georgia", align: .centre)

    course.write(dir, "cath_" + c.slug, quality: 0.95)
}

func elemRoundPier(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let shaft = [pnt(cx - u * 0.34, cy - u * 1.10), pnt(cx + u * 0.34, cy - u * 1.10),
                 pnt(cx + u * 0.34, cy + u * 1.10), pnt(cx - u * 0.34, cy + u * 1.10)]
    stone(s, shaft, depth: 0.34, seed: seed)
    let cap = [pnt(cx - u * 0.56, cy - u * 1.10), pnt(cx + u * 0.56, cy - u * 1.10),
               pnt(cx + u * 0.44, cy - u * 1.34), pnt(cx - u * 0.44, cy - u * 1.34)]
    stone(s, cap, depth: 0.26, seed: seed &+ 3, courses: false)
    let base = [pnt(cx - u * 0.58, cy + u * 1.10), pnt(cx + u * 0.58, cy + u * 1.10),
                pnt(cx + u * 0.50, cy + u * 1.34), pnt(cx - u * 0.50, cy + u * 1.34)]
    stone(s, base, depth: 0.48, seed: seed &+ 5, courses: false)
}

func elemCompoundPier(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let core = [pnt(cx - u * 0.30, cy - u * 1.10), pnt(cx + u * 0.30, cy - u * 1.10),
                pnt(cx + u * 0.30, cy + u * 1.10), pnt(cx - u * 0.30, cy + u * 1.10)]
    stone(s, core, depth: 0.42, seed: seed)
    for sgn in [-1.0, 1.0] {
        let shaft = [pnt(cx + sgn * u * 0.30, cy - u * 1.10),
                     pnt(cx + sgn * u * 0.52, cy - u * 1.10),
                     pnt(cx + sgn * u * 0.52, cy + u * 1.10),
                     pnt(cx + sgn * u * 0.30, cy + u * 1.10)]
        stone(s, shaft, depth: 0.24, seed: seed &+ UInt64(10 + Int(sgn * 3)))
    }
    let cap = [pnt(cx - u * 0.70, cy - u * 1.10), pnt(cx + u * 0.70, cy - u * 1.10),
               pnt(cx + u * 0.56, cy - u * 1.38), pnt(cx - u * 0.56, cy - u * 1.38)]
    stone(s, cap, depth: 0.26, seed: seed &+ 21, courses: false)
}

func elemClusteredPier(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    for k in 0..<5 {
        let off = (Double(k) - 2.0) * u * 0.22
        let w = k == 2 ? u * 0.16 : u * 0.11
        let shaft = [pnt(cx + off - w, cy - u * 1.10), pnt(cx + off + w, cy - u * 1.10),
                     pnt(cx + off + w, cy + u * 1.10), pnt(cx + off - w, cy + u * 1.10)]
        stone(s, shaft, depth: 0.20 + Double(k) * 0.13, seed: seed &+ UInt64(k))
    }
    let cap = [pnt(cx - u * 0.72, cy - u * 1.10), pnt(cx + u * 0.72, cy - u * 1.10),
               pnt(cx + u * 0.58, cy - u * 1.40), pnt(cx - u * 0.58, cy - u * 1.40)]
    stone(s, cap, depth: 0.26, seed: seed &+ 31, courses: false)
}

func archElement(_ pointed: Double) -> (Course, Double, Double, Double, UInt64) -> Void {
    return { s, cx, cy, u, seed in
        let springY = cy + u * 0.70
        let band = archBand(cx: cx, springY: springY, halfSpan: u * 1.00,
                            rise: u * 1.10, pointed: pointed, thickness: u * 0.22)
        stone(s, band, depth: 0.30, seed: seed)
        voussoirs(s, cx: cx, springY: springY, halfSpan: u * 1.00, rise: u * 1.10,
                  pointed: pointed, thickness: u * 0.22, count: 14, seed: seed &+ 3)
        for sgn in [-1.0, 1.0] {
            let pier = [pnt(cx + sgn * u * 1.00, springY),
                        pnt(cx + sgn * u * 1.22, springY),
                        pnt(cx + sgn * u * 1.22, springY + u * 0.90),
                        pnt(cx + sgn * u * 1.00, springY + u * 0.90)]
            stone(s, pier, depth: 0.42, seed: seed &+ UInt64(10 + Int(sgn * 3)))
        }
        let crown = pnt(cx, springY - u * 1.10)
        s.ctx.saveGState()
        s.ctx.setLineDash(phase: 0, lengths: [8, 7])
        s.ctx.setStrokeColor(cgt(Quarry.oxblood.al(0.7)))
        s.ctx.setLineWidth(2.0)
        s.ctx.beginPath()
        s.ctx.move(to: pnt(cx - u * 1.10, springY))
        s.ctx.addLine(to: pnt(cx + u * 1.10, springY))
        s.ctx.move(to: crown)
        s.ctx.addLine(to: pnt(cx, springY))
        s.ctx.strokePath()
        s.ctx.restoreGState()
    }
}

func elemBarrelVault(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    for k in 0..<7 {
        let off = Double(k) * u * 0.24 - u * 0.72
        let band = archBand(cx: cx + off * 0.30, springY: cy + u * 0.80 + off * 0.16,
                            halfSpan: u * 0.96, rise: u * 0.96, pointed: 0.0,
                            thickness: u * 0.13)
        stone(s, band, depth: 0.26 + Double(k) * 0.06, seed: seed &+ UInt64(k), courses: false)
    }
}

func elemGroinVault(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let box = [pnt(cx - u * 1.10, cy - u * 0.70), pnt(cx + u * 1.10, cy - u * 0.70),
               pnt(cx + u * 1.10, cy + u * 0.90), pnt(cx - u * 1.10, cy + u * 0.90)]
    stone(s, box, depth: 0.34, seed: seed)
    for sgn in [-1.0, 1.0] {
        penStroke(s, [pnt(cx - u * 1.10, cy - u * 0.70 + (sgn > 0 ? 0 : u * 1.60)),
                      pnt(cx, cy + u * 0.10),
                      pnt(cx + u * 1.10, cy - u * 0.70 + (sgn > 0 ? u * 1.60 : 0))],
                  weight: 4.0, colour: Quarry.ink.al(0.72), wobble: 0.5,
                  taper: false, seed: seed &+ UInt64(10 + Int(sgn * 3)))
    }
}

func elemRibVault(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let box = [pnt(cx - u * 1.10, cy - u * 0.70), pnt(cx + u * 1.10, cy - u * 0.70),
               pnt(cx + u * 1.10, cy + u * 0.90), pnt(cx - u * 1.10, cy + u * 0.90)]
    stone(s, box, depth: 0.30, seed: seed)
    let corners = [pnt(cx - u * 1.10, cy - u * 0.70), pnt(cx + u * 1.10, cy - u * 0.70),
                   pnt(cx + u * 1.10, cy + u * 0.90), pnt(cx - u * 1.10, cy + u * 0.90)]
    for (k, c) in corners.enumerated() {
        penStroke(s, [c, pnt(cx, cy + u * 0.10)], weight: 5.0,
                  colour: Quarry.limeDark, wobble: 0.5, taper: false,
                  seed: seed &+ UInt64(10 + k))
    }
    penStroke(s, [pnt(cx - u * 1.10, cy + u * 0.10), pnt(cx + u * 1.10, cy + u * 0.10)],
              weight: 4.0, colour: Quarry.limeDark, wobble: 0.5, taper: false, seed: seed &+ 31)
    penStroke(s, [pnt(cx, cy - u * 0.70), pnt(cx, cy + u * 0.90)],
              weight: 4.0, colour: Quarry.limeDark, wobble: 0.5, taper: false, seed: seed &+ 33)
    s.disc(cx, cy + u * 0.10, u * 0.13, Quarry.limestone.dk(0.10))
    s.ring(cx, cy + u * 0.10, u * 0.13, 3.0, Quarry.ink)
}

func elemFanVault(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let box = [pnt(cx - u * 1.10, cy - u * 0.70), pnt(cx + u * 1.10, cy - u * 0.70),
               pnt(cx + u * 1.10, cy + u * 0.90), pnt(cx - u * 1.10, cy + u * 0.90)]
    stone(s, box, depth: 0.28, seed: seed)
    for corner in [(-1.0, -1.0), (1.0, -1.0), (-1.0, 1.0), (1.0, 1.0)] {
        let ox = cx + corner.0 * u * 1.10
        let oy = cy + (corner.1 < 0 ? -u * 0.70 : u * 0.90)
        for k in 0..<7 {
            let a = atan2(-corner.1, -corner.0) - 0.72 + Double(k) * 0.24
            penStroke(s, [pnt(ox, oy), pnt(ox + cos(a) * u * 0.92, oy + sin(a) * u * 0.92)],
                      weight: 2.6, colour: Quarry.limeDark.al(0.85), wobble: 0.4,
                      taper: true, seed: seed &+ UInt64(k))
            let ring = ellipsePoints(cx: ox, cy: oy, rx: u * 0.92, ry: u * 0.92, steps: 40)
            _ = ring
        }
        s.ctx.saveGState()
        s.ctx.setStrokeColor(cgt(Quarry.limeDark.al(0.60)))
        s.ctx.setLineWidth(2.2)
        s.ctx.strokeEllipse(in: CGRect(x: ox - u * 0.92, y: oy - u * 0.92,
                                       width: u * 1.84, height: u * 1.84))
        s.ctx.restoreGState()
    }
}

func elemThickWall(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let wall = [pnt(cx - u * 0.46, cy - u * 1.20), pnt(cx + u * 0.46, cy - u * 1.20),
                pnt(cx + u * 0.46, cy + u * 1.20), pnt(cx - u * 0.46, cy + u * 1.20)]
    stone(s, wall, depth: 0.44, seed: seed)
    arrowThrust(s, fromX: cx - u * 1.40, y: cy - u * 0.70, toX: cx - u * 0.50, seed: seed &+ 11)
}

func elemClaspingButtress(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let wall = [pnt(cx - u * 0.34, cy - u * 1.20), pnt(cx + u * 0.34, cy - u * 1.20),
                pnt(cx + u * 0.34, cy + u * 1.20), pnt(cx - u * 0.34, cy + u * 1.20)]
    stone(s, wall, depth: 0.40, seed: seed)
    let butt = [pnt(cx + u * 0.34, cy - u * 0.40), pnt(cx + u * 0.96, cy + u * 0.10),
                pnt(cx + u * 0.96, cy + u * 1.20), pnt(cx + u * 0.34, cy + u * 1.20)]
    stone(s, butt, depth: 0.50, seed: seed &+ 5)
    arrowThrust(s, fromX: cx - u * 1.40, y: cy - u * 0.70, toX: cx - u * 0.40, seed: seed &+ 11)
}

func elemFlyingButtress(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let wall = [pnt(cx - u * 0.90, cy - u * 1.30), pnt(cx - u * 0.56, cy - u * 1.30),
                pnt(cx - u * 0.56, cy + u * 1.20), pnt(cx - u * 0.90, cy + u * 1.20)]
    stone(s, wall, depth: 0.36, seed: seed)
    let pier = [pnt(cx + u * 0.60, cy - u * 0.40), pnt(cx + u * 1.04, cy - u * 0.40),
                pnt(cx + u * 1.04, cy + u * 1.20), pnt(cx + u * 0.60, cy + u * 1.20)]
    stone(s, pier, depth: 0.46, seed: seed &+ 5)
    flyingButtress(s, fromX: cx + u * 0.70, fromY: cy - u * 0.44,
                   toX: cx - u * 0.54, toY: cy - u * 1.02,
                   depth: u * 0.16, seed: seed &+ 11)
    let pin = pinnacleShape(cx: cx + u * 0.82, baseY: cy - u * 0.40,
                            width: u * 0.40, height: u * 0.80)
    stone(s, pin, depth: 0.28, seed: seed &+ 21, courses: false)
    arrowThrust(s, fromX: cx - u * 1.50, y: cy - u * 1.00, toX: cx - u * 0.94, seed: seed &+ 31)
}

func arrowThrust(_ s: Course, fromX: Double, y: Double, toX: Double, seed: UInt64) {
    penStroke(s, [pnt(fromX, y), pnt(toX, y)], weight: 4.0,
              colour: Quarry.oxblood, wobble: 0.3, taper: false, seed: seed)
    for k in 0..<2 {
        let a = (k == 0 ? 0.42 : -0.42) + .pi
        penStroke(s, [pnt(toX, y), pnt(toX + cos(a) * 26, y + sin(a) * 26)],
                  weight: 3.4, colour: Quarry.oxblood, wobble: 0.2, taper: true,
                  seed: seed &+ UInt64(k))
    }
}

func elemPinnacle(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let base = [pnt(cx - u * 0.46, cy + u * 1.20), pnt(cx + u * 0.46, cy + u * 1.20),
                pnt(cx + u * 0.46, cy + u * 0.40), pnt(cx - u * 0.46, cy + u * 0.40)]
    stone(s, base, depth: 0.44, seed: seed)
    let spire = pinnacleShape(cx: cx, baseY: cy + u * 0.40, width: u * 0.72, height: u * 1.50)
    stone(s, spire, depth: 0.28, seed: seed &+ 5, courses: false)
    for sgn in [-1.0, 1.0] {
        for k in 0..<3 {
            let t = Double(k) * 0.22 + 0.16
            let px = cx + sgn * u * 0.30 * (1 - t)
            let py = cy + u * 0.40 - u * 1.50 * t
            let crocket = [pnt(px, py), pnt(px + sgn * u * 0.22, py - u * 0.06),
                           pnt(px + sgn * u * 0.14, py - u * 0.20)]
            stone(s, crocket, depth: 0.24, seed: seed &+ UInt64(20 + k), courses: false)
        }
    }
    arrowThrust(s, fromX: cx, y: cy - u * 1.30, toX: cx, seed: seed &+ 41)
}

func elemTracery(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    lancetWindow(s, cx: cx, top: cy - u * 1.40, bottom: cy + u * 1.20,
                 halfWidth: u * 0.86, lights: 3, seed: seed)
}

func elemRose(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    roseWindow(s, cx: cx, cy: cy, r: u * 1.20, spokes: 12, seed: seed)
}

func elemBoss(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    for k in 0..<4 {
        let a = Double(k) * 1.5708 + 0.7854
        penStroke(s, [pnt(cx + cos(a) * u * 1.30, cy + sin(a) * u * 1.30), pnt(cx, cy)],
                  weight: u * 0.20, colour: Quarry.limeDark, wobble: 0.4,
                  taper: false, seed: seed &+ UInt64(k))
    }
    let boss = ellipsePoints(cx: cx, cy: cy, rx: u * 0.44, ry: u * 0.44, steps: 30)
    stone(s, boss, depth: 0.24, seed: seed &+ 11, courses: false)
    var rng = Chisel(seed &+ 21)
    for k in 0..<8 {
        let a = Double(k) / 8.0 * 6.283185
        let leaf = blob(cx: cx + cos(a) * u * 0.26, cy: cy + sin(a) * u * 0.26,
                        rx: u * 0.16, ry: u * 0.10, rough: 0.22, steps: 12,
                        seed: seed &+ UInt64(30 + k))
        wash(s, leaf, Quarry.limeDark, strength: rng.r(0.34, 0.58), bleed: 2,
             seed: seed &+ UInt64(40 + k))
        penContour(s, leaf, weight: 1.6, colour: Quarry.ink, seed: seed &+ UInt64(50 + k))
    }
}

func elemGargoyle(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let wall = [pnt(cx - u * 1.30, cy - u * 0.10), pnt(cx - u * 0.30, cy - u * 0.10),
                pnt(cx - u * 0.30, cy + u * 1.30), pnt(cx - u * 1.30, cy + u * 1.30)]
    stone(s, wall, depth: 0.44, seed: seed)
    let body = [pnt(cx - u * 0.34, cy - u * 0.06), pnt(cx + u * 1.10, cy - u * 0.34),
                pnt(cx + u * 1.16, cy + u * 0.04), pnt(cx - u * 0.34, cy + u * 0.36)]
    stone(s, body, depth: 0.34, seed: seed &+ 5, courses: false)
    let head = [pnt(cx + u * 0.86, cy - u * 0.44), pnt(cx + u * 1.30, cy - u * 0.30),
                pnt(cx + u * 1.24, cy + u * 0.10), pnt(cx + u * 0.84, cy + u * 0.06)]
    stone(s, head, depth: 0.24, seed: seed &+ 9, courses: false)
    s.disc(cx + u * 1.02, cy - u * 0.22, u * 0.07, Quarry.ink)
    for k in 0..<5 {
        let px = cx + u * (1.22 + Double(k) * 0.10)
        let py = cy + u * (0.10 + Double(k) * 0.16)
        s.disc(px, py, u * (0.07 - Double(k) * 0.008), Quarry.glassBlue.al(0.66))
    }
}

func elemScaffold(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let wall = [pnt(cx - u * 0.30, cy - u * 1.40), pnt(cx + u * 0.70, cy - u * 1.40),
                pnt(cx + u * 0.70, cy + u * 1.30), pnt(cx - u * 0.30, cy + u * 1.30)]
    stone(s, wall, depth: 0.40, seed: seed)
    for k in 0..<4 {
        let y = cy + u * (1.10 - Double(k) * 0.68)
        let beam = [pnt(cx - u * 1.30, y), pnt(cx - u * 0.28, y),
                    pnt(cx - u * 0.28, y + u * 0.11), pnt(cx - u * 1.30, y + u * 0.11)]
        stone(s, beam, depth: 0.40, tone: Quarry.timber, seed: seed &+ UInt64(10 + k),
              courses: false)
    }
    for k in 0..<2 {
        let x = cx - u * (1.20 - Double(k) * 0.68)
        let post = [pnt(x, cy - u * 1.44), pnt(x + u * 0.10, cy - u * 1.44),
                    pnt(x + u * 0.10, cy + u * 1.30), pnt(x, cy + u * 1.30)]
        stone(s, post, depth: 0.46, tone: Quarry.timber, seed: seed &+ UInt64(20 + k),
              courses: false)
    }
}

func elemCrane(_ s: Course, cx: Double, cy: Double, u: Double, seed: UInt64) {
    let wheel = ellipsePoints(cx: cx - u * 0.50, cy: cy + u * 0.40, rx: u * 0.72, ry: u * 0.72,
                              steps: 40)
    stone(s, wheel, depth: 0.36, tone: Quarry.timber, seed: seed, courses: false)
    let hub = ellipsePoints(cx: cx - u * 0.50, cy: cy + u * 0.40, rx: u * 0.50, ry: u * 0.50,
                            steps: 34)
    s.poly(hub, Quarry.paperWarm)
    penContour(s, hub, weight: 2.4, colour: Quarry.ink, seed: seed &+ 3)
    for k in 0..<10 {
        let a = Double(k) / 10.0 * 6.283185
        penStroke(s, [pnt(cx - u * 0.50 + cos(a) * u * 0.50, cy + u * 0.40 + sin(a) * u * 0.50),
                      pnt(cx - u * 0.50 + cos(a) * u * 0.72, cy + u * 0.40 + sin(a) * u * 0.72)],
                  weight: 2.4, colour: Quarry.timber.dk(0.20), wobble: 0.3,
                  taper: false, seed: seed &+ UInt64(k))
    }
    let jib = [pnt(cx - u * 0.20, cy - u * 0.10), pnt(cx + u * 1.30, cy - u * 1.10),
               pnt(cx + u * 1.36, cy - u * 0.94), pnt(cx - u * 0.14, cy + u * 0.06)]
    stone(s, jib, depth: 0.42, tone: Quarry.timber, seed: seed &+ 21, courses: false)
    penStroke(s, [pnt(cx + u * 1.30, cy - u * 1.02), pnt(cx + u * 1.30, cy + u * 0.70)],
              weight: 2.4, colour: Quarry.ink, wobble: 0.4, taper: false, seed: seed &+ 31)
    let block = [pnt(cx + u * 1.12, cy + u * 0.70), pnt(cx + u * 1.48, cy + u * 0.70),
                 pnt(cx + u * 1.48, cy + u * 1.04), pnt(cx + u * 1.12, cy + u * 1.04)]
    stone(s, block, depth: 0.44, seed: seed &+ 41)
}

let elementPlates: [ElementPlate] = elementsA + elementsB + elementsC + elementsD

let elementsA: [ElementPlate] = [
    ElementPlate(slug: "pier-round", title: "The Round Pier", sub: "Romanesque, drum built",
                 draw: elemRoundPier),
    ElementPlate(slug: "pier-compound", title: "The Compound Pier", sub: "Core with attached shafts",
                 draw: elemCompoundPier),
    ElementPlate(slug: "pier-clustered", title: "The Clustered Pier", sub: "A shaft for every rib above",
                 draw: elemClusteredPier),
    ElementPlate(slug: "arch-round", title: "The Semicircular Arch", sub: "Rise fixed at half the span",
                 draw: archElement(0.0)),
]

let elementsB: [ElementPlate] = [
    ElementPlate(slug: "arch-equilateral", title: "The Equilateral Arch", sub: "Radius equal to the span",
                 draw: archElement(0.62)),
    ElementPlate(slug: "arch-lancet", title: "The Lancet Arch", sub: "Steep, narrow, and low in thrust",
                 draw: archElement(0.92)),
    ElementPlate(slug: "vault-barrel", title: "The Barrel Vault", sub: "Thrust along the whole wall",
                 draw: elemBarrelVault),
    ElementPlate(slug: "vault-groin", title: "The Groin Vault", sub: "Two barrels crossed",
                 draw: elemGroinVault),
]

let elementsC: [ElementPlate] = [
    ElementPlate(slug: "vault-rib", title: "The Quadripartite Rib Vault", sub: "Load gathered onto four points",
                 draw: elemRibVault),
    ElementPlate(slug: "vault-fan", title: "The Fan Vault", sub: "English, and structurally a conceit",
                 draw: elemFanVault),
    ElementPlate(slug: "butt-wall", title: "The Thick Wall", sub: "Mass instead of cleverness",
                 draw: elemThickWall),
    ElementPlate(slug: "butt-clasping", title: "The Clasping Buttress", sub: "Mass moved to where it works",
                 draw: elemClaspingButtress),
]

let elementsD: [ElementPlate] = [
    ElementPlate(slug: "butt-flying", title: "The Flying Buttress", sub: "Thrust carried out over the aisle",
                 draw: elemFlyingButtress),
    ElementPlate(slug: "pinnacle", title: "The Pinnacle", sub: "Weight added to steer the thrust down",
                 draw: elemPinnacle),
    ElementPlate(slug: "tracery", title: "Bar Tracery", sub: "Stone reduced to what carries",
                 draw: elemTracery),
    ElementPlate(slug: "rose", title: "The Rose Window", sub: "A wheel of glass in a wall of stone",
                 draw: elemRose),
    ElementPlate(slug: "boss", title: "The Boss", sub: "Where the ribs meet and lock",
                 draw: elemBoss),
    ElementPlate(slug: "gargoyle", title: "The Gargoyle", sub: "A spout, not an ornament",
                 draw: elemGargoyle),
    ElementPlate(slug: "scaffold", title: "The Scaffold", sub: "Putlog holes are still there to see",
                 draw: elemScaffold),
    ElementPlate(slug: "crane", title: "The Treadwheel Crane", sub: "Two men and a rope",
                 draw: elemCrane),
]

func drawElementPlate(_ e: ElementPlate, dir: String) {
    let course = Course(2200, 1700)
    let seed = seedOf("elem-" + e.slug)
    layPaper(course, seed: seed, tone: Quarry.paper)
    course.flipToTopDown()
    course.light = 2.28

    let W = course.w, H = course.h
    plateBorder(course, inset: W * 0.038, seed: seed &+ 3)

    let shadow = ellipsePoints(cx: W * 0.53, cy: H * 0.735, rx: W * 0.22, ry: H * 0.022, steps: 28)
    hatch(course, polyPath(shadow), angle: 0.20, spacing: 4.8, weight: 1.1,
          colour: Quarry.inkSoft.al(0.40), coverage: 0.86,
          bound: polyPath(shadow), seed: seed &+ 5)

    e.draw(course, W * 0.50, H * 0.400, min(W * 0.17, H * 0.20), seed &+ 101)

    penStroke(course, [pnt(W * 0.24, H * 0.800), pnt(W * 0.76, H * 0.800)],
              weight: 2.4, colour: Quarry.ink, wobble: 0.6, taper: true, seed: seed &+ 7)
    label(course, e.title.uppercased(), at: W / 2, H * 0.860,
          size: 36, colour: Quarry.ink, face: "Georgia-Bold", align: .centre, tracking: 4.4)
    label(course, e.sub.uppercased(), at: W / 2, H * 0.906,
          size: 20, colour: Quarry.inkSoft, face: "Georgia", align: .centre, tracking: 3.2)

    course.write(dir, "elem_" + e.slug, quality: 0.95)
}
