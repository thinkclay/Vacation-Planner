import SwiftUI
import RealmSwift

struct DestinationDetailView: View {
	@State var destination: HTBDestination
	
	var body: some View {
		
		VStack(alignment: .center) {
				DestinationMapView(destination: destination)
					.frame(height: 300)
				
				Image(destination.state, bundle: Bundle.init(identifier: "States"))
					.frame(width: 150, height: 150)
					.clipShape(Circle())
					.overlay(Circle().stroke(Color.white, lineWidth: 3))
					.shadow(radius: 2)
					.offset(y: -75)
					.padding(.bottom, -75)
			
				Text("\(destination.title), \(destination.state)").font(.title)
				
				DestinationZonesView(zones: destination.zones)
			}
	}
}

struct DestinationDetailView_Previews: PreviewProvider {
	static let destination = try! Array(Realm().objects(HTBDestination.self)).first!
	
	static var previews: some View {
		DestinationDetailView(destination: destination)
	}
}
