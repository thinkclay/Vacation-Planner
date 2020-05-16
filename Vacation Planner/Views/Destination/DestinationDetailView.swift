import SwiftUI
import RealmSwift

struct DestinationDetailView: View {
	@State var destination: HTBDestination
	
	var body: some View {
		VStack(alignment: .leading) {
			DestinationMapView(destination: destination)
			
			VStack(alignment: .leading) {
				Text("\(destination.title), \(destination.state)").font(.title)
				Text("Popular areas:").font(.headline)
				
				ForEach(destination.zones.split(separator: ","), id: \.self) { zone in
					Text(zone).font(.body)
				}
			}
			.padding()
		}
	}
}

struct DestinationDetailView_Previews: PreviewProvider {
	static let destination = try! Array(Realm().objects(HTBDestination.self)).first!
	
	static var previews: some View {
		DestinationDetailView(destination: destination)
	}
}
