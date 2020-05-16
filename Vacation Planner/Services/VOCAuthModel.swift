import Foundation

struct VOCAuthModel: Codable, Equatable {
	let id: Int
	let email: String
	var token: String?
}

struct VOCAuthResponse: Codable, Equatable, Identifiable {
	static func == (lhs: VOCAuthResponse, rhs: VOCAuthResponse) -> Bool {
		return lhs.data == rhs.data || lhs.errors == rhs.errors
	}
	
	let id = UUID()
	let data: VOCAuthModel?
	let success: Bool?
	let errors: [String]?
}
