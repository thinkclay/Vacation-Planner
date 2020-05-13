import SwiftUI

struct CountryRowView: View {
	let record: HBCountry
	
	var body: some View {
		HStack {
			Image(record.id)
				.frame(width: 50.0, height: 40.0, alignment: .center)
				.scaledToFit()
				.clipped()
			
			Text(record.id).font(.headline)
		}
	}
}

struct CountryRowView_Previews: PreviewProvider {
	static var previews: some View {
		CountryRowView(record: HBCountry.getSample())
	}
}

