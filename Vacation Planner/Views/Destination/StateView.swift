import SwiftUI

struct StateView: View {
	
	@ObservedObject var destinations = DestinationController()
	
	@State var searchText: String =  ""
	
	var body: some View {
		VStack {
			VStack {
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
						StateCardView(
							stateLabel: Countries.US.states[state] ?? "",
							stateCode: state
						)
					}
				}
			}
			.frame(minWidth: 0, maxWidth: .infinity)
			.navigationBarTitle(Text("\(destinations.total) destinations"), displayMode: .inline)
		}
		
	}
	
	
	func searchHandler(searchText: Binding<String>) {
		debugPrint(searchText)
	}
}

struct StateView_Previews: PreviewProvider {
	static var previews: some View {
		StateView()
	}
}

