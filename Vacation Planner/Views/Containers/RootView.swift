import SwiftUI

struct RootView: View {
	@ObservedObject var appState: AppState
	
	var body: some View {
		VStack {
			if !appState.isUser {
				OnboardingView(appState: appState)
			}
			else if !appState.isAuthenticated {
				AuthView(appState: appState)
			}
			else {
				DestinationView()
			}
		}
		.background(Color("Neutral100"))
		.edgesIgnoringSafeArea(.all)
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(appState: AppState())
	}
}
