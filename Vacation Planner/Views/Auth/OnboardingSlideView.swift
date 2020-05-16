import SwiftUI

struct OnboardingSlideView: View {
	@State var play: Int = 0
	
	let slide: SlideModel
	
	var body: some View {
		VStack {
			NeueLottieView(name: slide.image, play: $play).frame(width:200, height:200)
			Text(slide.title).font(.headline)
			Text(slide.body).font(.body)
		}
	}
}

struct OnboardingSlideView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingSlideView(slide: SlideModel(id: UUID(), image: "onboarding-map", title: "Test", body: "Test Body"))
	}
}

