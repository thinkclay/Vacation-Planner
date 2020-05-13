//
// Country
//
// https://api.test.hotelbeds.com/hotel-content-api/1.0/locations/countries?fields=all&language=ENG&from=1&to=100&useSecondaryLanguage=false
//

import Foundation

struct HBCountry: Decodable, Hashable, Identifiable {
	let id: String
	
	enum CodingKeys: String, CodingKey {
		case id = "code"
	}
	
	static func getSample() -> HBCountry {
		return HBCountry(id: "US")
	}
}

struct HBCountries: Decodable, Hashable {
	let total: Int
	let all: [HBCountry]
	
	enum CodingKeys: String, CodingKey {
		case total
		case all = "countries"
	}
}
