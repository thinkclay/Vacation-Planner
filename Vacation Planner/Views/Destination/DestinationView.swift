import SwiftUI

struct DestinationView: View {
	
	@ObservedObject var destinationsObserver = DestinationObserver()
	
	var body: some View {
		NavigationView {
			List(destinationsObserver.destinations) { record in
				NavigationLink(destination: DestinationDetailsView(record: record)) {
					DestinationRowView(record: record)
				}
			}
			.navigationBarTitle("Destinations: \(destinationsObserver.total)")
		}
	}
}

struct DestinationView_Previews: PreviewProvider {
	static var previews: some View {
		DestinationView()
	}
}

