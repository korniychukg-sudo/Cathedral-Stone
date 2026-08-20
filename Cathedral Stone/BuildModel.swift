import Foundation

struct Programme: Identifiable {
    let slug: String
    let name: String
    let span: Double
    let vaultHeight: Double
    let note: String
    var id: String { slug }
}

let programmes: [Programme] = [
    Programme(slug: "parish", name: "A parish church", span: 8.0, vaultHeight: 16.0,
              note: "Modest, and modest is safe. A span of eight metres and a vault sixteen up: nothing here will kill you if you get a choice slightly wrong."),
    Programme(slug: "abbey", name: "An abbey church", span: 11.0, vaultHeight: 24.0,
              note: "The size most of the great monastic houses actually built. Wide enough to need real buttressing, low enough to forgive one mistake."),
    Programme(slug: "cathedral", name: "A cathedral", span: 14.0, vaultHeight: 34.0,
              note: "Chartres, near enough. Everything you know has to be right at once, and there is no margin left over for showing off."),
    Programme(slug: "beauvais", name: "Higher than Amiens", span: 15.0, vaultHeight: 46.0,
              note: "The chapter wants the tallest vault in Christendom. Beauvais tried this in 1272 and it came down twelve years later. The chapter does not want to hear that."),
]

struct PierChoice: Identifiable {
    let slug: String
    let name: String
    let thickness: Double
    let stone: Double
    let elegance: Double
    let plate: String
    let note: String
    var id: String { slug }
}

let pierChoices: [PierChoice] = [
    PierChoice(slug: "pier-round", name: "Round drum pier", thickness: 2.2, stone: 1.30,
               elegance: 0.30, plate: "elem_pier-round",
               note: "Romanesque, built as a rubble-filled drum with an ashlar skin. Enormously strong and enormously heavy, and it eats the floor of the church."),
    PierChoice(slug: "pier-compound", name: "Compound pier", thickness: 1.7, stone: 1.00,
               elegance: 0.62, plate: "elem_pier-compound",
               note: "A core with shafts attached to it, each shaft running up to meet something above. Less stone than a drum and it tells you where the load is going."),
    PierChoice(slug: "pier-clustered", name: "Clustered shafts", thickness: 1.3, stone: 0.82,
               elegance: 0.95, plate: "elem_pier-clustered",
               note: "A shaft for every rib in the vault above, bundled together. The most beautiful thing in the building and the least forgiving of a heavy vault."),
]

struct ArchChoice: Identifiable {
    let slug: String
    let name: String
    let pointed: Double
    let plate: String
    let note: String
    var id: String { slug }
}

let archChoices: [ArchChoice] = [
    ArchChoice(slug: "arch-round", name: "Semicircular", pointed: 0.0, plate: "elem_arch-round",
               note: "The Roman arch. Its rise is fixed at half the span, so a wide bay is a low bay, and the thrust is large and unavoidable."),
    ArchChoice(slug: "arch-equilateral", name: "Equilateral pointed", pointed: 0.62,
               plate: "elem_arch-equilateral",
               note: "Struck from two centres a span apart. Rises higher than a semicircle for the same span, and pushes out noticeably less."),
    ArchChoice(slug: "arch-lancet", name: "Sharp lancet", pointed: 0.92, plate: "elem_arch-lancet",
               note: "Steep and narrow. Most of the load runs straight down the piers, and the sideways push is roughly half a semicircular arch of the same span."),
]

struct VaultChoice: Identifiable {
    let slug: String
    let name: String
    let weight: Double
    let stone: Double
    let light: Double
    let elegance: Double
    let plate: String
    let note: String
    var id: String { slug }
}

let vaultChoices: [VaultChoice] = [
    VaultChoice(slug: "vault-barrel", name: "Barrel vault", weight: 26.0, stone: 1.35,
                light: 0.15, elegance: 0.20, plate: "elem_vault-barrel",
                note: "A continuous tunnel of stone. It pushes outward along the entire length of both walls, so the walls must stay solid and the church stays dark."),
    VaultChoice(slug: "vault-groin", name: "Groin vault", weight: 22.0, stone: 1.10,
                light: 0.42, elegance: 0.45, plate: "elem_vault-groin",
                note: "Two barrels crossed at right angles. The load concentrates along the groins, which means the wall between bays can begin to open up."),
    VaultChoice(slug: "vault-rib", name: "Quadripartite rib vault", weight: 18.0, stone: 0.90,
                light: 0.78, elegance: 0.82, plate: "elem_vault-rib",
                note: "Ribs first, thin web afterwards. Everything arrives at four corners, the wall between them carries almost nothing, and the whole thing can be built without full centring."),
    VaultChoice(slug: "vault-fan", name: "Fan vault", weight: 17.0, stone: 1.20,
                light: 0.70, elegance: 1.00, plate: "elem_vault-fan",
                note: "Every rib the same curve, spreading like a fan. Structurally it is a conceit — it works, but it is cut from solid blocks and costs a fortune in labour."),
]

struct ButtressChoice: Identifiable {
    let slug: String
    let name: String
    let base: Double
    let relief: Double
    let stone: Double
    let light: Double
    let plate: String
    let note: String
    var id: String { slug }
}

let buttressChoices: [ButtressChoice] = [
    ButtressChoice(slug: "butt-none", name: "Nothing at all", base: 1.0, relief: 0.0,
                   stone: 0.0, light: 0.30, plate: "elem_butt-wall",
                   note: "The wall on its own. It will do for a small span and a light vault and for nothing else."),
    ButtressChoice(slug: "butt-wall", name: "A thicker wall", base: 2.0, relief: 0.0,
                   stone: 1.10, light: 0.10, plate: "elem_butt-wall",
                   note: "Mass, everywhere, whether it is needed or not. It works, it is dull, and it makes windows impossible."),
    ButtressChoice(slug: "butt-clasping", name: "Clasping buttresses", base: 2.9, relief: 0.06,
                   stone: 0.95, light: 0.50, plate: "elem_butt-clasping",
                   note: "The same mass, moved to where the thrust actually arrives. Between the buttresses the wall can be thinned and pierced."),
    ButtressChoice(slug: "butt-flying-1", name: "Flying buttress, one tier", base: 3.4,
                   relief: 0.20, stone: 1.05, light: 0.85, plate: "elem_butt-flying",
                   note: "An arch flung across the aisle roof, carrying the thrust out to a free-standing pier. The clerestory wall can now be almost entirely glass."),
    ButtressChoice(slug: "butt-flying-2", name: "Flying buttress, two tiers", base: 3.9,
                   relief: 0.32, stone: 1.35, light: 0.92, plate: "elem_butt-flying",
                   note: "Two flyers, one at the vault springing and one lower to take the wind. This is the Chartres answer and it is the reason Chartres is still standing."),
]

struct PinnacleChoice: Identifiable {
    let slug: String
    let name: String
    let weight: Double
    let stone: Double
    let elegance: Double
    let note: String
    var id: String { slug }
}

let pinnacleChoices: [PinnacleChoice] = [
    PinnacleChoice(slug: "pin-none", name: "No pinnacle", weight: 0.0, stone: 0.0,
                   elegance: 0.0,
                   note: "Nothing on top of the buttress pier. Cheaper, plainer, and the thrust line comes down wherever it likes."),
    PinnacleChoice(slug: "pin-small", name: "A modest pinnacle", weight: 120.0, stone: 0.30,
                   elegance: 0.50,
                   note: "Enough weight to bend the resultant downward without adding much to the foundation."),
    PinnacleChoice(slug: "pin-tall", name: "A tall crocketed pinnacle", weight: 260.0,
                   stone: 0.62, elegance: 0.90,
                   note: "Serious weight, and the crockets are there to make the mass look like ornament. Every French cathedral does this and none of them admit why."),
]

struct Design {
    var programme: Programme
    var pier: PierChoice
    var arch: ArchChoice
    var vault: VaultChoice
    var buttress: ButtressChoice
    var pinnacle: PinnacleChoice
}

struct Analysis {
    let vaultLoad: Double
    let rise: Double
    let thrust: Double
    let buttressWeight: Double
    let pinnacleWeight: Double
    let leverArm: Double
    let eccentricity: Double
    let baseWidth: Double
    let middleThird: Double
    let pierStress: Double
    let pierCapacity: Double
    let stoneUsed: Double
    let light: Double
    let elegance: Double
    let verdict: Verdict
    let escape: Double
}

enum Verdict: String {
    case safe, cracked, overturned, crushed

    var title: String {
        switch self {
        case .safe: return "It stands"
        case .cracked: return "It stands, and it has cracked"
        case .overturned: return "The buttress has gone over"
        case .crushed: return "The piers have crushed"
        }
    }
}

func analyse(_ d: Design) -> Analysis {
    let span = d.programme.span
    let h = d.programme.vaultHeight

    let vaultLoad = d.vault.weight * span
    let rise = span / 2.0 * (1.0 + d.arch.pointed * 0.62)
    let thrust = vaultLoad * span / (8.0 * max(1.0, rise))

    let buttressHeight = h * 0.86
    let leverArm = buttressHeight * (1.0 - d.buttress.relief)

    let base = d.buttress.base
    let buttressWeight = 21.0 * base * buttressHeight * 0.55
    let pinnacleWeight = d.pinnacle.weight

    let vertical = buttressWeight + pinnacleWeight
    let eccentricity = thrust * leverArm / max(1.0, vertical)
    let middleThird = base / 6.0

    let pierLoad = vaultLoad * 0.55 + 21.0 * d.pier.thickness * d.pier.thickness * h * 0.30
    let pierCapacity = 1900.0 * d.pier.thickness * d.pier.thickness
    let pierStress = pierLoad / max(1.0, pierCapacity)

    let stoneUsed = d.pier.stone * 1.1 + d.vault.stone + d.buttress.stone
        + d.pinnacle.stone + span / 12.0
    let light = min(1.0, d.vault.light * 0.55 + d.buttress.light * 0.45)
    let elegance = min(1.0, d.pier.elegance * 0.30 + d.vault.elegance * 0.34
                       + d.pinnacle.elegance * 0.16 + light * 0.20)

    var verdict: Verdict = .safe
    if pierStress > 1.0 {
        verdict = .crushed
    } else if eccentricity > base / 2.0 {
        verdict = .overturned
    } else if eccentricity > middleThird {
        verdict = .cracked
    }

    let escape = min(1.0, max(0.0, eccentricity / max(0.2, base / 2.0)))

    return Analysis(vaultLoad: vaultLoad, rise: rise, thrust: thrust,
                    buttressWeight: buttressWeight, pinnacleWeight: pinnacleWeight,
                    leverArm: leverArm, eccentricity: eccentricity, baseWidth: base,
                    middleThird: middleThird, pierStress: pierStress,
                    pierCapacity: pierCapacity, stoneUsed: stoneUsed,
                    light: light, elegance: elegance, verdict: verdict, escape: escape)
}

func verdictComment(_ a: Analysis, _ d: Design) -> String {
    switch a.verdict {
    case .crushed:
        return "The vault and the wall above weigh more than piers that thin can carry. "
            + String(format: "The stress is %.0f per cent of what the stone will take. ", a.pierStress * 100)
            + "Thicker piers, or a lighter vault."
    case .overturned:
        return "The thrust line leaves the buttress base. "
            + String(format: "It lands %.2f m from the centre, and the base is only %.1f m wide. ",
                     a.eccentricity, a.baseWidth)
            + "You need more weight on top of the pier, a wider base, or an arch that pushes less hard."
    case .cracked:
        return "It stands, but the joints have opened on the inside face. "
            + String(format: "The line falls %.2f m off centre and the middle third ends at %.2f m. ",
                     a.eccentricity, a.middleThird)
            + "Mediaeval buildings live like this for centuries — but a mason would not call it finished."
    case .safe:
        return "The thrust line stays inside the middle third the whole way down, so no joint opens anywhere. "
            + String(format: "Off centre by %.2f m against a limit of %.2f m. ",
                     a.eccentricity, a.middleThird)
            + "This is what the great churches actually achieved."
    }
}

func masterGrade(_ a: Analysis, _ d: Design) -> String {
    guard a.verdict == .safe || a.verdict == .cracked else { return "Rebuilt at your expense" }
    let heightScore = min(1.0, d.programme.vaultHeight / 46.0)
    let economy = max(0.0, 1.0 - a.stoneUsed / 7.0)
    let score = heightScore * 0.30 + a.light * 0.26 + a.elegance * 0.24 + economy * 0.12
        + (a.verdict == .safe ? 0.12 : 0.0)
    if score >= 0.76 { return "Master mason" }
    if score >= 0.60 { return "A fine church" }
    if score >= 0.44 { return "Sound work" }
    return "It will do"
}

struct BuildStage: Identifiable {
    let key: String
    let title: String
    let question: String
    var id: String { key }
}

let buildStages: [BuildStage] = [
    BuildStage(key: "programme", title: "The commission",
               question: "What has the chapter asked for?"),
    BuildStage(key: "pier", title: "The piers", question: "What will carry it?"),
    BuildStage(key: "arch", title: "The arcade", question: "What shape are the arches?"),
    BuildStage(key: "vault", title: "The vault", question: "What goes overhead?"),
    BuildStage(key: "buttress", title: "The buttressing", question: "Where does the thrust go?"),
    BuildStage(key: "pinnacle", title: "The pinnacle", question: "What sits on the buttress pier?"),
]
