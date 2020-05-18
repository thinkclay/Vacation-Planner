import SwiftUI

extension UINavigationController {
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		let navigation = UINavigationBarAppearance()
		navigation.backgroundColor = UIColor(named: "Neutral300")
		navigation.titleTextAttributes = [
			.foregroundColor: UIColor.white
		]
		
//		let backButton = UIBarButtonItemAppearance()
//		navigation.backButtonAppearance = backButton
		
		navigationBar.standardAppearance = navigation
		navigationBar.compactAppearance = navigation
		navigationBar.scrollEdgeAppearance = navigation
	}
}

struct RootView: View {
	@ObservedObject var appState: AppState
	
	init() {
		appState = AppState()
		
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
	}
	
	var body: some View {
		NavigationView {
			ZStack {
				Color("Neutral100").edgesIgnoringSafeArea(.all)
				
				if !appState.isUser {
					OnboardingView(appState: appState)
				}
				else if !appState.isAuthenticated {
					AuthView(appState: appState)
				}
				else {
					StateView()
				}
			}
		}
		.accentColor(Color.white)
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
	}
}

