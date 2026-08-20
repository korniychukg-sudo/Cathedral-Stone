import SwiftUI

enum PlateStore {
    static func image(_ name: String) -> UIImage? {
        if let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art"),
           let img = UIImage(contentsOfFile: path) {
            return img
        }
        if let path = Bundle.main.path(forResource: name, ofType: "jpg"),
           let img = UIImage(contentsOfFile: path) {
            return img
        }
        return nil
    }
}

struct Plate: View {
    let name: String
    var corner: CGFloat = 10
    var anchor: Alignment = .center

    var body: some View {
        GeometryReader { geo in
            if let img = PlateStore.image(name) {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: anchor)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Stone.cardSunk)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: corner))
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(Stone.ink.opacity(0.30), lineWidth: 1)
        )
    }
}

struct StoneCard<Content: View>: View {
    var padding: CGFloat = 16
    var tone: Color = Stone.card
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(tone)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Stone.ink.opacity(0.20), lineWidth: 1)
            )
    }
}

struct SectionHead: View {
    let text: String
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(text.uppercased())
                .font(StoneFont.title(13))
                .tracking(2.4)
                .foregroundColor(Stone.inkSoft)
                .fixedSize(horizontal: true, vertical: false)
            Rectangle()
                .fill(Stone.hairline)
                .frame(height: 1)
            if let t = trailing {
                Text(t.uppercased())
                    .font(StoneFont.body(12))
                    .tracking(1.6)
                    .foregroundColor(Stone.inkPale)
            }
        }
    }
}

struct StoneButton: View {
    let title: String
    var kind: Kind = .primary
    var enabled: Bool = true
    let action: () -> Void

    enum Kind { case primary, secondary, quiet, danger }

    private var fill: Color {
        switch kind {
        case .primary: return Stone.ink
        case .secondary: return Stone.amber.opacity(0.20)
        case .quiet: return Color.clear
        case .danger: return Stone.oxblood.opacity(0.16)
        }
    }

    private var textColour: Color {
        switch kind {
        case .primary: return Stone.card
        case .secondary: return Stone.ink
        case .quiet: return Stone.inkSoft
        case .danger: return Stone.oxblood
        }
    }

    var body: some View {
        Button(action: { if enabled { action() } }) {
            Text(title.uppercased())
                .font(StoneFont.title(14))
                .tracking(2.0)
                .foregroundColor(textColour.opacity(enabled ? 1 : 0.38))
                .padding(.vertical, 13)
                .padding(.horizontal, 22)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .fill(fill.opacity(enabled ? 1 : 0.35))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(kind == .primary ? Color.clear : Stone.ink.opacity(0.28),
                                lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Chip: View {
    let text: String
    var tone: Color = Stone.amber
    var solid: Bool = false

    var body: some View {
        Text(text.uppercased())
            .font(StoneFont.title(11))
            .tracking(1.6)
            .foregroundColor(solid ? Stone.card : tone)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(solid ? tone : tone.opacity(0.14))
            )
            .overlay(
                Capsule().stroke(tone.opacity(solid ? 0 : 0.45), lineWidth: 1)
            )
    }
}

struct StatBlock: View {
    let value: String
    let caption: String
    var tone: Color = Stone.ink

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(StoneFont.title(21))
                .foregroundColor(tone)
            Text(caption.uppercased())
                .font(StoneFont.body(10))
                .tracking(1.4)
                .foregroundColor(Stone.inkPale)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StarRow: View {
    let earned: Int
    var total: Int = 3
    var size: CGFloat = 15

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<total, id: \.self) { i in
                StarMark(size: size, colour: Stone.amber, filled: i < earned)
            }
        }
    }
}

struct RuleLine: View {
    var body: some View {
        Rectangle().fill(Stone.hairline).frame(height: 1)
    }
}

struct SheetHeader: View {
    let title: String
    var subtitle: String? = nil
    let onClose: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(StoneFont.title(21))
                    .foregroundColor(Stone.ink)
                if let s = subtitle {
                    Text(s.uppercased())
                        .font(StoneFont.body(11))
                        .tracking(1.8)
                        .foregroundColor(Stone.inkPale)
                }
            }
            Spacer(minLength: 12)
            Button(action: onClose) {
                CloseMark(size: 19)
                    .padding(9)
                    .background(Circle().fill(Stone.cardSunk))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct BackBar: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onBack) {
                HStack(spacing: 5) {
                    ChevronMark(size: 14, colour: Stone.inkSoft, pointsLeft: true)
                    Text("Back".uppercased())
                        .font(StoneFont.title(12))
                        .tracking(1.8)
                        .foregroundColor(Stone.inkSoft)
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 12)
                .background(Capsule().fill(Stone.cardSunk))
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Text(title.uppercased())
                .font(StoneFont.title(12))
                .tracking(2.2)
                .foregroundColor(Stone.inkPale)
        }
    }
}

struct ProgressBarline: View {
    let fraction: Double
    var tone: Color = Stone.amber
    var height: CGFloat = 7

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Stone.ink.opacity(0.10))
                Capsule()
                    .fill(tone)
                    .frame(width: max(0, min(1, fraction)) * geo.size.width)
            }
        }
        .frame(height: height)
    }
}

func formatPercent(_ v: Double) -> String {
    String(format: "%.0f%%", v)
}

func formatCount(_ n: Int) -> String {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.groupingSeparator = ","
    return f.string(from: NSNumber(value: n)) ?? "\(n)"
}

func formatYear(_ y: Int) -> String { "\(y)" }

enum StoneFeel {
    static func tick() {
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.prepare()
        gen.impactOccurred(intensity: 0.42)
    }

    static func tap() {
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.prepare()
        gen.impactOccurred(intensity: 0.6)
    }

    static func land(_ stars: Int) {
        let gen = UIImpactFeedbackGenerator(style: stars >= 3 ? .heavy : .soft)
        gen.prepare()
        gen.impactOccurred(intensity: stars >= 3 ? 1.0 : 0.6)
    }
}

struct RisingCard<Content: View>: View {
    let index: Int
    @ViewBuilder var content: () -> Content
    @State private var shown = false

    var body: some View {
        content()
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : 16)
            .onAppear {
                withAnimation(.easeOut(duration: 0.38)
                    .delay(Double(index) * 0.06)) { shown = true }
            }
    }
}
