import SwiftUI

enum Stone {
    static let paper = Color(red: 0.949, green: 0.937, blue: 0.910)
    static let paperDeep = Color(red: 0.898, green: 0.886, blue: 0.855)
    static let card = Color(red: 0.980, green: 0.973, blue: 0.957)
    static let cardSunk = Color(red: 0.914, green: 0.902, blue: 0.878)

    static let ink = Color(red: 0.129, green: 0.125, blue: 0.137)
    static let inkSoft = Color(red: 0.271, green: 0.263, blue: 0.271)
    static let inkPale = Color(red: 0.478, green: 0.467, blue: 0.475)

    static let limestone = Color(red: 0.827, green: 0.800, blue: 0.729)
    static let limeDark = Color(red: 0.549, green: 0.522, blue: 0.455)
    static let lead = Color(red: 0.463, green: 0.475, blue: 0.494)
    static let oxblood = Color(red: 0.588, green: 0.235, blue: 0.192)
    static let amber = Color(red: 0.780, green: 0.616, blue: 0.239)
    static let glassBlue = Color(red: 0.216, green: 0.325, blue: 0.502)
    static let glassRed = Color(red: 0.600, green: 0.196, blue: 0.180)
    static let glassGold = Color(red: 0.788, green: 0.647, blue: 0.267)
    static let moss = Color(red: 0.337, green: 0.443, blue: 0.325)
    static let timber = Color(red: 0.420, green: 0.310, blue: 0.204)
    static let night = Color(red: 0.106, green: 0.110, blue: 0.129)
    static let sky = Color(red: 0.647, green: 0.686, blue: 0.710)

    static let hairline = Color(red: 0.129, green: 0.125, blue: 0.137).opacity(0.16)
}

enum StoneFont {
    static func title(_ size: CGFloat) -> Font { .custom("Georgia-Bold", size: size) }
    static func body(_ size: CGFloat) -> Font { .custom("Georgia", size: size) }
    static func italic(_ size: CGFloat) -> Font { .custom("Georgia-Italic", size: size) }
    static func mono(_ size: CGFloat) -> Font { .system(size: size, weight: .semibold, design: .monospaced) }
}

struct StoneMetrics {
    static var isPad: Bool { UIScreen.main.bounds.width >= 700 }
    static var contentWidth: CGFloat { isPad ? 660 : UIScreen.main.bounds.width }
    static var gutter: CGFloat { isPad ? 34 : 18 }
}

extension View {
    func stonePage() -> some View {
        self.background(Stone.paper.ignoresSafeArea())
    }

    func centreColumn() -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            self.frame(maxWidth: StoneMetrics.contentWidth)
            Spacer(minLength: 0)
        }
    }
}
