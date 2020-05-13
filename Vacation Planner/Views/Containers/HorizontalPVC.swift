import Foundation
import UIKit
import SwiftUI

struct HorizontalPVC: UIViewControllerRepresentable {
	
	@Binding var current: Int
	
	var subviews: [UIViewController]
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIViewController(context: Context) -> UIPageViewController {
		let pageViewController = UIPageViewController(
			transitionStyle: .scroll,
			navigationOrientation: .horizontal)
		
		pageViewController.dataSource = context.coordinator
		pageViewController.delegate = context.coordinator
		
		return pageViewController
	}
	
	func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
		pageViewController.setViewControllers(
			[subviews[current]], direction: .forward, animated: true)
	}
	
	class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
		
		var parent: HorizontalPVC
		
		init(_ pageViewController: HorizontalPVC) {
			self.parent = pageViewController
		}
		
		func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
			// retrieves the index of the currently displayed view controller
			guard let index = parent.subviews.firstIndex(of: viewController) else {
				return nil
			}
			
			// shows the last view controller when the user swipes back from the first view controller
			if index == 0 {
				return parent.subviews.last
			}
			
			// show the view controller before the currently displayed view controller
			return parent.subviews[index - 1]
		}
		
		func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
			// retrieves the index of the currently displayed view controller
			guard let index = parent.subviews.firstIndex(of: viewController) else {
				return nil
			}
			// shows the first view controller when the user swipes further from the last view controller
			if index + 1 == parent.subviews.count {
				return parent.subviews.first
			}
			// show the view controller after the currently displayed view controller
			return parent.subviews[index + 1]
		}
		
		func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
			if completed,
				let visibleViewController = pageViewController.viewControllers?.first,
				let index = parent.subviews.firstIndex(of: visibleViewController)
			{
				parent.current = index
			}
		}
	}
	
}
