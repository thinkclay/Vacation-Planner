import SwiftUI
import Lottie

struct OnboardingView: View {
	@ObservedObject var appState: AppState
	@State var current = 0
		
	let subviews = SlideModel.all().map() {
		UIHostingController(rootView: OnboardingSlideView(slide: $0))
	}
	
	var body: some View {
		VStack {
			HorizontalPVC(current: $current, subviews: subviews)
			
			Button(action: nextHandler) {
				HStack {
					Text("Next")
					
					Image(systemName: "arrow.right")
						.resizable()
						.foregroundColor(.white)
						.frame(width: 15, height: 15)
				}
				.frame(minWidth: 0, maxWidth: .infinity)
				.padding()
				.background(Color.blue)
				.foregroundColor(Color.white)
				.cornerRadius(5)
				.padding(.horizontal, 20)
			}
			
			OnboardingPagination(current: $current, total: subviews.count)
		}
	}
	
	func nextHandler() {
		if (self.current + 1 == self.subviews.count) {
			self.appState.isUser = true
			self.appState.currentPage = .auth
		}
		else {
			self.current += 1
		}
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(appState: AppState())
	}
}

