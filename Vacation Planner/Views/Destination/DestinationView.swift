import SwiftUI

struct DestinationView: View {
	
	@ObservedObject var destinationsObserver = DestinationObserver()
	
	@State var searchText: String =  ""
	
	var body: some View {
		VStack  {
			VStack {
				Text("\(destinationsObserver.total) destinations")
				TextField("Search...", text: $searchText)
					.padding(.horizontal, 10)
					.padding(.vertical, 10)
					.background(Color("Neutral100"))
					.cornerRadius(5)
			}
			.padding()
			.background(Color("Neutral300"))
			
			ScrollView {
				ForEach(Countries.US.states.map { $0.key }.sorted(), id: \.self) { state in
					VStack(alignment: .leading) {
						DestinationsCardView(
							state: Countries.US.states[state] ?? "",
							code: state,
							destinations: self.destinationsObserver.byState(code: state)
						)
					}
				}
			}
			.frame(minWidth: 0, maxWidth: .infinity)
		}
	}
	
	func searchHandler(searchText: Binding<String>) {
		debugPrint(searchText)
	}
}

struct DestinationView_Previews: PreviewProvider {
	static var previews: some View {
		DestinationView()
	}
}

