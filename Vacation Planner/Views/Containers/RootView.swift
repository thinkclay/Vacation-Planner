import SwiftUI

extension UINavigationController {
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		let standard = UINavigationBarAppearance()
		standard.backgroundColor = UIColor(named: "Neutral300")
		
		let compact = UINavigationBarAppearance()
		compact.backgroundColor = UIColor(named: "Neutral300")
		
		let scrollEdge = UINavigationBarAppearance()
		scrollEdge.backgroundColor = UIColor(named: "Neutral300")
		
		navigationBar.standardAppearance = standard
		navigationBar.compactAppearance = compact
		navigationBar.scrollEdgeAppearance = scrollEdge
	}
}

struct RootView: View {
	@ObservedObject var appState: AppState
	
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
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(appState: AppState())
	}
}

