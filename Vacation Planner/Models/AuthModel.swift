import Foundation

struct AuthModel {
	var token: String?
	
	static func getSession() -> String? {
		return UserDefaults.standard.string(forKey: Constants.UserDefaults.vocSessionToken)
	}
	
	static func setSession(token: String?) -> Void {
		UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isUser)
		UserDefaults.standard.set(token, forKey: Constants.UserDefaults.vocSessionToken)
	}
}
