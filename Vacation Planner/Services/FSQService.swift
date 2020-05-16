import Foundation
import CryptoKit

struct FSQService {
	public enum mode {
		case development, production
	}
	
	public static var shared = FSQService(mode: .development)
	
	private let key: String = "JKPOFKUJIKI4XWMKDSQDY0AF0EH53SYBZ4HPDAVUGSAZRQD4"
	private let secret: String = "UH2NME3QHMQHGCFVQJ1GCUC4NTN54J2CRWLMQRIKPG0MKIXA"
	private let version: String = "20180323"
	private var baseUrl: String
	private var baseHeaders: [String: String] = [:]
	private var baseParams: [String: String] = [:]
	
	init(mode: mode) {
		switch (mode) {
			case .development:
				baseUrl = "https://api.foursquare.com/v2"
			case .production:
				baseUrl = "https://api.foursquare.com/v2"
		}
		
		baseParams["client_id"] = key
		baseParams["client_secret"] = secret
		baseParams["v"] = version
	}
	
	//	MARK: - getVenues()
	public func getVenues(params: [String: String] = [:], handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let url = "\(baseUrl)/venues/explore"
		var parameters = params
		parameters.merge(baseParams) { (_, new) in new }
		APIHelper.buildRequest(url: url, params: parameters, headers: baseHeaders, handler: handler)
	}
}

// MARK: - Meta
struct FSQMeta: Codable {
	let code: Int
	let requestID: String
	
	enum CodingKeys: String, CodingKey {
		case code
		case requestID = "requestId"
	}
}

struct FSQRootResponse: Codable {
	let meta: FSQMeta
	let response: FSQResponse
}

// MARK: - Response
struct FSQResponse: Codable {
	let suggestedFilters: FSQSuggestedFilters?
	let warning: FSQWarning?
	let suggestedRadius: Int
	let headerLocation, headerFullLocation, headerLocationGranularity, query: String
	let totalResults: Int
	let suggestedBounds: FSQSuggestedBounds
	let groups: [FSQGroup]
}

// MARK: - Group
struct FSQGroup: Codable {
	let type, name: String
	let items: [FSQGroupItem]
}

// MARK: - GroupItem
struct FSQGroupItem: Codable {
	let reasons: FSQReasons
	let venue: FSQVenue
	let referralID: String
	
	enum CodingKeys: String, CodingKey {
		case reasons, venue
		case referralID = "referralId"
	}
}

// MARK: - Reasons
struct FSQReasons: Codable {
	let count: Int
	let items: [FSQReasonsItem]
}

// MARK: - ReasonsItem
struct FSQReasonsItem: Codable {
	let summary, type, reasonName: String
}

// MARK: - Venue
struct FSQVenue: Codable {
	let id, name: String
	let contact: FSQContact
	let location: FSQLocation
	let categories: [FSQCategory]
	let verified: Bool
	let stats: FSQStats
	let beenHere: FSQBeenHere
	let photos: FSQPhotos
	let venuePage: FSQVenuePage?
	let hereNow: FSQHereNow
}

// MARK: - BeenHere
struct FSQBeenHere: Codable {
	let count, lastCheckinExpiredAt: Int
	let marked: Bool
	let unconfirmedCount: Int
}

// MARK: - Category
struct FSQCategory: Codable {
	let id, name, pluralName, shortName: String
	let icon: FSQIcon
	let primary: Bool
}

// MARK: - Icon
struct FSQIcon: Codable {
	let iconPrefix: String
	let suffix: String
	
	enum CodingKeys: String, CodingKey {
		case iconPrefix = "prefix"
		case suffix
	}
}

// MARK: - Contact
struct FSQContact: Codable {
}

// MARK: - HereNow
struct FSQHereNow: Codable {
	let count: Int
	let summary: String
//	let groups: [JSONAny]
}

// MARK: - Location
struct FSQLocation: Codable {
	let address: String?
	let crossStreet: String?
	let lat, lng: Double
	let labeledLatLngs: [FSQLabeledLatLng]
	let distance: Int
	let postalCode: String?
	let cc, city, state: String
	let country: String
	let formattedAddress: [String]
}

// MARK: - LabeledLatLng
struct FSQLabeledLatLng: Codable {
	let label: String
	let lat, lng: Double
}

// MARK: - Photos
struct FSQPhotos: Codable {
	let count: Int
//	let groups: [JSONAny]
}

// MARK: - Stats
struct FSQStats: Codable {
	let tipCount, usersCount, checkinsCount, visitsCount: Int
}

// MARK: - VenuePage
struct FSQVenuePage: Codable {
	let id: String
}

// MARK: - SuggestedBounds
struct FSQSuggestedBounds: Codable {
	let ne, sw: FSQNe
}

// MARK: - Ne
struct FSQNe: Codable {
	let lat, lng: Double
}

// MARK: - SuggestedFilters
struct FSQSuggestedFilters: Codable {
	let header: String
	let filters: [FSQFilter]
}

// MARK: - Filter
struct FSQFilter: Codable {
	let name, key: String
}

// MARK: - Warning
struct FSQWarning: Codable {
	let text: String
}
