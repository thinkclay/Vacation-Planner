import SwiftUI

struct CountryView: View {
	
	@ObservedObject var countriesObserver = CountryObserver()
	
	var body: some View {
		NavigationView {
			List(countriesObserver.countries) { item in
				CountryRowView(record: item)
			}
			.navigationBarTitle("Countries")
		}
	}
}

struct CountryView_Previews: PreviewProvider {
	static var previews: some View {
		CountryView()
	}
}

