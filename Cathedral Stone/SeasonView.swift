import SwiftUI

struct SeasonView: View {
    let campaign: Campaign
    let onFinish: (SeasonOutcome, Design) -> Void
    let onLeave: () -> Void

    @State private var season: Int = 0
    @State private var pier: PierChoice = pierChoices[0]
    @State private var arch: ArchChoice = archChoices[0]
    @State private var vault: VaultChoice = vaultChoices[0]
    @State private var buttress: ButtressChoice = buttressChoices[0]
    @State private var pinnacle: PinnacleChoice = pinnacleChoices[0]
    @State private var pinned: Design? = nil
    @State private var settled: Bool = false
    @State private var collapse: Double = 0
    @State private var started = false

    private var design: Design {
        Design(programme: campaign.programme, pier: pier, arch: arch,
               vault: vault, buttress: buttress, pinnacle: pinnacle)
    }

    private var built: Set<String> {
        var out: Set<String> = ["programme"]
        out.insert("pier")
        if season >= 1 { out.insert("arch") }
        if season >= 2 { out.insert("vault") }
        if season >= 3 { out.insert("buttress") }
        if season >= 4 { out.insert("pinnacle") }
        if settled { out = ["programme", "pier", "arch", "vault", "buttress", "pinnacle"] }
        return out
    }

    private var outcome: SeasonOutcome { settleCampaign(campaign, design) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SheetHeader(title: settled ? "The account"
                                           : seasonNames[min(season, 4)],
                            subtitle: campaign.programme.name) { onLeave() }
                    .padding(.top, 12)

                if settled {
                    settledBody
                } else {
                    workingBody
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 40)
        }
        .stonePage()
        .centreColumn()
        .onAppear {
            guard !started else { return }
            started = true
            pier = availablePiers(campaign.events[0]).first ?? pierChoices[0]
            arch = availableArches(campaign.events[1]).first ?? archChoices[0]
            vault = availableVaults(campaign.events[2]).first ?? vaultChoices[0]
            buttress = availableButtresses(campaign.events[3]).first ?? buttressChoices[0]
            pinnacle = availablePinnacles(campaign.events[4]).first ?? pinnacleChoices[0]
        }
    }

    private var workingBody: some View {
        let event = campaign.events[min(season, 4)]
        return VStack(alignment: .leading, spacing: 15) {
            StoneCard(tone: event.stoneDelta > 0 ? Stone.oxblood.opacity(0.09)
                                                 : Stone.moss.opacity(0.09)) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(event.title)
                            .font(StoneFont.title(18))
                            .foregroundColor(Stone.ink)
                        Spacer()
                        Chip(text: event.stoneDelta > 0
                             ? String(format: "+%.2f stone", event.stoneDelta)
                             : (event.stoneDelta < 0
                                ? String(format: "%.2f stone", event.stoneDelta)
                                : "No change"),
                             tone: event.stoneDelta > 0 ? Stone.oxblood : Stone.moss)
                    }
                    Text(event.note)
                        .font(StoneFont.body(14))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            StoneCard(padding: 10) {
                SectionView(design: design, analysis: analyse(design),
                            built: built, showThrust: season >= 2)
                    .frame(height: StoneMetrics.isPad ? 300 : 216)
            }

            ledgerStrip

            StoneCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(stageQuestion.uppercased())
                        .font(StoneFont.title(12)).tracking(2.0)
                        .foregroundColor(Stone.inkPale)
                    choicesForStage(event)
                }
            }

            compareCard

            HStack(spacing: 10) {
                if season > 0 {
                    StoneButton(title: "Back a season", kind: .quiet) {
                        withAnimation(.easeOut(duration: 0.25)) { season -= 1 }
                    }
                }
                StoneButton(title: season >= 4 ? "Close the account"
                                               : "Winter, and on to the next") {
                    StoneFeel.tap()
                    if season >= 4 {
                        let o = outcome
                        StoneFeel.land(o.stars)
                        withAnimation(.easeOut(duration: 0.3)) { settled = true }
                        if !o.stands {
                            withAnimation(.easeIn(duration: 1.5).delay(0.35)) {
                                collapse = 1
                            }
                        }
                    } else {
                        withAnimation(.easeOut(duration: 0.25)) { season += 1 }
                    }
                }
            }
        }
    }

    private var stageQuestion: String {
        switch season {
        case 0: return "What will carry it?"
        case 1: return "What shape are the arches?"
        case 2: return "What goes overhead?"
        case 3: return "Where does the thrust go?"
        default: return "What sits on the buttress pier?"
        }
    }

    @ViewBuilder
    private func choicesForStage(_ e: SeasonEvent) -> some View {
        switch season {
        case 0:
            VStack(spacing: 8) {
                ForEach(availablePiers(e)) { c in
                    optionRow(c.name, c.note, String(format: "%.2f stone", c.stone),
                              pier.slug == c.slug) { StoneFeel.tick(); pier = c }
                }
            }
        case 1:
            VStack(spacing: 8) {
                ForEach(availableArches(e)) { c in
                    optionRow(c.name, c.note, String(format: "%.0f%% pointed",
                                                     c.pointed * 100),
                              arch.slug == c.slug) { StoneFeel.tick(); arch = c }
                }
            }
        case 2:
            VStack(spacing: 8) {
                ForEach(availableVaults(e)) { c in
                    optionRow(c.name, c.note, String(format: "%.2f stone", c.stone),
                              vault.slug == c.slug) { StoneFeel.tick(); vault = c }
                }
            }
        case 3:
            VStack(spacing: 8) {
                ForEach(availableButtresses(e)) { c in
                    optionRow(c.name, c.note, String(format: "%.2f stone", c.stone),
                              buttress.slug == c.slug) { StoneFeel.tick(); buttress = c }
                }
            }
        default:
            VStack(spacing: 8) {
                ForEach(availablePinnacles(e)) { c in
                    optionRow(c.name, c.note, String(format: "%.2f stone", c.stone),
                              pinnacle.slug == c.slug) { StoneFeel.tick(); pinnacle = c }
                }
            }
        }
    }

    private func optionRow(_ name: String, _ note: String, _ cost: String,
                           _ selected: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(StoneFont.title(16))
                        .foregroundColor(Stone.ink)
                    Spacer()
                    Text(cost)
                        .font(StoneFont.mono(12))
                        .foregroundColor(selected ? Stone.amber : Stone.inkPale)
                }
                Text(note)
                    .font(StoneFont.body(13))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 13)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(selected ? Stone.amber.opacity(0.12) : Stone.cardSunk))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(selected ? Stone.amber : Color.clear, lineWidth: 1.6))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var ledgerStrip: some View {
        let spent = seasonStone(campaign, design)
        let over = spent > campaign.stoneGrant
        return StoneCard(tone: over ? Stone.oxblood.opacity(0.08) : Stone.card) {
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text("The quarry account".uppercased())
                        .font(StoneFont.title(11)).tracking(2.0)
                        .foregroundColor(Stone.inkPale)
                    Spacer()
                    Text(String(format: "%.2f of %.2f", spent, campaign.stoneGrant))
                        .font(StoneFont.mono(13))
                        .foregroundColor(over ? Stone.oxblood : Stone.moss)
                }
                ProgressBarline(fraction: spent / max(0.01, campaign.stoneGrant),
                                tone: over ? Stone.oxblood : Stone.moss)
                HStack(spacing: 8) {
                    StatBlock(value: campaign.wish.short, caption: "the chapter wants",
                              tone: Stone.amber)
                    StatBlock(value: String(format: "%.1f m", campaign.programme.span),
                              caption: "span")
                    StatBlock(value: String(format: "%.0f m", campaign.programme.vaultHeight),
                              caption: "vault height")
                }
            }
        }
    }

    private var compareCard: some View {
        StoneCard(tone: Stone.cardSunk) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Two sections side by side".uppercased())
                    .font(StoneFont.title(11)).tracking(2.0)
                    .foregroundColor(Stone.inkPale)
                if let p = pinned {
                    HStack(spacing: 10) {
                        VStack(spacing: 5) {
                            SectionView(design: p, analysis: analyse(p),
                                        built: ["programme", "pier", "arch", "vault",
                                                "buttress", "pinnacle"],
                                        showThrust: true)
                                .frame(height: 150)
                            Text("Pinned".uppercased())
                                .font(StoneFont.title(10)).tracking(1.6)
                                .foregroundColor(Stone.amber)
                            Text(analyse(p).verdict.title)
                                .font(StoneFont.body(12))
                                .foregroundColor(Stone.inkSoft)
                                .multilineTextAlignment(.center)
                        }
                        VStack(spacing: 5) {
                            SectionView(design: design, analysis: analyse(design),
                                        built: ["programme", "pier", "arch", "vault",
                                                "buttress", "pinnacle"],
                                        showThrust: true)
                                .frame(height: 150)
                            Text("On the board".uppercased())
                                .font(StoneFont.title(10)).tracking(1.6)
                                .foregroundColor(Stone.glassBlue)
                            Text(analyse(design).verdict.title)
                                .font(StoneFont.body(12))
                                .foregroundColor(Stone.inkSoft)
                                .multilineTextAlignment(.center)
                        }
                    }
                    StoneButton(title: "Clear the pin", kind: .quiet) { pinned = nil }
                } else {
                    Text("Pin the section as it stands, change a choice, and the two drawings sit beside each other with both thrust lines on them.")
                        .font(StoneFont.body(13))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    StoneButton(title: "Pin this section", kind: .secondary) {
                        StoneFeel.tick()
                        pinned = design
                    }
                }
            }
        }
    }

    private var settledBody: some View {
        let o = outcome
        return VStack(alignment: .leading, spacing: 15) {
            Text(o.title)
                .font(StoneFont.title(25))
                .foregroundColor(Stone.ink)
                .fixedSize(horizontal: false, vertical: true)

            if o.stands {
                StoneCard(padding: 10) {
                    SectionView(design: design, analysis: o.analysis,
                                built: built, showThrust: true)
                        .frame(height: StoneMetrics.isPad ? 340 : 240)
                }
            } else {
                CollapseCanvas(design: design, analysis: o.analysis, progress: collapse)
                    .frame(height: StoneMetrics.isPad ? 340 : 240)
            }

            HStack {
                StarRow(earned: o.stars, size: 17)
                Spacer()
                Chip(text: o.grade, tone: o.stands ? Stone.moss : Stone.oxblood,
                     solid: true)
            }

            StoneCard(tone: Stone.cardSunk) {
                Text(o.note)
                    .font(StoneFont.body(15))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }

            StoneCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("The numbers".uppercased())
                        .font(StoneFont.title(11)).tracking(2.0)
                        .foregroundColor(Stone.inkPale)
                    numberRow("Thrust at the springing",
                              String(format: "%.0f kN", o.analysis.thrust))
                    numberRow("Line falls from the centre",
                              String(format: "%.2f m", o.analysis.eccentricity))
                    numberRow("Middle third ends at",
                              String(format: "%.2f m", o.analysis.middleThird))
                    numberRow("Base of the buttress",
                              String(format: "%.2f m", o.analysis.baseWidth))
                    numberRow("Pier working at",
                              String(format: "%.0f%% of capacity", o.analysis.pierStress * 100))
                    numberRow("Stone spent",
                              String(format: "%.2f of %.2f granted",
                                     o.stoneSpent, campaign.stoneGrant))
                    numberRow("The chapter asked for",
                              campaign.wish.short + (o.wishMet ? " — met" : " — not met"))
                }
            }

            StoneButton(title: "Enter it in the rolls") { onFinish(o, design) }
        }
    }

    private func numberRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(StoneFont.body(14))
                .foregroundColor(Stone.inkSoft)
            Spacer(minLength: 10)
            Text(value)
                .font(StoneFont.mono(12))
                .foregroundColor(Stone.ink)
                .multilineTextAlignment(.trailing)
        }
    }
}
