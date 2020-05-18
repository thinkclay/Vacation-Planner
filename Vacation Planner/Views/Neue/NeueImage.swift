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

public extension UIImage {
	func tint(with fillColor: UIColor) -> UIImage? {
		let image = withRenderingMode(.alwaysTemplate)
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		fillColor.set()
		image.draw(in: CGRect(origin: .zero, size: size))
		
		guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
			return nil
		}
		
		UIGraphicsEndImageContext()
		return imageColored
	}
}

//extension UIImage {
//	
//	func maskWithColor(color: UIColor) -> UIImage {
//		let maskImage = cgImage!
//		
//		let width = size.width
//		let height = size.height
//		let bounds = CGRect(x: 0, y: 0, width: width, height: height)
//		
//		let colorSpace = CGColorSpaceCreateDeviceRGB()
//		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//		let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
//		
//		context.clip(to: bounds, mask: maskImage)
//		context.setFillColor(color.cgColor)
//		context.fill(bounds)
//		
//		let cgImage = context.makeImage()!
//		return UIImage(cgImage: cgImage)
//	}
//	
//}
