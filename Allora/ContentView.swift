import SwiftUI

struct ContentView: View {
    @StateObject private var state = AppState()

    var body: some View {
        ZStack {
            screenView
            if state.showTabBar {
                VStack {
                    Spacer()
                    TabBarView()
                }
                .ignoresSafeArea()
            }
        }
        .environmentObject(state)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var screenView: some View {
        switch state.currentScreen {
        case .splash:
            SplashView()
        case .home:
            HomeView()
        case .composer:
            ComposerView()
        case .thinking:
            ThinkingView()
        case .results:
            ResultsView()
        case .detail(let id):
            DetailView(restaurantId: id)
        case .booking(let id):
            BookingView(restaurantId: id)
        case .confirmed:
            ConfirmedView()
        case .share(let id, let booked):
            ShareView(restaurantId: id, isBooked: booked)
        case .feedback:
            FeedbackView()
        case .pulse:
            PulseView()
        case .taste:
            TasteProfileView()
        }
    }
}
