import Foundation
import UIKit
import SwiftUI

struct OnboardingPagination: UIViewRepresentable {
	
	@Binding var current: Int
	
	let total: Int
	
	func makeUIView(context: Context) -> UIPageControl {
		let control = UIPageControl()
		control.numberOfPages = total
		control.currentPageIndicatorTintColor = .blue
		control.pageIndicatorTintColor = .gray
		
		return control
	}
	
	func updateUIView(_ uiView: UIPageControl, context: Context) {
		uiView.currentPage = current
	}
	
}
