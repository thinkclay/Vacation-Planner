import Foundation

struct SlideModel {
	let id: UUID
	let image: String
	let title: String
	let body: String
	
	static func all() -> [SlideModel] {
		return [
			SlideModel(id: UUID(), image: "onboarding-map", title: "Slide 1", body: "Slide 1 body"),
			SlideModel(id: UUID(), image: "onboarding-luggage", title: "Slide 2", body: "Slide 2 body"),
			SlideModel(id: UUID(), image: "onboarding-van", title: "Slide 3", body: "Slide 3 body"),
		]
	}
	
	static func getSample() -> [SlideModel] {
		return [
			SlideModel(id: UUID(), image: "onboarding-map", title: "Sample Slide 1", body: "Slide 1 body"),
			SlideModel(id: UUID(), image: "onboarding-luggage", title: "Sample Slide 2", body: "Slide 2 body"),
			SlideModel(id: UUID(), image: "onboarding-van", title: "Sample Slide 3", body: "Slide 3 body"),
		]
	}
}
