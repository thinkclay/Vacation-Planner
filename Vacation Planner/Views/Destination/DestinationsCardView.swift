import SwiftUI
import RealmSwift

struct DestinationsCardView: View {
	let state: String
	let code: String
	let destinations: [HTBDestination]
	
	var body: some View {
		VStack(alignment: .trailing) {
			HStack {
				VStack(alignment: .leading) {
//					Image(code, bundle: Bundle.init(identifier: "States"))
						
//					NeueAsyncImage(
//						url: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg",
//						placeholder: Text("Loading ...")
//					).aspectRatio(contentMode: .fit)
					
					Text(state)
						.font(.title)
						.foregroundColor(.primary)
						.fontWeight(.light)
					
					VStack(alignment: .leading) {
						ForEach(destinations) { record in
							Text(record.title)
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.secondary)
								.padding(.top, 5)
						}
					}
				}
				.layoutPriority(100)
				
				Spacer()
			}
			.padding()
			.background(Blur(style: .systemUltraThinMaterial))
		}
		.frame(minHeight: 300, alignment: .bottom)
		.background(Image(code, bundle: Bundle.init(identifier: "States")))
		.cornerRadius(10)
		.padding([.horizontal, .top])
	}
}

struct DestinationsCardView_Previews: PreviewProvider {
	static let destinations = try! Array(Realm().objects(HTBDestination.self))
	
	static var previews: some View {
		DestinationsCardView(state: "Michigan", code: "MI", destinations: destinations)
	}
}
