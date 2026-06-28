import SwiftUI
import Combine

enum Screen: Hashable {
    case splash, home, composer, thinking, results, detail(String), booking(String), confirmed, share(String, Bool), feedback, pulse, taste
}

class AppState: ObservableObject {
    @Published var screenStack: [Screen] = [.splash]
    @Published var query: String = ""
    @Published var listening: Bool = false
    @Published var selectedRefine: String? = nil
    @Published var bookTime: String = "20:00"
    @Published var bookGuests: Int = 2
    @Published var specialRequest: String = ""
    @Published var booked: Bool = false
    @Published var feedbackChoice: String? = nil
    @Published var fedback: Bool = false
    @Published var copied: Bool = false
    @Published var pulseCount: Int = 0
    @Published var orbMode: OrbMode = .idle
    @Published var selectedRestaurantId: String = "mat"
    @Published var activeTab: Tab = .home

    private var timers = Set<AnyCancellable>()

    enum OrbMode { case idle, thinking, converge }
    enum Tab { case home, pulse }

    var currentScreen: Screen { screenStack.last ?? .splash }

    var currentRestaurant: Restaurant { Restaurant.all[selectedRestaurantId] ?? Restaurant.all["mat"]! }

    func go(_ screen: Screen) {
        withAnimation(.alloraEase) { screenStack.append(screen) }
    }

    func replace(_ screen: Screen) {
        withAnimation(.alloraEase) {
            if !screenStack.isEmpty { screenStack[screenStack.count - 1] = screen }
        }
    }

    func back() {
        withAnimation(.alloraEase) {
            if screenStack.count > 1 { screenStack.removeLast() }
        }
    }

    func goHome() {
        withAnimation(.alloraEase) {
            screenStack = [.home]
            activeTab = .home
        }
    }

    func openDetail(_ id: String) {
        selectedRestaurantId = id
        go(.detail(id))
    }

    func openBooking(_ id: String? = nil) {
        if let id = id { selectedRestaurantId = id }
        go(.booking(selectedRestaurantId))
    }

    func openComposerWith(_ q: String) {
        query = q
        go(.composer)
    }

    func submit() {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        replace(.thinking)
        orbMode = .thinking
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.48) { self.orbMode = .converge }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
            self.replace(.results)
            self.orbMode = .idle
        }
    }

    func simulateMic() {
        listening = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.listening = false
            self.query = "Find me a cozy place nearby for two around 8, not too expensive"
        }
    }

    func confirm() {
        booked = true
        go(.confirmed)
    }

    func setTab(_ tab: Tab) {
        activeTab = tab
        if tab == .pulse {
            withAnimation(.alloraEase) { screenStack = [.pulse] }
        } else {
            withAnimation(.alloraEase) { screenStack = [.home] }
        }
    }

    func pulseOrb() {
        pulseCount += 1
    }

    func copyLink() {
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { self.copied = false }
    }

    func chooseFeedback(_ choice: String) {
        feedbackChoice = choice
    }

    func finishFeedback() {
        fedback = true
        goHome()
    }

    var showTabBar: Bool {
        switch currentScreen {
        case .home, .pulse: return true
        default: return false
        }
    }

    var isDarkStatusBar: Bool {
        switch currentScreen {
        case .splash, .share: return true
        case .detail: return true
        default: return false
        }
    }

    let refineOptions = ["Closer", "More romantic", "Cheaper", "Livelier", "Outdoor"]
    let refineNotes: [String: String] = [
        "Closer": "Tightened to places you can walk to in under 10 minutes.",
        "More romantic": "Leaning softer and lower-lit — candles over buzz.",
        "Cheaper": "Trimmed to the kindest on the bill, still warm.",
        "Livelier": "Turned up the energy — rooms with a bit of hum.",
        "Outdoor": "Only the terraces still warm enough tonight.",
    ]
    var currentRefineNote: String { selectedRefine.flatMap { refineNotes[$0] } ?? "" }
}
