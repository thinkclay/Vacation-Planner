import SwiftUI
import RealmSwift

struct DestinationListView: View {
	var destinations: Results<HTBDestination>
	let stateLabel: String
	let stateCode: String
	
	init(stateLabel: String, stateCode: String) {
		self.stateLabel = stateLabel
		self.stateCode = stateCode
		self.destinations = try! Realm().objects(HTBDestination.self).filter(NSPredicate(format: "state = %@", stateCode))
	}
	
	var body: some View {
		List(destinations, id: \.self) { destination in
			NavigationLink(destination: DestinationDetailView(destination: destination)) {
				Text(destination.title)
			}
		}
		.navigationBarTitle(stateLabel)
		.onAppear() {
			for destination in self.destinations {
				DestinationController.geocode(destination: destination)
			}
		}
	}
}
