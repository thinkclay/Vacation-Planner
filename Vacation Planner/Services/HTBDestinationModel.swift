import Foundation
import RealmSwift

struct HTBZone: Codable {
	let zoneCode: Int
	let name: String
	let zoneDescription: HTBName
	
	enum CodingKeys: String, CodingKey {
		case zoneCode, name
		case zoneDescription = "description"
	}
}

struct HTBName: Codable {
	let content: String
}

@objcMembers
class HTBDestination: Object, Codable, Identifiable {
	dynamic var code: String
	dynamic var title: String = ""
	dynamic var countryCode, isoCode: String
	dynamic var address: String = ""
	dynamic var latitude: Double = 0.0
	dynamic var longitude: Double = 0.0
	dynamic var state: String = ""
	dynamic var zones = ""
	
	let name: HTBName
	let rawZones: [HTBZone]
	let groupZones: [JSONAny]
	
	enum CodingKeys: String, CodingKey {
		case code, countryCode, isoCode, groupZones, name
		case rawZones = "zones"
	}
	
	override static func primaryKey() -> String? {
		return "code"
	}
}

struct HTBDestinationResponse: Codable {
	let from, to, total: Int
	let auditData: HTBAudit
	let destinations: [HTBDestination]
}
