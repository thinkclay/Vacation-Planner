import SwiftUI
import Lottie

struct NeueLottieView: UIViewRepresentable {
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	var name: String!
	@Binding var play:Int
	
	var animationView = AnimationView()
	
	class Coordinator: NSObject {
		var parent: NeueLottieView
		
		init(_ animationView: NeueLottieView) {
			self.parent = animationView
			super.init()
		}
	}
	
	func makeUIView(context: UIViewRepresentableContext<NeueLottieView>) -> UIView {
		let view = UIView()
		
		animationView.animation = Animation.named(name)
		animationView.contentMode = .scaleAspectFit
		
		animationView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(animationView)
		
		NSLayoutConstraint.activate([
			animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
			animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
		])
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<NeueLottieView>) {
		animationView.play()
	}
}
