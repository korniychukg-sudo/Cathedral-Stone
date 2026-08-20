import SwiftUI
import Combine

struct BuiltChurch: Codable, Identifiable {
    var id: String
    var programme: String
    var pier: String
    var arch: String
    var vault: String
    var buttress: String
    var pinnacle: String
    var height: Double
    var verdict: String
    var grade: String
    var light: Double
    var elegance: Double
    var eccentricity: Double
    var middleThird: Double
    var stamp: Double

    var stands: Bool { verdict == "safe" || verdict == "cracked" }
    var perfect: Bool { verdict == "safe" }
}

final class LodgeStore: ObservableObject {
    @Published var churches: [BuiltChurch] = []
    @Published var readLessons: Set<String> = []
    @Published var metElements: Set<String> = []
    @Published var metCathedrals: Set<String> = []
    @Published var awards: Set<String> = []
    @Published var quizBest: Int = 0
    @Published var quizTaken: Int = 0
    @Published var onboarded: Bool = false

    private let key = "cathedral.stone.state.v1"
    private var loaded = false

    init() { load() }

    struct Snapshot: Codable {
        var churches: [BuiltChurch]
        var readLessons: [String]
        var metElements: [String]
        var metCathedrals: [String]
        var awards: [String]
        var quizBest: Int
        var quizTaken: Int
        var onboarded: Bool
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let snap = try? JSONDecoder().decode(Snapshot.self, from: data) else {
            loaded = true
            return
        }
        churches = snap.churches
        readLessons = Set(snap.readLessons)
        metElements = Set(snap.metElements)
        metCathedrals = Set(snap.metCathedrals)
        awards = Set(snap.awards)
        quizBest = snap.quizBest
        quizTaken = snap.quizTaken
        onboarded = snap.onboarded
        loaded = true
    }

    func saveNow() {
        guard loaded else { return }
        let snap = Snapshot(churches: churches, readLessons: Array(readLessons),
                            metElements: Array(metElements),
                            metCathedrals: Array(metCathedrals),
                            awards: Array(awards), quizBest: quizBest,
                            quizTaken: quizTaken, onboarded: onboarded)
        if let data = try? JSONEncoder().encode(snap) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    var standing: Int { churches.filter { $0.stands }.count }
    var uncracked: Int { churches.filter { $0.perfect }.count }
    var tallestStanding: Double { churches.filter { $0.stands }.map { $0.height }.max() ?? 0 }
    var collapses: Int { churches.filter { !$0.stands }.count }
    var bestLight: Double? { churches.filter { $0.stands }.map { $0.light }.max() }

    func record(_ c: BuiltChurch) {
        churches.append(c)
        if churches.count > 300 { churches.removeFirst(churches.count - 300) }
        refreshAwards()
        saveNow()
    }

    func markLesson(_ slug: String) {
        guard !readLessons.contains(slug) else { return }
        readLessons.insert(slug); refreshAwards(); saveNow()
    }

    func markElement(_ slug: String) {
        guard !metElements.contains(slug) else { return }
        metElements.insert(slug); refreshAwards(); saveNow()
    }

    func markCathedral(_ slug: String) {
        guard !metCathedrals.contains(slug) else { return }
        metCathedrals.insert(slug); refreshAwards(); saveNow()
    }

    func recordQuiz(score: Int) {
        quizTaken += 1
        if score > quizBest { quizBest = score }
        refreshAwards(); saveNow()
    }

    func finishOnboarding() { onboarded = true; saveNow() }

    func resetProgress() {
        churches = []; readLessons = []; metElements = []; metCathedrals = []
        awards = []; quizBest = 0; quizTaken = 0
        saveNow()
    }

    func refreshAwards() {
        for award in allAwards where !awards.contains(award.slug) {
            if award.test(self) { awards.insert(award.slug) }
        }
    }
}
