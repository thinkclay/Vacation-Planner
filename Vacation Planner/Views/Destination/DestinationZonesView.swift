import SwiftUI

struct DestinationZonesView: View {
	let zones: String
	
	var body: some View {
		VStack {
			Text("Popular areas:").font(.headline)
			
			ForEach(zones.split(separator: ","), id: \.self) { zone in
				Text(zone).font(.body)
			}
		}
		.padding()
	}
}

struct DestinationZonesView_Previews: PreviewProvider {
	static var previews: some View {
		DestinationZonesView(zones: "lake michigan,detroit")
	}
}

