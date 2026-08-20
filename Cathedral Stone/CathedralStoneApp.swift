import SwiftUI

@main
struct CathedralStoneApp: App {
    @StateObject private var store = LodgeStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background || phase == .inactive {
                store.saveNow()
            }
        }
    }
}
