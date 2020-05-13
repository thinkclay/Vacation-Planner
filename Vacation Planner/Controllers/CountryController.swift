import Foundation

class CountryObserver: ObservableObject {
	@Published var countries = [HBCountry]()
	
	init() {
		HBService.shared.getCountries(completionHandler: { response in
			if let resource = response.value {
				self.countries = resource.all
			}
			else {				
				Debug.log(ident: "Could not fetch or decode countries", data: response)
			}
		})
	}
}
