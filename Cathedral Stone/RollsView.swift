import SwiftUI

struct RollsView: View {
    @EnvironmentObject var store: LodgeStore
    @State private var showAwards = false
    @State private var showAbout = false
    @State private var confirmReset = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("The Fabric Roll")
                        .font(StoneFont.title(29))
                        .foregroundColor(Stone.ink)
                    Text("What was set out, what stood, and what came down")
                        .font(StoneFont.italic(15))
                        .foregroundColor(Stone.inkPale)
                }
                .padding(.top, 12)

                StoneCard {
                    VStack(spacing: 14) {
                        HStack {
                            StatBlock(value: "\(store.churches.count)", caption: "designs")
                            StatBlock(value: "\(store.standing)", caption: "stood", tone: Stone.moss)
                            StatBlock(value: "\(store.collapses)", caption: "came down",
                                      tone: Stone.oxblood)
                        }
                        RuleLine()
                        HStack {
                            StatBlock(value: "\(store.uncracked)", caption: "not a joint open",
                                      tone: Stone.moss)
                            StatBlock(value: store.tallestStanding > 0
                                      ? String(format: "%.0f m", store.tallestStanding) : "—",
                                      caption: "tallest standing", tone: Stone.amber)
                            StatBlock(value: store.bestLight.map { String(format: "%.0f%%", $0 * 100) } ?? "—",
                                      caption: "most light", tone: Stone.glassGold)
                        }
                    }
                }

                Button(action: { showAwards = true }) {
                    HStack(spacing: 12) {
                        ArchGlyph(size: 26, colour: Stone.amber)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Certificates")
                                .font(StoneFont.title(17))
                                .foregroundColor(Stone.ink)
                            Text("\(store.awards.count) of \(allAwards.count) earned")
                                .font(StoneFont.body(13))
                                .foregroundColor(Stone.inkPale)
                        }
                        Spacer()
                        ChevronMark(size: 15)
                    }
                    .padding(13)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Stone.card))
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Stone.ink.opacity(0.16), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())

                SectionHead(text: "Height against outcome")
                HeightChart(churches: store.churches.suffix(24).map { $0 })
                    .frame(height: 150)

                SectionHead(text: "Recent work")
                if store.churches.isEmpty {
                    StoneCard(tone: Stone.cardSunk) {
                        Text("The roll is empty. Nothing goes on it until the centring has been struck.")
                            .font(StoneFont.body(15))
                            .foregroundColor(Stone.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else {
                    VStack(spacing: 7) {
                        ForEach(store.churches.suffix(30).reversed()) { c in
                            HStack(spacing: 10) {
                                Text(String(format: "%.0f m", c.height))
                                    .font(StoneFont.mono(13))
                                    .foregroundColor(Stone.inkSoft)
                                    .frame(width: 46, alignment: .leading)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(programme(c.programme).name)
                                        .font(StoneFont.body(15))
                                        .foregroundColor(Stone.ink)
                                    Text(element(c.vault).title)
                                        .font(StoneFont.body(11))
                                        .foregroundColor(Stone.inkPale)
                                        .lineLimit(1)
                                }
                                Spacer(minLength: 0)
                                Chip(text: c.grade,
                                     tone: c.perfect ? Stone.moss
                                        : (c.stands ? Stone.amber : Stone.oxblood))
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Stone.card))
                        }
                    }
                }

                SectionHead(text: "This lodge")
                StoneButton(title: "About Cathedral Stone", kind: .secondary) { showAbout = true }
                StoneButton(title: confirmReset ? "Tap again to clear the roll" : "Clear the roll",
                            kind: .danger) {
                    if confirmReset {
                        store.resetProgress()
                        confirmReset = false
                    } else {
                        confirmReset = true
                    }
                }
                if confirmReset {
                    StoneButton(title: "Keep the roll", kind: .quiet) { confirmReset = false }
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .centreColumn()
        .sheet(isPresented: $showAwards) {
            AwardsView { showAwards = false }.environmentObject(store)
        }
        .sheet(isPresented: $showAbout) {
            AboutView { showAbout = false }
        }
    }
}

struct HeightChart: View {
    let churches: [BuiltChurch]

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                let rect = CGRect(origin: .zero, size: size)
                let w = rect.width, h = rect.height
                ctx.fill(Path(roundedRect: rect, cornerRadius: 12), with: .color(Stone.card))

                for (v, name) in [(46.0, "Beauvais"), (34.0, "Cathedral"), (16.0, "Parish")] {
                    let y = h - CGFloat(v / 52.0) * (h - 44) - 22
                    var line = Path()
                    line.move(to: CGPoint(x: 12, y: y))
                    line.addLine(to: CGPoint(x: w - 74, y: y))
                    ctx.stroke(line, with: .color(Stone.ink.opacity(0.18)),
                               style: StrokeStyle(lineWidth: 1, dash: [4, 5]))
                    ctx.draw(Text(name).font(StoneFont.body(10))
                                .foregroundColor(Stone.inkPale),
                             at: CGPoint(x: w - 36, y: y))
                }

                guard !churches.isEmpty else {
                    ctx.draw(Text("Nothing set out yet").font(StoneFont.body(13))
                                .foregroundColor(Stone.inkPale),
                             at: CGPoint(x: w / 2, y: h / 2))
                    return
                }

                let step = churches.count > 1 ? (w - 92) / CGFloat(churches.count - 1) : 0
                for (i, c) in churches.enumerated() {
                    let x = 16 + CGFloat(i) * step
                    let y = h - CGFloat(c.height / 52.0) * (h - 44) - 22
                    let colour: Color = c.perfect ? Stone.moss
                        : (c.stands ? Stone.amber : Stone.oxblood)
                    var stem = Path()
                    stem.move(to: CGPoint(x: x, y: h - 22))
                    stem.addLine(to: CGPoint(x: x, y: y))
                    ctx.stroke(stem, with: .color(colour.opacity(0.45)),
                               style: StrokeStyle(lineWidth: 2))
                    ctx.fill(Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                             with: .color(colour))
                }
                var base = Path()
                base.move(to: CGPoint(x: 12, y: h - 22))
                base.addLine(to: CGPoint(x: w - 74, y: h - 22))
                ctx.stroke(base, with: .color(Stone.ink.opacity(0.30)),
                           style: StrokeStyle(lineWidth: 1.4))
            }
            .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Stone.ink.opacity(0.16), lineWidth: 1))
        }
    }
}

struct AwardsView: View {
    let onClose: () -> Void
    @EnvironmentObject var store: LodgeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                SheetHeader(title: "Certificates",
                            subtitle: "\(store.awards.count) of \(allAwards.count) earned",
                            onClose: onClose)
                    .padding(.top, 18)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: StoneMetrics.isPad ? 220 : 158),
                                             spacing: 10)], spacing: 10) {
                    ForEach(allAwards) { award in
                        let earned = store.awards.contains(award.slug)
                        VStack(alignment: .leading, spacing: 7) {
                            ArchGlyph(size: 26,
                                      colour: earned ? Stone.amber : Stone.ink.opacity(0.22))
                            Text(award.name)
                                .font(StoneFont.title(15))
                                .foregroundColor(earned ? Stone.ink : Stone.inkPale)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                            Text(award.requirement)
                                .font(StoneFont.body(12))
                                .foregroundColor(Stone.inkPale)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12)
                                        .fill(earned ? Stone.card : Stone.cardSunk))
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(earned ? Stone.amber.opacity(0.5)
                                            : Stone.ink.opacity(0.12), lineWidth: 1))
                    }
                }
                StoneButton(title: "Close", kind: .secondary, action: onClose)
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
    }
}

struct AboutView: View {
    let onClose: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                SheetHeader(title: "About Cathedral Stone", subtitle: "Version 1.0", onClose: onClose)
                    .padding(.top, 18)

                Plate(name: "scene_lodge")
                    .frame(height: StoneMetrics.isPad ? 300 : 200)

                Text("Cathedral Stone is a drawing board. The chapter gives you a commission — a span and a height — and you choose the piers, the arch shape, the vault, the buttressing and the pinnacle. Then the centring is struck and you watch the line of thrust come down through what you built.")
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)

                Text("The analysis is real, if simplified. Thrust is taken as the load times the span over eight times the rise, so a pointed arch genuinely pushes less than a semicircular one. The buttress is checked by comparing the eccentricity of the resultant against the middle third and against the base, which is the limit analysis masons have used since Coulomb and Heyman wrote it down.")
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)

                Text("So the pinnacle matters exactly as much as it did at Chartres: it is weight added at the top of a buttress pier to steer the thrust line back inside the stone. Take it off a marginal design and watch the line move out.")
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Every plate in the app — the cathedral sections, the element plates, the lesson diagrams and the site scenes — is drawn by the app itself. Nothing is photographed and nothing is downloaded.")
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)

                StoneCard(tone: Stone.cardSunk) {
                    Text("This is a teaching model, not a design tool. A real assessment needs the real geometry, the real stone and an engineer who has stood inside the building.")
                        .font(StoneFont.body(14))
                        .foregroundColor(Stone.inkPale)
                        .fixedSize(horizontal: false, vertical: true)
                }

                StoneButton(title: "Close", kind: .secondary, action: onClose)
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
    }
}
