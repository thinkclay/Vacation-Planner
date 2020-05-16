import SwiftUI
import RealmSwift

struct StateCardView: View {
	let stateLabel: String
	let stateCode: String
	
	var body: some View {
		NavigationLink(destination: DestinationListView(stateLabel: stateLabel, stateCode: stateCode)) {
			HStack {
				VStack(alignment: .leading) {
//					NeueAsyncImage(
//						url: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg",
//						placeholder: Text("Loading ...")
//					).aspectRatio(contentMode: .fit)
					
					Text(stateLabel)
						.font(.title)
						.foregroundColor(Color("Neutral700"))
						.fontWeight(.bold)
				}
				.layoutPriority(100)
				
				Spacer()
			}
			.padding()
			.background(Blur(style: .systemUltraThinMaterial))
			.background(Color("Neutral300").opacity(0.5))
		}
		.frame(minHeight: 300, alignment: .bottom)
		.background(Image(stateCode, bundle: Bundle.init(identifier: "States")))
		.cornerRadius(10)
		.padding([.horizontal, .top])
	}
}

struct StateCardView_Previews: PreviewProvider {
	static let destinations = try! Array(Realm().objects(HTBDestination.self))
	
	static var previews: some View {
		StateCardView(stateLabel: "Michigan", stateCode: "MI")
	}
}
