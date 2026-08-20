import SwiftUI

enum SitePhase {
    case building, striking, verdict
}

struct SiteView: View {
    @EnvironmentObject var store: LodgeStore

    @State private var phase: SitePhase = .building
    @State private var stage: Int = 0
    @State private var programme = programmes[1]
    @State private var pier = pierChoices[1]
    @State private var arch = archChoices[1]
    @State private var vault = vaultChoices[2]
    @State private var buttress = buttressChoices[2]
    @State private var pinnacle = pinnacleChoices[1]
    @State private var built: Set<String> = []
    @State private var animPhase: Double = 0
    @State private var saved = false

    private let ticker = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    private var design: Design {
        Design(programme: programme, pier: pier, arch: arch, vault: vault,
               buttress: buttress, pinnacle: pinnacle)
    }
    private var analysis: Analysis { analyse(design) }

    var body: some View {
        ZStack {
            Stone.paper.ignoresSafeArea()
            switch phase {
            case .building: buildingScreen
            case .striking, .verdict: verdictScreen
            }
        }
        .onReceive(ticker) { _ in
            if phase == .striking {
                animPhase = min(1.0, animPhase + 0.022)
                if animPhase >= 1.0 { phase = .verdict }
            }
        }
    }

    private var buildingScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cathedral Stone")
                        .font(StoneFont.title(29))
                        .foregroundColor(Stone.ink)
                    Text("Build it course by course and see where the load goes")
                        .font(StoneFont.italic(15))
                        .foregroundColor(Stone.inkPale)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 12)

                sectionPanel

                HStack {
                    Text("Stage \(stage + 1) of \(buildStages.count)".uppercased())
                        .font(StoneFont.body(11)).tracking(1.8)
                        .foregroundColor(Stone.inkPale)
                    Spacer()
                    Chip(text: buildStages[stage].title, tone: Stone.amber)
                }
                ProgressBarline(fraction: Double(stage) / Double(buildStages.count),
                                tone: Stone.amber)

                Text(buildStages[stage].question)
                    .font(StoneFont.title(23))
                    .foregroundColor(Stone.ink)
                    .fixedSize(horizontal: false, vertical: true)

                choiceList

                if stage > 0 {
                    StoneButton(title: "Back a stage", kind: .quiet) {
                        stage -= 1
                        built.remove(buildStages[stage].key)
                    }
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 40)
        }
        .centreColumn()
    }

    private var sectionPanel: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14).fill(Stone.card)
            SectionView(design: design, analysis: analysis, built: built,
                        showThrust: false)
                .padding(10)
            Text("SECTION THROUGH ONE BAY")
                .font(StoneFont.body(9)).tracking(1.6)
                .foregroundColor(Stone.inkPale)
                .padding(12)
        }
        .frame(height: StoneMetrics.isPad ? 320 : 240)
        .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Stone.ink.opacity(0.16), lineWidth: 1))
    }

    @ViewBuilder
    private var choiceList: some View {
        switch buildStages[stage].key {
        case "programme":
            ForEach(programmes) { p in
                choiceRow(title: p.name,
                          sub: String(format: "span %.0f m · vault %.0f m", p.span, p.vaultHeight),
                          note: p.note, plate: nil, selected: p.slug == programme.slug) {
                    programme = p
                    advance("programme")
                }
            }
        case "pier":
            ForEach(pierChoices) { c in
                choiceRow(title: c.name,
                          sub: String(format: "%.1f m thick", c.thickness),
                          note: c.note, plate: c.plate, selected: c.slug == pier.slug) {
                    pier = c
                    advance("pier")
                }
            }
        case "arch":
            ForEach(archChoices) { c in
                choiceRow(title: c.name,
                          sub: c.pointed < 0.1 ? "rise fixed at half the span"
                                               : String(format: "rises %.0f%% higher", c.pointed * 62),
                          note: c.note, plate: c.plate, selected: c.slug == arch.slug) {
                    arch = c
                    advance("arch")
                }
            }
        case "vault":
            ForEach(vaultChoices) { c in
                choiceRow(title: c.name,
                          sub: String(format: "%.0f kN per metre of span", c.weight),
                          note: c.note, plate: c.plate, selected: c.slug == vault.slug) {
                    vault = c
                    advance("vault")
                }
            }
        case "buttress":
            ForEach(buttressChoices) { c in
                choiceRow(title: c.name,
                          sub: String(format: "base %.1f m", c.base),
                          note: c.note, plate: c.plate, selected: c.slug == buttress.slug) {
                    buttress = c
                    advance("buttress")
                }
            }
        default:
            ForEach(pinnacleChoices) { c in
                choiceRow(title: c.name,
                          sub: c.weight < 1 ? "no added weight"
                                            : String(format: "%.0f kN on the pier", c.weight),
                          note: c.note, plate: nil, selected: c.slug == pinnacle.slug) {
                    pinnacle = c
                    built.insert("pinnacle")
                    animPhase = 0
                    phase = .striking
                }
            }
        }
    }

    private func advance(_ key: String) {
        built.insert(key)
        if key == "programme" { built.insert("programme") }
        if stage + 1 < buildStages.count { stage += 1 }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func choiceRow(title: String, sub: String, note: String, plate: String?,
                           selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                if let p = plate {
                    Plate(name: p, corner: 8, anchor: .center)
                        .frame(width: 76, height: 76)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(Stone.cardSunk)
                            .frame(width: 76, height: 76)
                        ArchGlyph(size: 44, colour: Stone.limeDark)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(StoneFont.title(17))
                        .foregroundColor(Stone.ink)
                        .multilineTextAlignment(.leading)
                    Text(sub.uppercased())
                        .font(StoneFont.body(10)).tracking(1.4)
                        .foregroundColor(Stone.amber)
                    Text(note)
                        .font(StoneFont.body(13))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selected ? Stone.amber.opacity(0.10) : Stone.card))
            .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(selected ? Stone.amber.opacity(0.6) : Stone.ink.opacity(0.16),
                                lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var verdictColour: Color {
        switch analysis.verdict {
        case .safe: return Stone.moss
        case .cracked: return Stone.amber
        default: return Stone.oxblood
        }
    }

    private var verdictScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(phase == .striking ? "Striking the centring" : analysis.verdict.title)
                    .font(StoneFont.title(27))
                    .foregroundColor(phase == .striking ? Stone.ink : verdictColour)
                    .padding(.top, 14)
                    .fixedSize(horizontal: false, vertical: true)

                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 14).fill(Stone.card)
                    SectionView(design: design, analysis: analysis,
                                built: ["programme", "pier", "arch", "vault",
                                        "buttress", "pinnacle"],
                                showThrust: true, phase: animPhase)
                        .padding(10)
                    Text("THE LINE OF THRUST")
                        .font(StoneFont.body(9)).tracking(1.6)
                        .foregroundColor(verdictColour)
                        .padding(12)
                }
                .frame(height: StoneMetrics.isPad ? 380 : 290)
                .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Stone.ink.opacity(0.16), lineWidth: 1))

                if phase == .verdict {
                    StoneCard(tone: verdictColour.opacity(0.10)) {
                        Text(verdictComment(analysis, design))
                            .font(StoneFont.body(15))
                            .foregroundColor(Stone.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    StoneCard {
                        VStack(spacing: 11) {
                            row("Vault load", String(format: "%.0f kN per metre", analysis.vaultLoad))
                            RuleLine()
                            row("Horizontal thrust", String(format: "%.0f kN", analysis.thrust))
                            RuleLine()
                            row("Buttress weight", String(format: "%.0f kN", analysis.buttressWeight
                                                          + analysis.pinnacleWeight))
                            RuleLine()
                            row("Thrust falls off centre", String(format: "%.2f m", analysis.eccentricity))
                            RuleLine()
                            row("Middle third ends at", String(format: "%.2f m", analysis.middleThird))
                            RuleLine()
                            row("Pier stress", String(format: "%.0f%% of capacity",
                                                      analysis.pierStress * 100))
                        }
                    }

                    StoneCard(tone: Stone.cardSunk) {
                        VStack(spacing: 12) {
                            meter("Light", analysis.light, Stone.glassGold)
                            meter("Elegance", analysis.elegance, Stone.glassBlue)
                            meter("Economy", max(0, 1 - analysis.stoneUsed / 6.0), Stone.limeDark)
                        }
                    }

                    HStack(spacing: 8) {
                        Chip(text: masterGrade(analysis, design), tone: verdictColour, solid: true)
                        Chip(text: String(format: "%.0f m vault", programme.vaultHeight),
                             tone: Stone.amber)
                    }

                    StoneButton(title: saved ? "Begin another" : "Enter it in the fabric roll") {
                        if !saved { saveIt() }
                        phase = .building
                        stage = 0
                        built = []
                        animPhase = 0
                        saved = false
                    }
                    StoneButton(title: "Change one thing", kind: .secondary) {
                        phase = .building
                        stage = buildStages.count - 1
                        built.remove("pinnacle")
                        animPhase = 0
                    }
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 40)
        }
        .centreColumn()
    }

    private func row(_ k: String, _ v: String) -> some View {
        HStack {
            Text(k.uppercased())
                .font(StoneFont.body(11)).tracking(1.6)
                .foregroundColor(Stone.inkPale)
            Spacer()
            Text(v).font(StoneFont.mono(15)).foregroundColor(Stone.ink)
        }
    }

    private func meter(_ name: String, _ value: Double, _ tone: Color) -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(name.uppercased())
                    .font(StoneFont.body(11)).tracking(1.6)
                    .foregroundColor(Stone.inkPale)
                Spacer()
                Text(String(format: "%.0f%%", value * 100))
                    .font(StoneFont.mono(14))
                    .foregroundColor(Stone.ink)
            }
            ProgressBarline(fraction: value, tone: tone, height: 6)
        }
    }

    private func saveIt() {
        store.record(BuiltChurch(id: UUID().uuidString,
                                 programme: programme.slug,
                                 pier: pier.slug, arch: arch.slug, vault: vault.slug,
                                 buttress: buttress.slug, pinnacle: pinnacle.slug,
                                 height: programme.vaultHeight,
                                 verdict: analysis.verdict.rawValue,
                                 grade: masterGrade(analysis, design),
                                 light: analysis.light, elegance: analysis.elegance,
                                 eccentricity: analysis.eccentricity,
                                 middleThird: analysis.middleThird,
                                 stamp: Double(store.churches.count)))
        saved = true
    }
}
