import SwiftUI

struct QuizView: View {
    let onClose: () -> Void
    @EnvironmentObject var store: LodgeStore

    @State private var order: [Int] = []
    @State private var position: Int = 0
    @State private var chosen: Int? = nil
    @State private var score: Int = 0
    @State private var finished: Bool = false

    private let count = 16

    private var question: QuizQuestion? {
        guard position < order.count else { return nil }
        return quizQuestions[order[position]]
    }

    private func rotation(for index: Int) -> Int {
        (index * 7 + 3) % 4
    }

    private func options(_ q: QuizQuestion, _ index: Int) -> [String] {
        let r = rotation(for: index)
        guard q.options.count == 4 else { return q.options }
        return Array(q.options[r...] + q.options[..<r])
    }

    private func correctSlot(_ q: QuizQuestion, _ index: Int) -> Int {
        let r = rotation(for: index)
        return (q.answer - r + 4) % 4
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SheetHeader(title: "The examination",
                            subtitle: finished ? "Result" : "Question \(position + 1) of \(count)",
                            onClose: onClose)
                    .padding(.top, 18)

                if finished {
                    resultBody
                } else if let q = question {
                    ProgressBarline(fraction: Double(position) / Double(count))

                    Text(q.prompt)
                        .font(StoneFont.title(21))
                        .foregroundColor(Stone.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    let idx = order[position]
                    let opts = options(q, idx)
                    let right = correctSlot(q, idx)

                    VStack(spacing: 9) {
                        ForEach(Array(opts.enumerated()), id: \.offset) { slot, text in
                            optionRow(text: text, slot: slot, right: right)
                        }
                    }

                    if let c = chosen {
                        StoneCard(tone: c == right ? Stone.moss.opacity(0.12)
                                                 : Stone.oxblood.opacity(0.10)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(c == right ? "Correct" : "Not quite")
                                    .font(StoneFont.title(15))
                                    .foregroundColor(c == right ? Stone.moss : Stone.oxblood)
                                Text(q.note)
                                    .font(StoneFont.body(15))
                                    .foregroundColor(Stone.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        StoneButton(title: position + 1 >= count ? "See the result" : "Next question") {
                            if position + 1 >= count {
                                finished = true
                                store.recordQuiz(score: score)
                            } else {
                                position += 1
                                chosen = nil
                            }
                        }
                    }

                    StoneButton(title: "Leave the examination", kind: .quiet, action: onClose)
                }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 40)
        }
        .stonePage()
        .centreColumn()
        .onAppear { start() }
    }

    private func start() {
        guard order.isEmpty else { return }
        var pool = Array(0..<quizQuestions.count)
        var picked: [Int] = []
        var seed = UInt64(store.quizTaken &* 2654435761 &+ 97)
        func next() -> Int {
            seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17
            return Int(seed % UInt64(max(1, pool.count)))
        }
        while picked.count < count && !pool.isEmpty {
            picked.append(pool.remove(at: next()))
        }
        order = picked
    }

    private func optionRow(text: String, slot: Int, right: Int) -> some View {
        let answered = chosen != nil
        let isRight = slot == right
        let isChosen = chosen == slot
        var fill = Stone.card
        var border = Stone.ink.opacity(0.18)
        if answered {
            if isRight { fill = Stone.moss.opacity(0.14); border = Stone.moss.opacity(0.55) }
            else if isChosen { fill = Stone.oxblood.opacity(0.12); border = Stone.oxblood.opacity(0.55) }
        }
        return Button(action: {
            guard chosen == nil else { return }
            chosen = slot
            if isRight { score += 1 }
        }) {
            HStack {
                Text(text)
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.ink)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                if answered && isRight { TickMark(size: 17, colour: Stone.moss) }
            }
            .padding(.vertical, 13)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 11).fill(fill))
            .overlay(RoundedRectangle(cornerRadius: 11).stroke(border, lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var resultBody: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(spacing: 8) {
                Text("\(score) of \(count)")
                    .font(StoneFont.title(44))
                    .foregroundColor(Stone.ink)
                Text(verdict.uppercased())
                    .font(StoneFont.title(13)).tracking(2.4)
                    .foregroundColor(Stone.amber)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)

            StoneCard(tone: Stone.cardSunk) {
                Text(comment)
                    .font(StoneFont.body(16))
                    .foregroundColor(Stone.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if score > 0 && store.quizBest == score {
                StoneCard(tone: Stone.amber.opacity(0.12)) {
                    Text("A new best.")
                        .font(StoneFont.title(15))
                        .foregroundColor(Stone.amber)
                }
            }

            StoneButton(title: "Sit it again") {
                order = []
                position = 0
                chosen = nil
                score = 0
                finished = false
                start()
            }
            StoneButton(title: "Close", kind: .secondary, action: onClose)
        }
    }

    private var verdict: String {
        if score >= 15 { return "Master mason" }
        if score >= 12 { return "Passed with credit" }
        if score >= 9 { return "Passed" }
        return "Sit it again"
    }

    private var comment: String {
        if score >= 15 {
            return "There is nothing in the lodge instruction you have not understood. The rest is building it."
        }
        if score >= 12 {
            return "Sound. The thrust line and the middle third are the parts worth knowing without thinking — on site nobody warns you before it moves."
        }
        if score >= 9 {
            return "A pass, and a reminder. Go back through the lessons on thrust, the middle third and what the pinnacle is for, and try again."
        }
        return "The instruction section covers every one of these. Read the twelve lessons through once and this examination becomes straightforward."
    }
}
