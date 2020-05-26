import Foundation
import RealmSwift

struct HTBCoordinates: Codable {
	let longitude, latitude: Double
}

struct HTBFacility: Codable {
	let facilityCode, facilityGroupCode, order: Int
	let indYesOrNo: Bool?
	let number: Int?
	let voucher: Bool
	let indLogic, indFee: Bool?
	let distance: Int?
	let timeFrom, timeTo: String?
}

struct HTBImage: Codable {
	let imageTypeCode, path: String
	let order, visualOrder: Int
	let roomCode, roomType, characteristicCode: String?
}

struct HTBInterestPoint: Codable {
	let facilityCode, facilityGroupCode, order: Int
	let poiName, distance: String
}

struct HTBPhone: Codable {
	let phoneNumber, phoneType: String
}

struct HTBRoom: Codable {
	let roomCode, roomType, characteristicCode: String
	let roomFacilities: [HTBRoomFacility]?
	let roomStays: [HTBRoomStay]?
}

struct HTBRoomFacility: Codable {
	let facilityCode, facilityGroupCode: Int
	let number: Int?
	let indYesOrNo, voucher: Bool
}

struct HTBRoomStay: Codable {
	let stayType, order, roomStayDescription: String
	let roomStayFacilities: [HTBRoomStayFacility]
	
	enum CodingKeys: String, CodingKey {
		case stayType, order
		case roomStayDescription = "description"
		case roomStayFacilities
	}
}

struct HTBRoomStayFacility: Codable {
	let facilityCode, facilityGroupCode, number: Int
}

struct HTBTerminal: Codable {
	let terminalCode: String
	let distance: Int
}

struct HTBWildcard: Codable {
	let roomType, roomCode, characteristicCode: String
	let hotelRoomDescription: HTBName
}

@objcMembers
class HTBHotel: Object, Codable, Identifiable {
	dynamic var code: Int
	dynamic var title: String = ""
	dynamic var countryCode, stateCode, destinationCode: String
	dynamic var zoneCode: Int
	dynamic var categoryCode, categoryGroupCode, chainCode, accommodationTypeCode: String
	dynamic var postalCode: String
	dynamic var email, license: String
	dynamic var web: String
	dynamic var lastUpdate, s2C: String
	dynamic var ranking: Int
	
	let name, hotelDescription: HTBName
	let boardCodes: [String]
	let segmentCodes: [Int]
	let coordinates: HTBCoordinates
	let address: HTBName
	let city: HTBName
	let phones: [HTBPhone]
	let rooms: [HTBRoom]
	let facilities: [HTBFacility]
	let terminals: [HTBTerminal]
	let interestPoints: [HTBInterestPoint]
	let images: [HTBImage]
	let wildcards: [HTBWildcard]
	
	enum CodingKeys: String, CodingKey {
		case code
		case hotelDescription = "description"
		case name, countryCode, stateCode, destinationCode, zoneCode, coordinates, categoryCode, categoryGroupCode, chainCode, accommodationTypeCode, boardCodes, segmentCodes, address, postalCode, city, email, license, phones, rooms, facilities, terminals, interestPoints, images, wildcards, web, lastUpdate
		case s2C = "S2C"
		case ranking
	}
	
	override static func primaryKey() -> String? {
		return "code"
	}
	
	override class func ignoredProperties() -> [String] {
		return ["boardCodes", "segmentCodes"]
	}
}

struct HTBHotelResponse: Codable {
	let from, to, total: Int
	let auditData: HTBAudit
	let hotels: [HTBHotel]
}
