import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
	@Published var image: UIImage?
	
	private let url: URL
	private var cancellable: AnyCancellable?
	
	init(url: URL) {
		self.url = url
	}
	
	deinit {
		cancellable?.cancel()
	}
	
	func load() {
		cancellable = URLSession.shared.dataTaskPublisher(for: url)
			.map { UIImage(data: $0.data) }
			.replaceError(with: nil)
			.receive(on: DispatchQueue.main)
			.assign(to: \.image, on: self)
	}
	
	func cancel() {
		cancellable?.cancel()
	}
}

struct NeueAsyncImage<Placeholder: View>: View {
	@ObservedObject private var loader: ImageLoader
	private let placeholder: Placeholder?
	
	init(url: String, placeholder: Placeholder? = nil) {
		loader = ImageLoader(url: URL(string: url)!)
		self.placeholder = placeholder
	}
	
	var body: some View {
		image
			.onAppear(perform: loader.load)
			.onDisappear(perform: loader.cancel)
	}
	
	private var image: some View {
		Group {
			if loader.image != nil {
				Image(uiImage: loader.image!)
					.resizable()
			} else {
				placeholder
			}
		}
	}
}
