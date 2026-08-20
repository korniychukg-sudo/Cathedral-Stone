import Foundation
import CoreGraphics

struct ElementPlate {
    let slug: String
    let title: String
    let sub: String
    let draw: (Course, Double, Double, Double, UInt64) -> Void
}

struct LessonSheet {
    let slug: String
    let title: String
    let draw: (Course, UInt64) -> Void
}

func caption(_ s: Course, _ a: String, _ b: String) {
    let W = s.w, H = s.h
    label(s, a, at: W / 2, H * 0.862, size: 27, colour: Quarry.ink,
          face: "Georgia", align: .centre)
    label(s, b, at: W / 2, H * 0.904, size: 27, colour: Quarry.ink,
          face: "Georgia", align: .centre)
}

func dash(_ s: Course, _ a: CGPoint, _ b: CGPoint, _ c: Tint,
          width: Double = 1.8, pattern: [CGFloat] = [9, 8]) {
    s.ctx.saveGState()
    s.ctx.setLineDash(phase: 0, lengths: pattern)
    s.ctx.setStrokeColor(cgt(c))
    s.ctx.setLineWidth(CGFloat(width))
    s.ctx.beginPath(); s.ctx.move(to: a); s.ctx.addLine(to: b); s.ctx.strokePath()
    s.ctx.restoreGState()
}

let lessonSheets: [LessonSheet] = lessonsA + lessonsB + lessonsC

let lessonsA: [LessonSheet] = [
    LessonSheet(slug: "thrust", title: "Stone Pushes Sideways", draw: lessThrust),
    LessonSheet(slug: "thrust-line", title: "The Line of Thrust", draw: lessThrustLine),
    LessonSheet(slug: "middle-third", title: "The Middle Third", draw: lessMiddleThird),
    LessonSheet(slug: "pointed-arch", title: "Why the Arch Was Pointed", draw: lessPointed),
]

let lessonsB: [LessonSheet] = [
    LessonSheet(slug: "rib-vault", title: "Gathering the Load", draw: lessRib),
    LessonSheet(slug: "flying", title: "Carrying It Out", draw: lessFlying),
    LessonSheet(slug: "pinnacle-weight", title: "What the Pinnacle Is For", draw: lessPinnacle),
    LessonSheet(slug: "hinges", title: "How Masonry Fails", draw: lessHinges),
]

let lessonsC: [LessonSheet] = [
    LessonSheet(slug: "foundations", title: "What Is Underneath", draw: lessFoundations),
    LessonSheet(slug: "centring", title: "Building on Air", draw: lessCentring),
    LessonSheet(slug: "beauvais", title: "The One That Fell", draw: lessBeauvais),
    LessonSheet(slug: "geometry", title: "The Tracing Floor", draw: lessGeometry),
]

func lessThrust(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let springY = H * 0.58
    let band = archBand(cx: W * 0.50, springY: springY, halfSpan: W * 0.22,
                        rise: H * 0.26, pointed: 0.0, thickness: W * 0.05)
    stone(s, band, depth: 0.30, seed: seed)
    voussoirs(s, cx: W * 0.50, springY: springY, halfSpan: W * 0.22, rise: H * 0.26,
              pointed: 0.0, thickness: W * 0.05, count: 14, seed: seed &+ 3)
    for sgn in [-1.0, 1.0] {
        let pier = [pnt(W * 0.50 + sgn * W * 0.22, springY),
                    pnt(W * 0.50 + sgn * W * 0.27, springY),
                    pnt(W * 0.50 + sgn * W * 0.27, H * 0.76),
                    pnt(W * 0.50 + sgn * W * 0.22, H * 0.76)]
        stone(s, pier, depth: 0.44, seed: seed &+ UInt64(10 + Int(sgn * 3)))
        arrowThrust(s, fromX: W * 0.50 + sgn * W * 0.245,
                    y: springY + H * 0.02,
                    toX: W * 0.50 + sgn * W * 0.40, seed: seed &+ UInt64(20 + Int(sgn * 3)))
    }
    dash(s, pnt(W * 0.50, H * 0.24), pnt(W * 0.50, springY - H * 0.26), Quarry.inkSoft.al(0.7))
    label(s, "WEIGHT DOWN", at: W * 0.50, H * 0.22, size: 21, colour: Quarry.inkSoft,
          face: "Georgia-Bold", align: .centre, tracking: 2.2)
    label(s, "THRUST OUT", at: W * 0.88, springY - H * 0.01, size: 21,
          colour: Quarry.oxblood, face: "Georgia-Bold", align: .right, tracking: 2.2)
    caption(s, "An arch does not just press down. It presses outward, hard,",
            "and every stone above the springing makes that push bigger.")
}

func lessThrustLine(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let groundY = H * 0.74
    let unit = min(W * 0.075, H * 0.098)
    naveSection(s, cx: W * 0.50, groundY: groundY, unit: unit,
                pointed: 0.78, flyers: 1, pinnacle: true, seed: seed)
    thrustLine(s, cx: W * 0.50, groundY: groundY, unit: unit, escape: 0.10, seed: seed &+ 31)
    label(s, "THE LINE STAYS INSIDE THE STONE", at: W * 0.50, H * 0.795,
          size: 22, colour: Quarry.moss.dk(0.15), face: "Georgia-Bold",
          align: .centre, tracking: 2.4)
    caption(s, "Draw the path the load actually takes down through the masonry.",
            "While that line stays inside the stone, the building stands. When it leaves, it does not.")
}

func lessMiddleThird(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let baseY = H * 0.68
    for (k, e) in [0.0, 0.30, 0.62].enumerated() {
        let cx = W * (0.22 + Double(k) * 0.28)
        let bw = W * 0.13
        let col = [pnt(cx - bw / 2, H * 0.24), pnt(cx + bw / 2, H * 0.24),
                   pnt(cx + bw / 2, baseY), pnt(cx - bw / 2, baseY)]
        stone(s, col, depth: 0.40, seed: seed &+ UInt64(k))
        let third = [pnt(cx - bw / 6, H * 0.24), pnt(cx + bw / 6, H * 0.24),
                     pnt(cx + bw / 6, baseY), pnt(cx - bw / 6, baseY)]
        wash(s, third, Quarry.moss, strength: 0.22, bleed: 2, seed: seed &+ UInt64(10 + k))
        let lx = cx + e * bw
        penStroke(s, [pnt(lx, H * 0.20), pnt(lx, baseY)], weight: 4.0,
                  colour: e > 0.5 ? Quarry.oxblood : (e > 1.0 / 6.0 ? Quarry.glassGold.dk(0.15)
                                                                     : Quarry.moss.dk(0.15)),
                  wobble: 0.4, taper: false, seed: seed &+ UInt64(20 + k))
        s.disc(lx, baseY, 9, e > 0.5 ? Quarry.oxblood : Quarry.moss.dk(0.15))
        label(s, ["SAFE", "CRACKED", "OVERTURNS"][k], at: cx, baseY + H * 0.052,
              size: 21, colour: e > 0.5 ? Quarry.oxblood : (e > 1.0 / 6.0
                                                            ? Quarry.glassGold.dk(0.25)
                                                            : Quarry.moss.dk(0.15)),
              face: "Georgia-Bold", align: .centre, tracking: 1.8)
    }
    label(s, "THE SHADED BAND IS THE MIDDLE THIRD", at: W * 0.50, H * 0.176,
          size: 21, colour: Quarry.inkSoft, face: "Georgia", align: .centre, tracking: 2.4)
    caption(s, "Keep the thrust line inside the middle third and no joint opens at all.",
            "Outside it the stone cracks but stands; outside the section entirely, it hinges and goes.")
}

func lessPointed(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let springY = H * 0.62
    for (k, p) in [0.0, 0.90].enumerated() {
        let cx = W * (0.30 + Double(k) * 0.40)
        let band = archBand(cx: cx, springY: springY, halfSpan: W * 0.13,
                            rise: H * (k == 0 ? 0.20 : 0.34), pointed: p,
                            thickness: W * 0.035)
        stone(s, band, depth: 0.30, seed: seed &+ UInt64(k))
        for sgn in [-1.0, 1.0] {
            let pier = [pnt(cx + sgn * W * 0.13, springY), pnt(cx + sgn * W * 0.165, springY),
                        pnt(cx + sgn * W * 0.165, H * 0.76), pnt(cx + sgn * W * 0.13, H * 0.76)]
            stone(s, pier, depth: 0.44, seed: seed &+ UInt64(10 + k * 4 + Int(sgn)))
        }
        let arrowLen = k == 0 ? W * 0.13 : W * 0.06
        arrowThrust(s, fromX: cx + W * 0.15, y: springY + H * 0.02,
                    toX: cx + W * 0.15 + arrowLen, seed: seed &+ UInt64(30 + k))
        label(s, k == 0 ? "SEMICIRCULAR" : "POINTED", at: cx, H * 0.80,
              size: 22, colour: Quarry.ink, face: "Georgia-Bold", align: .centre, tracking: 2.2)
        label(s, k == 0 ? "large thrust" : "less than half the thrust",
              at: cx, H * 0.826, size: 19,
              colour: k == 0 ? Quarry.oxblood : Quarry.moss.dk(0.15),
              face: "Georgia", align: .centre)
    }
    caption(s, "A pointed arch stands taller for the same span, and the steeper it rises",
            "the more of its load runs straight down instead of pushing sideways.")
}

func lessRib(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    elemRibVault(s, cx: W * 0.50, cy: H * 0.44, u: min(W * 0.20, H * 0.24), seed: seed)
    for corner in [(-1.0, -1.0), (1.0, -1.0), (-1.0, 1.0), (1.0, 1.0)] {
        let u = min(W * 0.20, H * 0.24)
        let x = W * 0.50 + corner.0 * u * 1.10
        let y = H * 0.44 + (corner.1 < 0 ? -u * 0.70 : u * 0.90)
        s.disc(x, y, 13, Quarry.oxblood)
        arrowThrust(s, fromX: x, y: y + 28, toX: x, seed: seed &+ UInt64(Int(corner.0 * 10)))
    }
    label(s, "ALL OF IT ARRIVES AT FOUR POINTS", at: W * 0.50, H * 0.78,
          size: 22, colour: Quarry.inkSoft, face: "Georgia-Bold", align: .centre, tracking: 2.4)
    caption(s, "A groin vault pushes along its whole edge. A rib vault gathers the load",
            "onto four corners, so the wall between them can be cut away for glass.")
}

func lessFlying(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    elemFlyingButtress(s, cx: W * 0.50, cy: H * 0.44, u: min(W * 0.22, H * 0.26), seed: seed)
    label(s, "THRUST IN", at: W * 0.14, H * 0.30, size: 21, colour: Quarry.oxblood,
          face: "Georgia-Bold", align: .left, tracking: 2.0)
    label(s, "CARRIED OUT OVER THE AISLE", at: W * 0.50, H * 0.22, size: 21,
          colour: Quarry.inkSoft, face: "Georgia", align: .centre, tracking: 2.2)
    label(s, "DOWN THE PIER", at: W * 0.84, H * 0.70, size: 21, colour: Quarry.inkSoft,
          face: "Georgia-Bold", align: .right, tracking: 2.0)
    caption(s, "The flyer does not hold the wall up. It takes the sideways push",
            "across the aisle roof to a pier heavy enough to turn it downward.")
}

func lessPinnacle(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let baseY = H * 0.70
    for (k, withPin) in [false, true].enumerated() {
        let cx = W * (0.30 + Double(k) * 0.40)
        let bw = W * 0.11
        let pier = [pnt(cx - bw / 2, H * 0.34), pnt(cx + bw / 2, H * 0.34),
                    pnt(cx + bw / 2, baseY), pnt(cx - bw / 2, baseY)]
        stone(s, pier, depth: 0.42, seed: seed &+ UInt64(k))
        if withPin {
            let pin = pinnacleShape(cx: cx, baseY: H * 0.34, width: bw * 0.80, height: H * 0.16)
            stone(s, pin, depth: 0.28, seed: seed &+ UInt64(10 + k), courses: false)
        }
        arrowThrust(s, fromX: cx - bw * 1.6, y: H * 0.38, toX: cx - bw * 0.52,
                    seed: seed &+ UInt64(20 + k))
        let ex = withPin ? cx + bw * 0.10 : cx + bw * 0.62
        penStroke(s, [pnt(cx, H * 0.36), pnt(ex, baseY)], weight: 4.0,
                  colour: withPin ? Quarry.moss.dk(0.15) : Quarry.oxblood,
                  wobble: 0.4, taper: false, seed: seed &+ UInt64(30 + k))
        s.disc(ex, baseY, 10, withPin ? Quarry.moss.dk(0.15) : Quarry.oxblood)
        label(s, withPin ? "WITH PINNACLE" : "WITHOUT", at: cx, baseY + H * 0.055,
              size: 22, colour: withPin ? Quarry.moss.dk(0.15) : Quarry.oxblood,
              face: "Georgia-Bold", align: .centre, tracking: 2.0)
        label(s, withPin ? "line inside the base" : "line outside the base",
              at: cx, baseY + H * 0.088, size: 19, colour: Quarry.inkSoft,
              face: "Georgia", align: .centre)
    }
    caption(s, "A pinnacle is not decoration. It is weight put on top of a buttress",
            "to steer the sloping thrust line back down inside the stone below.")
}

func lessHinges(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let springY = H * 0.56
    let band = archBand(cx: W * 0.50, springY: springY, halfSpan: W * 0.24,
                        rise: H * 0.24, pointed: 0.30, thickness: W * 0.055)
    stone(s, band, depth: 0.32, seed: seed)
    let hinges = [pnt(W * 0.50, springY - H * 0.24 - W * 0.055),
                  pnt(W * 0.31, springY - H * 0.10),
                  pnt(W * 0.69, springY - H * 0.10),
                  pnt(W * 0.26, springY)]
    for (k, hp) in hinges.enumerated() {
        s.disc(Double(hp.x), Double(hp.y), 16, Quarry.oxblood.al(0.30))
        s.ring(Double(hp.x), Double(hp.y), 16, 3.4, Quarry.oxblood)
        label(s, "\(k + 1)", at: Double(hp.x), Double(hp.y) + 8, size: 20,
              colour: Quarry.oxblood, face: "Georgia-Bold", align: .centre)
    }
    label(s, "FOUR HINGES AND IT IS A MECHANISM", at: W * 0.50, H * 0.74,
          size: 22, colour: Quarry.oxblood, face: "Georgia-Bold", align: .centre, tracking: 2.4)
    caption(s, "Masonry does not fail by crushing. Joints open, the structure becomes",
            "a chain of blocks, and the fourth hinge turns it into a mechanism that folds.")
}

func lessFoundations(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let groundY = H * 0.44
    let pier = [pnt(W * 0.42, H * 0.16), pnt(W * 0.58, H * 0.16),
                pnt(W * 0.58, groundY), pnt(W * 0.42, groundY)]
    stone(s, pier, depth: 0.36, seed: seed)
    let footing = [pnt(W * 0.30, groundY), pnt(W * 0.70, groundY),
                   pnt(W * 0.66, H * 0.62), pnt(W * 0.34, H * 0.62)]
    stone(s, footing, depth: 0.52, seed: seed &+ 5)
    let raft = [pnt(W * 0.22, H * 0.62), pnt(W * 0.78, H * 0.62),
                pnt(W * 0.78, H * 0.70), pnt(W * 0.22, H * 0.70)]
    stone(s, raft, depth: 0.60, seed: seed &+ 9)
    let soil = [pnt(W * 0.06, groundY), pnt(W * 0.94, groundY),
                pnt(W * 0.94, H * 0.80), pnt(W * 0.06, H * 0.80)]
    wash(s, soil, Quarry.timber, strength: 0.26, bleed: 6, seed: seed &+ 11)
    hatch(s, polyPath(soil), angle: 0.5, spacing: 12.0, weight: 1.1,
          colour: Quarry.inkSoft.al(0.34), coverage: 0.6, bound: polyPath(soil),
          seed: seed &+ 13)
    penStroke(s, [pnt(W * 0.06, groundY), pnt(W * 0.94, groundY)],
              weight: 3.0, colour: Quarry.ink, wobble: 0.8, taper: false, seed: seed &+ 17)
    label(s, "SPREAD FOOTING", at: W * 0.80, H * 0.56, size: 21, colour: Quarry.inkSoft,
          face: "Georgia-Bold", align: .right, tracking: 1.8)
    caption(s, "Half the cathedrals that failed, failed from below.",
            "The footing has to spread the load until the ground can carry it.")
}

func lessCentring(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let springY = H * 0.58
    let band = archBand(cx: W * 0.50, springY: springY, halfSpan: W * 0.22,
                        rise: H * 0.26, pointed: 0.40, thickness: W * 0.05)
    stone(s, band, depth: 0.30, seed: seed)
    let inner = archPoints(cx: W * 0.50, springY: springY, halfSpan: W * 0.22,
                           rise: H * 0.26, pointed: 0.40)
    let form = inner + [pnt(W * 0.72, springY + H * 0.02), pnt(W * 0.28, springY + H * 0.02)]
    stone(s, form, depth: 0.44, tone: Quarry.timber, seed: seed &+ 5, courses: false)
    for k in 0..<8 {
        let t = Double(k) / 7.0
        let p = inner[Int(t * Double(inner.count - 1))]
        penStroke(s, [p, pnt(Double(p.x), springY + H * 0.02)], weight: 2.6,
                  colour: Quarry.timber.dk(0.25), wobble: 0.4, taper: false,
                  seed: seed &+ UInt64(10 + k))
    }
    for sgn in [-1.0, 1.0] {
        let post = [pnt(W * 0.50 + sgn * W * 0.20, springY + H * 0.02),
                    pnt(W * 0.50 + sgn * W * 0.23, springY + H * 0.02),
                    pnt(W * 0.50 + sgn * W * 0.23, H * 0.78),
                    pnt(W * 0.50 + sgn * W * 0.20, H * 0.78)]
        stone(s, post, depth: 0.46, tone: Quarry.timber, seed: seed &+ UInt64(30 + Int(sgn * 3)),
              courses: false)
    }
    label(s, "THE CENTRING CARRIES IT UNTIL THE KEYSTONE GOES IN",
          at: W * 0.50, H * 0.82, size: 21, colour: Quarry.inkSoft,
          face: "Georgia", align: .centre, tracking: 2.0)
    caption(s, "An arch does nothing until it is complete, so every one was built",
            "on a timber former. Half the cost of a cathedral was carpentry.")
}

func lessBeauvais(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let groundY = H * 0.76
    let unit = min(W * 0.070, H * 0.092)
    naveSection(s, cx: W * 0.50, groundY: groundY, unit: unit,
                pointed: 0.90, flyers: 2, pinnacle: false, seed: seed)
    thrustLine(s, cx: W * 0.50, groundY: groundY, unit: unit, escape: 0.85, seed: seed &+ 31)
    var rng = Chisel(seed &+ 71)
    for _ in 0..<9 {
        let x = W * 0.50 + rng.r(-unit * 3.4, unit * 3.4)
        let y = groundY - rng.r(unit * 0.4, unit * 4.2)
        penStroke(s, [pnt(x, y), pnt(x + rng.r(-30, 30), y + rng.r(30, 90))],
                  weight: 3.0, colour: Quarry.oxblood.al(0.72), wobble: 1.6,
                  taper: true, seed: seed &+ u64(Int(x + y)))
    }
    label(s, "THE LINE LEAVES THE STONE", at: W * 0.50, H * 0.812,
          size: 22, colour: Quarry.oxblood, face: "Georgia-Bold", align: .centre, tracking: 2.4)
    caption(s, "Beauvais reached forty-eight metres in 1272 and came down in 1284.",
            "Too tall, too thin, and the buttress piers too far apart to turn the thrust.")
}

func lessGeometry(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let floor = [pnt(W * 0.08, H * 0.16), pnt(W * 0.92, H * 0.16),
                 pnt(W * 0.92, H * 0.78), pnt(W * 0.08, H * 0.78)]
    wash(s, floor, Quarry.limestone, strength: 0.44, bleed: 4, seed: seed)
    penContour(s, floor, weight: 2.6, colour: Quarry.ink, seed: seed &+ 3)
    let cx = W * 0.50, cy = H * 0.50
    let r = min(W * 0.19, H * 0.24)
    for k in 0..<3 {
        s.ctx.saveGState()
        s.ctx.setStrokeColor(cgt(Quarry.inkSoft.al(0.52)))
        s.ctx.setLineWidth(1.8)
        let ox = cx + (Double(k) - 1.0) * r
        s.ctx.strokeEllipse(in: CGRect(x: ox - r, y: cy - r, width: r * 2, height: r * 2))
        s.ctx.restoreGState()
    }
    let sq = [pnt(cx - r * 0.71, cy - r * 0.71), pnt(cx + r * 0.71, cy - r * 0.71),
              pnt(cx + r * 0.71, cy + r * 0.71), pnt(cx - r * 0.71, cy + r * 0.71)]
    penContour(s, sq, weight: 2.6, colour: Quarry.oxblood, seed: seed &+ 11)
    let sq2 = [pnt(cx, cy - r), pnt(cx + r, cy), pnt(cx, cy + r), pnt(cx - r, cy)]
    penContour(s, sq2, weight: 2.6, colour: Quarry.glassBlue, seed: seed &+ 13)
    label(s, "AD QUADRATUM", at: cx, cy + r * 1.44, size: 24, colour: Quarry.oxblood,
          face: "Georgia-Bold", align: .centre, tracking: 3.0)
    caption(s, "There were no drawings to scale and no arithmetic worth the name.",
            "Everything was set out full size on a plaster floor with a cord and a straight edge.")
}

func drawLessonSheet(_ l: LessonSheet, dir: String) {
    let course = Course(2300, 1725)
    let seed = seedOf("cslesson-" + l.slug)
    layPaper(course, seed: seed, tone: Quarry.paper)
    course.flipToTopDown()
    course.light = 2.30
    plateBorder(course, inset: course.w * 0.038, seed: seed &+ 3)
    label(course, l.title.uppercased(), at: course.w / 2, course.h * 0.082,
          size: 34, colour: Quarry.ink, face: "Georgia-Bold", align: .centre, tracking: 4.4)
    penStroke(course, [pnt(course.w * 0.28, course.h * 0.102),
                       pnt(course.w * 0.72, course.h * 0.102)],
              weight: 2.2, colour: Quarry.ink, wobble: 0.6, taper: true, seed: seed &+ 5)
    l.draw(course, seed &+ 101)
    course.write(dir, "les_" + l.slug, quality: 0.95)
}

struct SiteScene {
    let slug: String
    let draw: (Course, UInt64) -> Void
}

let siteScenes: [SiteScene] = [
    SiteScene(slug: "lodge", draw: sceneLodge),
    SiteScene(slug: "yard", draw: sceneYard),
    SiteScene(slug: "scaffold", draw: sceneScaffoldSite),
    SiteScene(slug: "nave", draw: sceneNave),
    SiteScene(slug: "tracingfloor", draw: sceneTracing),
    SiteScene(slug: "westfront", draw: sceneWestFront),
]

func groundPlane(_ s: Course, y: Double, seed: UInt64) {
    let W = s.w, H = s.h
    let top = [pnt(-20, y), pnt(W + 20, y), pnt(W + 20, H + 20), pnt(-20, H + 20)]
    wash(s, top, Quarry.timber.lt(0.24), strength: 0.44, bleed: 6, seed: seed)
    penStroke(s, [pnt(-20, y), pnt(W + 20, y)], weight: 3.0, colour: Quarry.ink,
              wobble: 1.0, taper: false, seed: seed &+ 11)
}

func sceneLodge(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    groundPlane(s, y: H * 0.70, seed: seed)
    let u = min(W * 0.10, H * 0.14)
    elemCrane(s, cx: W * 0.72, cy: H * 0.42, u: u, seed: seed &+ 11)
    elemScaffold(s, cx: W * 0.26, cy: H * 0.44, u: u, seed: seed &+ 21)
    var rng = Chisel(seed &+ 31)
    for k in 0..<7 {
        let bx = W * rng.r(0.12, 0.88)
        let by = H * rng.r(0.74, 0.90)
        let bw = u * rng.r(0.22, 0.42)
        let block = [pnt(bx - bw, by - bw * 0.6), pnt(bx + bw, by - bw * 0.6),
                     pnt(bx + bw, by + bw * 0.6), pnt(bx - bw, by + bw * 0.6)]
        stone(s, block, depth: rng.r(0.28, 0.60), seed: seed &+ UInt64(40 + k))
    }
}

func sceneYard(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    groundPlane(s, y: H * 0.52, seed: seed)
    var rng = Chisel(seed &+ 11)
    for k in 0..<14 {
        let bx = W * rng.r(0.08, 0.92)
        let by = H * rng.r(0.56, 0.94)
        let bw = min(W, H) * rng.r(0.045, 0.095)
        let block = [pnt(bx - bw, by - bw * 0.62), pnt(bx + bw, by - bw * 0.70),
                     pnt(bx + bw, by + bw * 0.60), pnt(bx - bw, by + bw * 0.66)]
        stone(s, block, depth: rng.r(0.24, 0.64), seed: seed &+ UInt64(20 + k))
    }
    let bench = [pnt(W * 0.10, H * 0.34), pnt(W * 0.44, H * 0.32),
                 pnt(W * 0.44, H * 0.40), pnt(W * 0.10, H * 0.42)]
    stone(s, bench, depth: 0.46, tone: Quarry.timber, seed: seed &+ 51, courses: false)
    let mallet = [pnt(W * 0.20, H * 0.24), pnt(W * 0.28, H * 0.22),
                  pnt(W * 0.29, H * 0.30), pnt(W * 0.21, H * 0.32)]
    stone(s, mallet, depth: 0.42, tone: Quarry.timber, seed: seed &+ 61, courses: false)
    penStroke(s, [pnt(W * 0.29, H * 0.27), pnt(W * 0.44, H * 0.22)],
              weight: 8.0, colour: Quarry.timber.dk(0.20), wobble: 0.5, taper: false,
              seed: seed &+ 71)
}

func sceneScaffoldSite(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let sky = [pnt(-20, -20), pnt(W + 20, -20), pnt(W + 20, H * 0.80), pnt(-20, H * 0.80)]
    wash(s, sky, Quarry.sky, strength: 0.22, bleed: 8, seed: seed)
    groundPlane(s, y: H * 0.80, seed: seed &+ 5)
    let u = min(W * 0.13, H * 0.17)
    elemScaffold(s, cx: W * 0.36, cy: H * 0.46, u: u, seed: seed &+ 11)
    elemCrane(s, cx: W * 0.74, cy: H * 0.36, u: u * 0.8, seed: seed &+ 21)
    let wall = [pnt(W * 0.06, H * 0.30), pnt(W * 0.30, H * 0.30),
                pnt(W * 0.30, H * 0.80), pnt(W * 0.06, H * 0.80)]
    stone(s, wall, depth: 0.44, seed: seed &+ 31)
    lancetWindow(s, cx: W * 0.18, top: H * 0.40, bottom: H * 0.68,
                 halfWidth: W * 0.055, lights: 1, seed: seed &+ 41)
}

func sceneNave(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let dark = [pnt(-20, -20), pnt(W + 20, -20), pnt(W + 20, H + 20), pnt(-20, H + 20)]
    wash(s, dark, Quarry.paperNight, strength: 0.30, bleed: 8, seed: seed)
    let floorY = H * 0.86
    for k in 0..<5 {
        let t = Double(k) / 4.0
        let inset = t * W * 0.30
        let halfSpan = W * (0.34 - t * 0.20)
        let springY = H * (0.44 + t * 0.10)
        let band = archBand(cx: W * 0.50, springY: springY, halfSpan: halfSpan,
                            rise: H * (0.24 - t * 0.09), pointed: 0.82,
                            thickness: W * (0.030 - t * 0.010))
        stone(s, band, depth: 0.24 + t * 0.30, seed: seed &+ UInt64(10 + k))
        for sgn in [-1.0, 1.0] {
            let pier = [pnt(W * 0.50 + sgn * halfSpan, springY),
                        pnt(W * 0.50 + sgn * (halfSpan + W * 0.035 - inset * 0.02), springY),
                        pnt(W * 0.50 + sgn * (halfSpan + W * 0.035 - inset * 0.02), floorY),
                        pnt(W * 0.50 + sgn * halfSpan, floorY)]
            stone(s, pier, depth: 0.34 + t * 0.28, seed: seed &+ UInt64(30 + k * 3 + Int(sgn)))
        }
    }
    roseWindow(s, cx: W * 0.50, cy: H * 0.22, r: min(W * 0.10, H * 0.13), spokes: 12,
               seed: seed &+ 71)
    if let g = CGGradient(colorsSpace: naveSpace,
                          colors: [cgt(Quarry.glassGold.al(0.34)), cgt(Quarry.glassGold.al(0))] as CFArray,
                          locations: [0, 1]) {
        s.ctx.drawRadialGradient(g, startCenter: CGPoint(x: W * 0.50, y: H * 0.30),
                                 startRadius: 0,
                                 endCenter: CGPoint(x: W * 0.50, y: H * 0.30),
                                 endRadius: max(W, H) * 0.60, options: [])
    }
    let floor = [pnt(-20, floorY), pnt(W + 20, floorY), pnt(W + 20, H + 20), pnt(-20, H + 20)]
    wash(s, floor, Quarry.limestone, strength: 0.50, bleed: 5, seed: seed &+ 81)
    var rng = Chisel(seed &+ 91)
    for k in 0..<8 {
        let y = floorY + Double(k) * (H - floorY) / 7
        penStroke(s, [pnt(-20, y), pnt(W + 20, y + rng.signed() * 3)],
                  weight: 1.4, colour: Quarry.ink.al(0.20), wobble: 0.6, taper: false,
                  seed: seed &+ UInt64(100 + k))
    }
}

func sceneTracing(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let floor = [pnt(-20, -20), pnt(W + 20, -20), pnt(W + 20, H + 20), pnt(-20, H + 20)]
    wash(s, floor, Quarry.limestone, strength: 0.52, bleed: 6, seed: seed)
    var rng = Chisel(seed &+ 11)
    let cx = W * 0.48, cy = H * 0.48
    let r = min(W * 0.24, H * 0.30)
    for k in 0..<6 {
        s.ctx.saveGState()
        s.ctx.setStrokeColor(cgt(Quarry.inkSoft.al(rng.r(0.28, 0.52))))
        s.ctx.setLineWidth(1.8)
        let ox = cx + (Double(k) - 2.5) * r * 0.5
        s.ctx.strokeEllipse(in: CGRect(x: ox - r, y: cy - r, width: r * 2, height: r * 2))
        s.ctx.restoreGState()
    }
    let arch = archPoints(cx: cx, springY: cy + r * 0.6, halfSpan: r, rise: r * 1.2, pointed: 0.8)
    penStroke(s, arch, weight: 3.4, colour: Quarry.oxblood, wobble: 0.5, taper: false,
              seed: seed &+ 21)
    for k in 0..<10 {
        let a = Double(k) / 10.0 * 6.283185
        penStroke(s, [pnt(cx, cy), pnt(cx + cos(a) * r * 1.4, cy + sin(a) * r * 1.4)],
                  weight: 1.2, colour: Quarry.inkSoft.al(0.26), wobble: 0.4, taper: false,
                  seed: seed &+ UInt64(30 + k))
    }
    let compass = [pnt(W * 0.80, H * 0.20), pnt(W * 0.86, H * 0.22),
                   pnt(W * 0.76, H * 0.62), pnt(W * 0.72, H * 0.60)]
    stone(s, compass, depth: 0.42, tone: Quarry.lead, seed: seed &+ 61, courses: false)
    let compass2 = [pnt(W * 0.80, H * 0.20), pnt(W * 0.86, H * 0.22),
                    pnt(W * 0.94, H * 0.58), pnt(W * 0.89, H * 0.62)]
    stone(s, compass2, depth: 0.56, tone: Quarry.lead, seed: seed &+ 63, courses: false)
}

func sceneWestFront(_ s: Course, seed: UInt64) {
    let W = s.w, H = s.h
    let sky = [pnt(-20, -20), pnt(W + 20, -20), pnt(W + 20, H * 0.86), pnt(-20, H * 0.86)]
    wash(s, sky, Quarry.sky, strength: 0.20, bleed: 8, seed: seed)
    groundPlane(s, y: H * 0.86, seed: seed &+ 3)
    let baseY = H * 0.86
    let body = [pnt(W * 0.22, H * 0.28), pnt(W * 0.78, H * 0.28),
                pnt(W * 0.78, baseY), pnt(W * 0.22, baseY)]
    stone(s, body, depth: 0.36, seed: seed &+ 5)
    for sgn in [-1.0, 1.0] {
        let tower = [pnt(W * 0.50 + sgn * W * 0.28, H * 0.10),
                     pnt(W * 0.50 + sgn * W * 0.16, H * 0.10),
                     pnt(W * 0.50 + sgn * W * 0.16, baseY),
                     pnt(W * 0.50 + sgn * W * 0.28, baseY)]
        stone(s, tower, depth: 0.32 + (sgn > 0 ? 0.18 : 0), seed: seed &+ UInt64(10 + Int(sgn * 3)))
        lancetWindow(s, cx: W * 0.50 + sgn * W * 0.22, top: H * 0.20, bottom: H * 0.40,
                     halfWidth: W * 0.035, lights: 1, seed: seed &+ UInt64(20 + Int(sgn * 3)))
        let spire = pinnacleShape(cx: W * 0.50 + sgn * W * 0.22, baseY: H * 0.10,
                                  width: W * 0.12, height: H * 0.14)
        stone(s, spire, depth: 0.30, seed: seed &+ UInt64(30 + Int(sgn * 3)), courses: false)
    }
    roseWindow(s, cx: W * 0.50, cy: H * 0.40, r: min(W * 0.11, H * 0.14), spokes: 12,
               seed: seed &+ 41)
    let portal = archPoints(cx: W * 0.50, springY: H * 0.72, halfSpan: W * 0.11,
                            rise: H * 0.14, pointed: 0.80)
        + [pnt(W * 0.61, baseY), pnt(W * 0.39, baseY)]
    s.poly(portal, Quarry.paperNight.al(0.80))
    penContour(s, portal, weight: 3.4, colour: Quarry.ink, seed: seed &+ 51)
    for k in 0..<3 {
        let ring = archBand(cx: W * 0.50, springY: H * 0.72,
                            halfSpan: W * (0.11 + Double(k) * 0.022),
                            rise: H * (0.14 + Double(k) * 0.026), pointed: 0.80,
                            thickness: W * 0.020)
        stone(s, ring, depth: 0.30 + Double(k) * 0.10, seed: seed &+ UInt64(60 + k))
    }
}

func drawSiteScene(_ sc: SiteScene, dir: String) {
    let course = Course(2300, 1570)
    let seed = seedOf("csscene-" + sc.slug)
    layPaper(course, seed: seed, tone: Quarry.paper)
    course.flipToTopDown()
    course.light = 2.26
    sc.draw(course, seed &+ 101)
    course.write(dir, "scene_" + sc.slug, quality: 0.95)
}
