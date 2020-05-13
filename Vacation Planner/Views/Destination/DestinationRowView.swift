import SwiftUI

struct DestinationRowView: View {
	let record: HTBDestination
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(record.title).font(.headline)
		}
	}
}
