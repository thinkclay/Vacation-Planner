import Foundation

/**
AuthModel

This struct respresents a payload returned from our website upon successful authentication
*/
struct AuthModel: Codable, Equatable {
	var token: String?
	
	static func getSession() -> String? {
		return UserDefaults.standard.string(forKey: Constants.UserDefaults.vocSessionToken)
	}
	
	static func setSession(token: String?) -> Void {
		UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isUser)
		UserDefaults.standard.set(token, forKey: Constants.UserDefaults.vocSessionToken)
	}
}

/**
AuthResponse

This is the codable json response from our website.
This gets encoded to a strongly typed struct which includes success, errors, or payload data
*/
struct AuthResponse: Codable, Equatable, Identifiable {
	static func == (lhs: AuthResponse, rhs: AuthResponse) -> Bool {
		return lhs.data == rhs.data || lhs.errors == rhs.errors
	}
	
	let id = UUID()
	let data: AuthModel?
	let success: Bool?
	let errors: [String]?
}
