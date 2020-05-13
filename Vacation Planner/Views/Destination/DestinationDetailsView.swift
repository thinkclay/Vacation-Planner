import SwiftUI
import RealmSwift

struct DestinationDetailsView: View {
	let record: HTBDestination
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(record.title).font(.headline)
			
//			ForEach(record.zones, id: \.self) { zone in
//				Text(zone)
//			}
		}
	}
}
