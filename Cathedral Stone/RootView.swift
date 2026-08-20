import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: LodgeStore
    @State private var tab: Int = 0

    var body: some View {
        ZStack {
            Stone.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                Group {
                    switch tab {
                    case 0: SiteView()
                    case 1: FabricView()
                    case 2: LodgeView()
                    default: RollsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                tabBar
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !store.onboarded },
            set: { if !$0 { store.finishOnboarding() } })) {
            OnboardingView { store.finishOnboarding() }
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(0, "Site", AnyView(SiteGlyph(size: 25, colour: tint(0))))
            tabButton(1, "Fabric", AnyView(FabricGlyph(size: 25, colour: tint(1))))
            tabButton(2, "Lodge", AnyView(LodgeGlyph(size: 25, colour: tint(2))))
            tabButton(3, "Rolls", AnyView(RollsGlyph(size: 25, colour: tint(3))))
        }
        .padding(.top, 9)
        .padding(.bottom, 3)
        .background(
            Stone.card
                .overlay(Rectangle().fill(Stone.ink.opacity(0.14)).frame(height: 1),
                         alignment: .top)
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func tint(_ index: Int) -> Color {
        tab == index ? Stone.ink : Stone.ink.opacity(0.34)
    }

    private func tabButton(_ index: Int, _ label: String, _ icon: AnyView) -> some View {
        Button(action: { tab = index }) {
            VStack(spacing: 4) {
                icon
                Text(label.uppercased())
                    .font(StoneFont.title(9))
                    .tracking(1.2)
                    .foregroundColor(tint(index))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingView: View {
    let onDone: () -> Void
    @State private var page: Int = 0

    private let pages: [(String, String, String)] = [
        ("Stone pushes sideways",
         "An arch does not only press down on what carries it. It presses outward, and that push is what decided the shape of every great church in Europe.",
         "les_thrust"),
        ("Follow the line",
         "Draw the path the load actually takes down through the masonry. While that line stays inside the stone, the building stands. When it leaves, it hinges and folds.",
         "les_thrust-line"),
        ("Six decisions",
         "The commission, the piers, the arcade, the vault, the buttressing and the pinnacle. Each one changes the thrust, the weight or the lever arm — and the section redraws as you choose.",
         "les_pointed-arch"),
        ("Then strike the centring",
         "Take away the timber and watch the thrust line come down. Inside the middle third and nothing opens; outside the base and it goes over, exactly as Beauvais did in 1284.",
         "les_beauvais"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if page > 0 {
                    Button(action: { withAnimation { page -= 1 } }) {
                        HStack(spacing: 5) {
                            ChevronMark(size: 13, colour: Stone.inkSoft, pointsLeft: true)
                            Text("Back".uppercased())
                                .font(StoneFont.title(11)).tracking(1.6)
                                .foregroundColor(Stone.inkSoft)
                        }
                        .padding(.vertical, 7).padding(.horizontal, 12)
                        .background(Capsule().fill(Stone.cardSunk))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
                Button(action: onDone) {
                    Text("Skip".uppercased())
                        .font(StoneFont.title(11)).tracking(1.6)
                        .foregroundColor(Stone.inkPale)
                        .padding(.vertical, 7).padding(.horizontal, 12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.top, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Plate(name: pages[page].2)
                        .frame(height: StoneMetrics.isPad ? 340 : 230)
                    Text(pages[page].0)
                        .font(StoneFont.title(27))
                        .foregroundColor(Stone.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(pages[page].1)
                        .font(StoneFont.body(17))
                        .foregroundColor(Stone.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, StoneMetrics.gutter)
                .padding(.top, 14)
                .padding(.bottom, 20)
            }

            HStack(spacing: 7) {
                ForEach(0..<pages.count, id: \.self) { i in
                    Circle()
                        .fill(i == page ? Stone.ink : Stone.ink.opacity(0.20))
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.bottom, 14)

            StoneButton(title: page + 1 >= pages.count ? "Go to the site" : "Next") {
                if page + 1 >= pages.count { onDone() }
                else { withAnimation { page += 1 } }
            }
            .padding(.horizontal, StoneMetrics.gutter)
            .padding(.bottom, 22)
        }
        .stonePage()
        .centreColumn()
    }
}
