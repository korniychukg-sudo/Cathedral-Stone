import SwiftUI

struct FabricView: View {
    @EnvironmentObject var store: LodgeStore
    @State private var open: BuiltChurch? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("The Fabric")
                        .font(StoneFont.title(29))
                        .foregroundColor(Stone.ink)
                    Text("Everything you have set out, and what became of it")
                        .font(StoneFont.italic(15))
                        .foregroundColor(Stone.inkPale)
                }
                .padding(.top, 12)

                Plate(name: "scene_westfront")
                    .frame(height: StoneMetrics.isPad ? 240 : 160)

                StoneCard {
                    HStack {
                        StatBlock(value: "\(store.churches.count)", caption: "designs")
                        StatBlock(value: "\(store.standing)", caption: "standing", tone: Stone.moss)
                        StatBlock(value: store.tallestStanding > 0
                                  ? String(format: "%.0f m", store.tallestStanding) : "—",
                                  caption: "tallest", tone: Stone.amber)
                    }
                }

                if store.churches.isEmpty {
                    StoneCard(tone: Stone.cardSunk) {
                        Text("Nothing set out yet. Take a commission from the chapter, choose the piers, arches, vault and buttressing, and strike the centring to see where the load goes.")
                            .font(StoneFont.body(15))
                            .foregroundColor(Stone.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else {
                    SectionHead(text: "On the roll", trailing: "newest first")
                    VStack(spacing: 9) {
                        ForEach(store.churches.reversed()) { c in
                            Button(action: { open = c }) { churchRow(c) }
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .centreColumn()
        .sheet(item: $open) { c in
            ChurchDetailView(church: c) { open = nil }
        }
    }

    private func churchRow(_ c: BuiltChurch) -> some View {
        let tone: Color = c.perfect ? Stone.moss : (c.stands ? Stone.amber : Stone.oxblood)
        return HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 9).fill(Stone.cardSunk)
                    .frame(width: 56, height: 62)
                ArchGlyph(size: 36, colour: tone)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(programme(c.programme).name)
                    .font(StoneFont.title(16))
                    .foregroundColor(Stone.ink)
                Text(String(format: "%.0f m vault · ", c.height) + element(c.vault).title
                     + " · " + element(c.buttress == "butt-none" ? "butt-wall" : c.buttress).title)
                    .font(StoneFont.body(12))
                    .foregroundColor(Stone.inkPale)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
            Chip(text: c.grade, tone: tone)
            ChevronMark(size: 15)
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Stone.card))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Stone.ink.opacity(0.16), lineWidth: 1))
    }
}

struct ChurchDetailView: View {
    let church: BuiltChurch
    let onClose: () -> Void
    @State private var phase: Double = 0
    private let ticker = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    private var design: Design {
        Design(programme: programme(church.programme),
               pier: pierChoices.first { $0.slug == church.pier } ?? pierChoices[0],
               arch: archChoices.first { $0.slug == church.arch } ?? archChoices[0],
               vault: vaultChoices.first { $0.slug == church.vault } ?? vaultChoices[0],
               buttress: buttressChoices.first { $0.slug == church.buttress } ?? buttressChoices[0],
               pinnacle: pinnacleChoices.first { $0.slug == church.pinnacle } ?? pinnacleChoices[0])
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                SheetHeader(title: programme(church.programme).name,
                            subtitle: String(format: "%.0f m vault · %@", church.height, church.grade),
                            onClose: onClose)
                    .padding(.top, 18)

                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(Stone.card)
                    SectionView(design: design, analysis: analyse(design),
                                built: ["programme", "pier", "arch", "vault",
                                        "buttress", "pinnacle"],
                                showThrust: true, phase: phase)
                        .padding(10)
                }
                .frame(height: StoneMetrics.isPad ? 360 : 280)
                .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Stone.ink.opacity(0.16), lineWidth: 1))

                StoneCard {
                    VStack(spacing: 11) {
                        row("Piers", element(church.pier).title)
                        RuleLine()
                        row("Arcade", element(church.arch).title)
                        RuleLine()
                        row("Vault", element(church.vault).title)
                        RuleLine()
                        row("Buttressing", buttressChoices.first { $0.slug == church.buttress }?.name ?? "—")
                        RuleLine()
                        row("Pinnacle", pinnacleChoices.first { $0.slug == church.pinnacle }?.name ?? "—")
                        RuleLine()
                        row("Thrust off centre", String(format: "%.2f m of %.2f m",
                                                        church.eccentricity, church.middleThird))
                    }
                }

                StoneCard(tone: Stone.cardSunk) {
                    Text(verdictComment(analyse(design), design))
                        .font(StoneFont.body(15))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }

                StoneButton(title: "Close", kind: .secondary, action: onClose)
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .onReceive(ticker) { _ in
            if phase < 1.0 { phase = min(1.0, phase + 0.03) }
        }
    }

    private func row(_ k: String, _ v: String) -> some View {
        HStack(alignment: .top) {
            Text(k.uppercased())
                .font(StoneFont.body(11)).tracking(1.6)
                .foregroundColor(Stone.inkPale)
            Spacer(minLength: 10)
            Text(v).font(StoneFont.body(15)).foregroundColor(Stone.ink)
                .multilineTextAlignment(.trailing)
        }
    }
}

enum LodgeSection: Int, CaseIterable {
    case elements, cathedrals, lessons, terms

    var title: String {
        switch self {
        case .elements: return "Elements"
        case .cathedrals: return "Built"
        case .lessons: return "Study"
        case .terms: return "Terms"
        }
    }
}

struct LodgeView: View {
    @EnvironmentObject var store: LodgeStore
    @State private var section: LodgeSection = .elements
    @State private var openElement: ElementEntry? = nil
    @State private var openCathedral: CathedralEntry? = nil
    @State private var openLesson: Lesson? = nil
    @State private var quizOpen = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("The Lodge")
                        .font(StoneFont.title(29))
                        .foregroundColor(Stone.ink)
                    Text("What the masons knew, and how they knew it")
                        .font(StoneFont.italic(15))
                        .foregroundColor(Stone.inkPale)
                }
                .padding(.top, 12)

                picker

                switch section {
                case .elements: elementList
                case .cathedrals: cathedralList
                case .lessons: lessonList
                case .terms: termList
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .centreColumn()
        .sheet(item: $openElement) { e in
            ElementDetailView(entry: e) { openElement = nil }.environmentObject(store)
        }
        .sheet(item: $openCathedral) { c in
            CathedralDetailView(entry: c) { openCathedral = nil }.environmentObject(store)
        }
        .sheet(item: $openLesson) { l in
            LessonDetailView(lesson: l) { openLesson = nil }.environmentObject(store)
        }
        .fullScreenCover(isPresented: $quizOpen) {
            QuizView { quizOpen = false }.environmentObject(store)
        }
    }

    private var picker: some View {
        HStack(spacing: 6) {
            ForEach(LodgeSection.allCases, id: \.rawValue) { s in
                Button(action: { withAnimation(.easeOut(duration: 0.18)) { section = s } }) {
                    Text(s.title.uppercased())
                        .font(StoneFont.title(11))
                        .tracking(1.0)
                        .lineLimit(1)
                        .minimumScaleFactor(0.66)
                        .foregroundColor(section == s ? Stone.card : Stone.inkSoft)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 9)
                                        .fill(section == s ? Stone.ink : Stone.card))
                        .overlay(RoundedRectangle(cornerRadius: 9)
                                    .stroke(Stone.ink.opacity(section == s ? 0 : 0.18), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var elementList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(store.metElements.count) of \(elements.count) opened".uppercased())
                    .font(StoneFont.body(11)).tracking(1.6)
                    .foregroundColor(Stone.inkPale)
                Spacer()
            }
            ProgressBarline(fraction: Double(store.metElements.count) / Double(elements.count),
                            tone: Stone.amber)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: StoneMetrics.isPad ? 200 : 152),
                                         spacing: 11)], spacing: 11) {
                ForEach(elements) { e in
                    Button(action: { openElement = e }) {
                        VStack(alignment: .leading, spacing: 0) {
                            Plate(name: "elem_" + e.slug, corner: 0, anchor: .center)
                                .frame(height: 106)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(e.title)
                                    .font(StoneFont.title(14))
                                    .foregroundColor(Stone.ink)
                                    .lineLimit(2)
                                Text(e.sub)
                                    .font(StoneFont.body(11))
                                    .foregroundColor(Stone.inkPale)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                        }
                        .background(RoundedRectangle(cornerRadius: 12).fill(Stone.card))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(store.metElements.contains(e.slug)
                                            ? Stone.amber.opacity(0.55) : Stone.ink.opacity(0.16),
                                            lineWidth: 1))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var cathedralList: some View {
        VStack(spacing: 11) {
            ForEach(cathedrals) { c in
                Button(action: { openCathedral = c }) {
                    VStack(alignment: .leading, spacing: 0) {
                        Plate(name: "cath_" + c.slug, corner: 0, anchor: .top)
                            .frame(height: StoneMetrics.isPad ? 200 : 140)
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(c.name)
                                    .font(StoneFont.title(18))
                                    .foregroundColor(Stone.ink)
                                Text(c.place + " · " + c.dates)
                                    .font(StoneFont.body(12))
                                    .foregroundColor(Stone.inkPale)
                            }
                            Spacer()
                            Chip(text: String(format: "%.0f m", c.vaultHeight), tone: Stone.amber)
                        }
                        .padding(13)
                    }
                    .background(RoundedRectangle(cornerRadius: 13).fill(Stone.card))
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .overlay(RoundedRectangle(cornerRadius: 13)
                                .stroke(Stone.ink.opacity(0.16), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var lessonList: some View {
        VStack(spacing: 11) {
            StoneCard(tone: Stone.amber.opacity(0.10)) {
                VStack(alignment: .leading, spacing: 9) {
                    HStack {
                        Text("The examination".uppercased())
                            .font(StoneFont.title(12)).tracking(2.0)
                            .foregroundColor(Stone.amber)
                        Spacer()
                        if store.quizTaken > 0 {
                            Text("Best \(store.quizBest)/16")
                                .font(StoneFont.mono(13))
                                .foregroundColor(Stone.ink)
                        }
                    }
                    Text("Sixteen questions drawn from the whole of the lodge instruction, in a different order every time.")
                        .font(StoneFont.body(15))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    StoneButton(title: "Sit the examination", kind: .secondary) { quizOpen = true }
                }
            }
            ForEach(Array(lessons.enumerated()), id: \.offset) { idx, lesson in
                Button(action: { openLesson = lesson }) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(store.readLessons.contains(lesson.slug)
                                      ? Stone.moss.opacity(0.16) : Stone.amber.opacity(0.14))
                                .frame(width: 40, height: 40)
                            if store.readLessons.contains(lesson.slug) {
                                TickMark(size: 18, colour: Stone.moss)
                            } else {
                                Text("\(idx + 1)")
                                    .font(StoneFont.title(16))
                                    .foregroundColor(Stone.amber)
                            }
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(lesson.title)
                                .font(StoneFont.title(16))
                                .foregroundColor(Stone.ink)
                                .multilineTextAlignment(.leading)
                            Text(lesson.standfirst)
                                .font(StoneFont.body(13))
                                .foregroundColor(Stone.inkPale)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer(minLength: 0)
                        ChevronMark(size: 15)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Stone.card))
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Stone.ink.opacity(0.16), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var termList: some View {
        VStack(spacing: 8) {
            ForEach(glossary) { term in
                VStack(alignment: .leading, spacing: 4) {
                    Text(term.term)
                        .font(StoneFont.title(15))
                        .foregroundColor(Stone.ink)
                    Text(term.meaning)
                        .font(StoneFont.body(14))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 11).fill(Stone.card))
                .overlay(RoundedRectangle(cornerRadius: 11)
                            .stroke(Stone.ink.opacity(0.14), lineWidth: 1))
            }
        }
    }
}

struct ElementDetailView: View {
    let entry: ElementEntry
    let onClose: () -> Void
    @EnvironmentObject var store: LodgeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                SheetHeader(title: entry.title, subtitle: entry.sub, onClose: onClose)
                    .padding(.top, 18)
                Plate(name: "elem_" + entry.slug)
                    .frame(height: StoneMetrics.isPad ? 340 : 230)
                Text(entry.note)
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                StoneButton(title: "Close", kind: .secondary, action: onClose)
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .onAppear { store.markElement(entry.slug) }
    }
}

struct CathedralDetailView: View {
    let entry: CathedralEntry
    let onClose: () -> Void
    @EnvironmentObject var store: LodgeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                SheetHeader(title: entry.name, subtitle: entry.place + " · " + entry.dates,
                            onClose: onClose)
                    .padding(.top, 18)
                Plate(name: "cath_" + entry.slug)
                    .frame(height: StoneMetrics.isPad ? 360 : 250)
                HStack(spacing: 8) {
                    Chip(text: String(format: "Vault %.0f m", entry.vaultHeight), tone: Stone.amber)
                    Chip(text: entry.place, tone: Stone.glassBlue)
                }
                Text(entry.note)
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                StoneButton(title: "Close", kind: .secondary, action: onClose)
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .onAppear { store.markCathedral(entry.slug) }
    }
}

struct LessonDetailView: View {
    let lesson: Lesson
    let onClose: () -> Void
    @EnvironmentObject var store: LodgeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                SheetHeader(title: lesson.title, subtitle: "Instruction", onClose: onClose)
                    .padding(.top, 18)
                Plate(name: "les_" + lesson.slug)
                    .frame(height: StoneMetrics.isPad ? 340 : 220)
                Text(lesson.standfirst)
                    .font(StoneFont.italic(17))
                    .foregroundColor(Stone.amber)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(Array(lesson.paragraphs.enumerated()), id: \.offset) { _, para in
                    Text(para)
                        .font(StoneFont.body(16))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                StoneButton(title: "Close", kind: .secondary, action: onClose)
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 34)
        }
        .stonePage()
        .onAppear { store.markLesson(lesson.slug) }
    }
}
