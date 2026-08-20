import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: LodgeStore

    @State private var now: Date = Date()
    @State private var building: Bool = false

    private let clock = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var day: Int { StoneDay.index(for: now) }
    private var campaign: Campaign { SeasonSeeds.campaign(day: day) }
    private var done: SeasonRecord? { store.season(for: day) }
    private var standing: (rank: LodgeRank, next: LodgeRank?, progress: Double) {
        lodgeRankFor(points: store.lodgePoints)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                RisingCard(index: 0) { scene }
                RisingCard(index: 1) { heading }
                RisingCard(index: 2) {
                    if let rec = done { finishedCard(rec) } else { commissionCard }
                }
                RisingCard(index: 3) { standingCard }
                if !store.seasons.isEmpty {
                    RisingCard(index: 4) { historyCard }
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .centreColumn()
        .onReceive(clock) { t in now = t }
        .onAppear { now = Date() }
        .fullScreenCover(isPresented: $building) {
            SeasonView(campaign: campaign) { outcome, design in
                store.recordSeason(SeasonRecord(id: UUID().uuidString, dayIndex: day,
                                                programme: campaign.programme.slug,
                                                wish: campaign.wish.rawValue,
                                                verdict: outcome.analysis.verdict.rawValue,
                                                grade: outcome.grade,
                                                stoneSpent: outcome.stoneSpent,
                                                stoneGrant: campaign.stoneGrant,
                                                wishMet: outcome.wishMet,
                                                stars: outcome.stars))
                store.record(BuiltChurch(id: UUID().uuidString,
                                         programme: campaign.programme.slug,
                                         pier: design.pier.slug, arch: design.arch.slug,
                                         vault: design.vault.slug,
                                         buttress: design.buttress.slug,
                                         pinnacle: design.pinnacle.slug,
                                         height: campaign.programme.vaultHeight,
                                         verdict: outcome.analysis.verdict.rawValue,
                                         grade: outcome.grade,
                                         light: outcome.analysis.light,
                                         elegance: outcome.analysis.elegance,
                                         eccentricity: outcome.analysis.eccentricity,
                                         middleThird: outcome.analysis.middleThird,
                                         stamp: Double(day)))
                store.markElement(design.vault.slug)
                store.markElement(design.buttress.slug)
                building = false
            } onLeave: {
                building = false
            }
        }
    }

    private var scene: some View {
        ZStack(alignment: .bottomLeading) {
            NaveScene(hour: StoneDay.hour(for: now), seed: day,
                      pointed: 0.24 + Double(abs(day) % 4) * 0.22)
                .frame(height: StoneMetrics.isPad ? 230 : 168)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Stone.ink.opacity(0.28), lineWidth: 1))

            HStack(spacing: 8) {
                Text(naveLight(hour: StoneDay.hour(for: now)).caption.uppercased())
                    .font(StoneFont.title(11)).tracking(1.8)
                    .foregroundColor(.white.opacity(0.92))
                Text(String(format: "%02d:%02d", Int(StoneDay.hour(for: now)),
                            Int((StoneDay.hour(for: now)
                                    .truncatingRemainder(dividingBy: 1)) * 60)))
                    .font(StoneFont.mono(12))
                    .foregroundColor(.white.opacity(0.78))
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.black.opacity(0.42)))
            .padding(12)
        }
        .padding(.top, 10)
    }

    private var heading: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(StoneDay.title(for: now))
                .font(StoneFont.title(24))
                .foregroundColor(Stone.ink)
            Text("\(campaign.programme.name) · five seasons · \(String(format: "%.2f", campaign.stoneGrant)) of stone granted")
                .font(StoneFont.italic(14))
                .foregroundColor(Stone.inkPale)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var commissionCard: some View {
        StoneCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Today's commission".uppercased())
                        .font(StoneFont.title(12)).tracking(2.2)
                        .foregroundColor(Stone.inkPale)
                    Spacer()
                    Chip(text: campaign.wish.short, tone: Stone.amber)
                }
                Text(campaign.wish.headline)
                    .font(StoneFont.title(19))
                    .foregroundColor(Stone.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(campaign.wish.detail)
                    .font(StoneFont.body(14))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                RuleLine()
                Text(campaign.remark)
                    .font(StoneFont.body(13))
                    .foregroundColor(Stone.inkPale)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 8) {
                    StatBlock(value: String(format: "%.1f m", campaign.programme.span),
                              caption: "span")
                    StatBlock(value: String(format: "%.0f m", campaign.programme.vaultHeight),
                              caption: "vault height")
                    StatBlock(value: String(format: "%.2f", campaign.stoneGrant),
                              caption: "stone granted", tone: Stone.amber)
                }
                StoneButton(title: "Open the first season") {
                    StoneFeel.tap()
                    building = true
                }
            }
        }
    }

    private func finishedCard(_ rec: SeasonRecord) -> some View {
        let stands = rec.verdict == "safe" || rec.verdict == "cracked"
        return StoneCard(tone: stands ? Stone.moss.opacity(0.10)
                                      : Stone.oxblood.opacity(0.10)) {
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    Text("Today's account is closed".uppercased())
                        .font(StoneFont.title(12)).tracking(2.0)
                        .foregroundColor(Stone.inkSoft)
                    Spacer()
                    StarRow(earned: rec.stars, size: 14)
                }
                HStack(spacing: 8) {
                    StatBlock(value: rec.grade, caption: "the lodge's verdict",
                              tone: stands ? Stone.moss : Stone.oxblood)
                    StatBlock(value: String(format: "%.2f", rec.stoneSpent),
                              caption: "stone spent", tone: Stone.amber)
                    StatBlock(value: rec.wishMet ? "Met" : "Missed",
                              caption: "the chapter's wish")
                }
                Text("A new chapter, a new programme and five fresh seasons arrive with the morning. The streak holds as long as you close an account every day.")
                    .font(StoneFont.body(14))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var standingCard: some View {
        let s = standing
        return StoneCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text(s.rank.name)
                        .font(StoneFont.title(21))
                        .foregroundColor(Stone.ink)
                    Spacer()
                    Text("\(store.lodgePoints) pts")
                        .font(StoneFont.mono(13))
                        .foregroundColor(Stone.inkPale)
                }
                Text(s.rank.note)
                    .font(StoneFont.italic(14))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                ProgressBarline(fraction: s.progress)
                if let n = s.next {
                    Text("\(n.threshold - store.lodgePoints) points to \(n.name)".uppercased())
                        .font(StoneFont.body(11)).tracking(1.4)
                        .foregroundColor(Stone.inkPale)
                } else {
                    Text("The top of the lodge. Nothing above this.".uppercased())
                        .font(StoneFont.body(11)).tracking(1.4)
                        .foregroundColor(Stone.amber)
                }
                RuleLine()
                HStack(spacing: 8) {
                    StatBlock(value: "\(store.liveStreak)", caption: "streak")
                    StatBlock(value: "\(store.bestStreak)", caption: "best streak",
                              tone: Stone.amber)
                    StatBlock(value: "\(store.accountsClosed)", caption: "accounts closed")
                }
            }
        }
    }

    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHead(text: "Recent accounts")
            VStack(spacing: 8) {
                ForEach(store.seasons.suffix(5).reversed()) { rec in
                    HStack {
                        StarRow(earned: rec.stars, size: 12)
                        Text(rec.grade)
                            .font(StoneFont.body(14))
                            .foregroundColor(Stone.ink)
                            .lineLimit(1)
                        Spacer()
                        Text(String(format: "%.2f / %.2f", rec.stoneSpent, rec.stoneGrant))
                            .font(StoneFont.mono(12))
                            .foregroundColor(rec.stoneSpent <= rec.stoneGrant
                                             ? Stone.moss : Stone.oxblood)
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Stone.card))
                }
            }
        }
    }
}
