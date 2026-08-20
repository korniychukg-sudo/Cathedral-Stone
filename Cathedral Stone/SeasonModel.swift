import Foundation

enum StoneDay {
    static let epoch: TimeInterval = 1_767_225_600

    static func index(for date: Date = Date()) -> Int {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        let start = cal.startOfDay(for: date)
        return Int(floor((start.timeIntervalSince1970 - epoch) / 86_400.0))
    }

    static func hour(for date: Date = Date()) -> Double {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        let parts = cal.dateComponents([.hour, .minute], from: date)
        return Double(parts.hour ?? 12) + Double(parts.minute ?? 0) / 60.0
    }

    static func title(for date: Date = Date()) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "EEEE d MMMM"
        return f.string(from: date)
    }
}

struct StoneSpin {
    private var s: UInt64

    init(_ seed: Int) {
        let v = UInt64(bitPattern: Int64(seed &* 2_654_435_761 &+ 1_013_904_223))
        s = v == 0 ? 0x9E37_79B9_7F4A_7C15 : v
    }

    mutating func next() -> UInt64 {
        s ^= s << 13; s ^= s >> 7; s ^= s << 17
        return s
    }

    mutating func unit() -> Double { Double(next() % 1_000_000) / 1_000_000.0 }
    mutating func range(_ a: Double, _ b: Double) -> Double { a + unit() * (b - a) }
    mutating func pick(_ n: Int) -> Int { n <= 1 ? 0 : Int(next() % UInt64(n)) }
}

struct LodgeRank {
    let name: String
    let threshold: Int
    let note: String
}

let lodgeRanks: [LodgeRank] = [
    LodgeRank(name: "Hewer", threshold: 0,
              note: "You dress what you are given and you are starting to see why."),
    LodgeRank(name: "Setter", threshold: 80,
              note: "You know which way a load travels once it leaves the vault."),
    LodgeRank(name: "Warden", threshold: 235,
              note: "The middle third is no longer a rule you remember, it is a place you can see."),
    LodgeRank(name: "Master Mason", threshold: 505,
              note: "You can put a vault where the chapter wants it and keep it there."),
    LodgeRank(name: "Architect of the Work", threshold: 960,
              note: "There is nothing in this trade that could surprise you now."),
]

func lodgeRankFor(points: Int) -> (rank: LodgeRank, next: LodgeRank?, progress: Double) {
    var current = lodgeRanks[0]
    var next: LodgeRank? = nil
    for (i, r) in lodgeRanks.enumerated() where points >= r.threshold {
        current = r
        next = i + 1 < lodgeRanks.count ? lodgeRanks[i + 1] : nil
    }
    guard let n = next else { return (current, nil, 1.0) }
    let span = Double(n.threshold - current.threshold)
    return (current, n, max(0, min(1, Double(points - current.threshold) / max(1, span))))
}

enum ChapterWish: String {
    case height, light, thrift, permanence

    var headline: String {
        switch self {
        case .height: return "The chapter wants it tall"
        case .light: return "The chapter wants it light"
        case .thrift: return "The chapter wants it cheap"
        case .permanence: return "The chapter wants it to last"
        }
    }

    var detail: String {
        switch self {
        case .height:
            return "They have seen what is going up down the road and they will not be second. A pointed arcade, so the vault rises well clear of half the span, and it has to stand."
        case .light:
            return "The glass is already ordered. Whatever you build has to let it be seen, which means less wall and more window than is comfortable."
        case .thrift:
            return "The quarry account is closed at the end of the season and there is no appetite to reopen it. Come in under the grant."
        case .permanence:
            return "Nothing is to crack. Not a hairline, not a settlement crack, nothing that a canon can point at in fifty years."
        }
    }

    var short: String {
        switch self {
        case .height: return "Height"
        case .light: return "Light"
        case .thrift: return "Thrift"
        case .permanence: return "Permanence"
        }
    }
}

struct SeasonEvent {
    let season: String
    let title: String
    let note: String
    let stoneDelta: Double
    let banned: String?
}

let seasonNames = ["The first season", "The second season", "The third season",
                   "The fourth season", "The fifth season"]

enum SeasonSeeds {
    static let events: [(String, String, Double, String?)] = [
        ("A hard winter", "Frost got into the mortar before it set and a course had to come down and go back up. The work is dearer this year.", 0.30, nil),
        ("A dry summer", "Good weather, good carting, and the quarry road held. The lodge is ahead of itself for once.", -0.26, nil),
        ("The quarry floods", "The best beds are under water until the spring. What arrives is second-rate and there is more of it to lay.", 0.34, nil),
        ("A patron dies well", "A legacy arrives with the bishop's blessing and the quarry account is opened wider than it was.", -0.40, nil),
        ("The masons walk out", "A dispute over lodge wages. The heaviest work waits until it is settled.", 0.22, "compound"),
        ("Timber from the abbot", "Enough good oak for the centering arrives free, which is half the cost of turning an arch.", -0.30, nil),
        ("The old bishop objects", "He has views about ornament and he is not dead yet. The showiest work is off the table this season.", 0.0, "crocketed"),
        ("Plague in the town", "Half the lodge is gone by Michaelmas. What gets built is what the fewest hands can build.", 0.28, "fan"),
        ("A good year at the mill", "The chapter's own revenues are up and they are minded to spend some of it here.", -0.24, nil),
        ("Settlement in the crossing", "The ground has moved under the last work. Nothing has fallen, but it has to be made good.", 0.32, nil),
        ("A fire in the town", "The lodge lends men and carts to the townspeople for a month. Nobody says no.", 0.20, nil),
        ("The king passes through", "A royal visit, and a royal gift with it. It does not cover everything, but it covers something.", -0.28, nil),
    ]

    static let remarks = [
        "Five seasons and a grant of stone. What you do not spend on the piers you may spend overhead.",
        "The chapter has read your last account and will read this one too.",
        "The old church is coming down as you build. There is no going back to it.",
        "The foundations are already in and they are what they are. Build to them.",
        "A rival lodge is at work forty miles away and the chapter knows exactly how high it is.",
        "You have the quarry, the men and five summers. The rest is arithmetic and nerve.",
        "The last master left the work unfinished and no drawings. This is now yours.",
        "The relics arrive in five years whether the vault is on or not.",
    ]

    static func campaign(day: Int) -> Campaign {
        var rng = StoneSpin(day &* 4093 &+ 11)
        let prog = programmes[rng.pick(programmes.count)]
        let wishes: [ChapterWish] = [.height, .light, .thrift, .permanence]
        let wish = wishes[rng.pick(wishes.count)]

        var picked: [SeasonEvent] = []
        var used = Set<Int>()
        for k in 0..<5 {
            var idx = rng.pick(events.count)
            var guardCount = 0
            while used.contains(idx) && guardCount < 60 {
                idx = rng.pick(events.count)
                guardCount += 1
            }
            used.insert(idx)
            let e = events[idx]
            picked.append(SeasonEvent(season: seasonNames[k], title: e.0, note: e.1,
                                      stoneDelta: e.2, banned: e.3))
        }

        let drift = picked.reduce(0.0) { $0 + $1.stoneDelta }
        let grant = (baselineStone(prog) + drift + rng.range(0.30, 1.10))
        return Campaign(dayIndex: day, programme: prog, wish: wish,
                        stoneGrant: (grant * 100).rounded() / 100,
                        events: picked,
                        remark: remarks[abs(day) % remarks.count])
    }
}

func baselineStone(_ p: Programme) -> Double {
    let cheapest = Design(programme: p,
                          pier: pierChoices.min { $0.stone < $1.stone } ?? pierChoices[0],
                          arch: archChoices[0],
                          vault: vaultChoices.min { $0.stone < $1.stone } ?? vaultChoices[0],
                          buttress: buttressChoices.min { $0.stone < $1.stone }
                            ?? buttressChoices[0],
                          pinnacle: pinnacleChoices.min { $0.stone < $1.stone }
                            ?? pinnacleChoices[0])
    let dearest = Design(programme: p,
                         pier: pierChoices.max { $0.stone < $1.stone } ?? pierChoices[0],
                         arch: archChoices[0],
                         vault: vaultChoices.max { $0.stone < $1.stone } ?? vaultChoices[0],
                         buttress: buttressChoices.max { $0.stone < $1.stone }
                            ?? buttressChoices[0],
                         pinnacle: pinnacleChoices.max { $0.stone < $1.stone }
                            ?? pinnacleChoices[0])
    let low = analyse(cheapest).stoneUsed
    let high = analyse(dearest).stoneUsed
    return low + (high - low) * 0.46
}

struct Campaign {
    let dayIndex: Int
    let programme: Programme
    let wish: ChapterWish
    let stoneGrant: Double
    let events: [SeasonEvent]
    let remark: String
}

struct SeasonOutcome {
    let analysis: Analysis
    let stoneSpent: Double
    let overspend: Double
    let wishMet: Bool
    let stands: Bool
    let stars: Int
    let grade: String
    let title: String
    let note: String
}

func seasonStone(_ campaign: Campaign, _ design: Design) -> Double {
    let base = analyse(design).stoneUsed
    let drift = campaign.events.reduce(0.0) { $0 + $1.stoneDelta }
    return ((base + drift * 0.5) * 100).rounded() / 100
}

func settleCampaign(_ campaign: Campaign, _ design: Design) -> SeasonOutcome {
    let a = analyse(design)
    let spent = seasonStone(campaign, design)
    let over = max(0.0, spent - campaign.stoneGrant)
    let stands = a.verdict == .safe || a.verdict == .cracked

    var wishMet = false
    switch campaign.wish {
    case .height:
        wishMet = stands && design.arch.pointed >= 0.55
            && a.rise >= design.programme.span * 0.68
    case .light:
        wishMet = stands && a.light >= 0.62
    case .thrift:
        wishMet = stands && over <= 0.001
    case .permanence:
        wishMet = a.verdict == .safe
    }

    let grade = masterGrade(a, design)
    var stars = 0
    if stands {
        stars = 1
        if wishMet { stars = 2 }
        if wishMet && over <= 0.001 && a.verdict == .safe { stars = 3 }
    }

    let title: String
    let note: String
    if !stands {
        title = a.verdict.title
        note = verdictComment(a, design) + " The chapter has the work down and started again, and your name is on the old account."
    } else if over > 0.001 {
        title = "It stands, and it is over the grant"
        note = String(format: "The fabric is sound but you are %.2f over what the chapter granted. That conversation happens whether the vault is beautiful or not.", over)
    } else if !wishMet {
        title = "Sound, but not what was asked"
        note = "Nothing here will fall down. It is simply not the church the chapter described when they gave you the work. " + campaign.wish.detail
    } else if stars >= 3 {
        title = "Exactly the church they asked for"
        note = "Standing clean, inside the grant, and doing the thing the chapter wanted from it. This is what a master's account looks like."
    } else {
        title = "The chapter is satisfied"
        note = "The work does what was asked of it. A crack in the fabric or a season's overspend is the difference between this and a master's account."
    }

    return SeasonOutcome(analysis: a, stoneSpent: spent, overspend: over,
                         wishMet: wishMet, stands: stands, stars: stars,
                         grade: grade, title: title, note: note)
}

func availablePiers(_ e: SeasonEvent) -> [PierChoice] {
    pierChoices.filter { $0.slug != e.banned }
}

func availableArches(_ e: SeasonEvent) -> [ArchChoice] {
    archChoices.filter { $0.slug != e.banned }
}

func availableVaults(_ e: SeasonEvent) -> [VaultChoice] {
    let out = vaultChoices.filter { $0.slug != e.banned }
    return out.isEmpty ? vaultChoices : out
}

func availableButtresses(_ e: SeasonEvent) -> [ButtressChoice] {
    let out = buttressChoices.filter { $0.slug != e.banned }
    return out.isEmpty ? buttressChoices : out
}

func availablePinnacles(_ e: SeasonEvent) -> [PinnacleChoice] {
    let out = pinnacleChoices.filter { $0.slug != e.banned }
    return out.isEmpty ? pinnacleChoices : out
}
