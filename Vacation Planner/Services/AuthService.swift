import Foundation

/**
	AuthService
	
	This struct represents a custom authentication layer.
	You will want to swap this out with whatever authentication provider you use.
	This could be Auth0, Firebase, or a proprietary platform
	For this example, we do a simple username/password authentication

	usage: VOCService.shared.login("user@email.com", "password") { data, response, error in }
*/
struct AuthService {
	public enum mode {
		case development, production
	}
	
	public static var shared = AuthService(mode: .development)
	
	private var token: String?
	private var baseUrl: String
	private var baseHeaders: [String: String] = [:]
	
	init(mode: mode) {
		switch (mode) {
			case .development:
				 baseUrl = "https://corporate.vocstaging.com"
			case .production:
				baseUrl = "https://corporate.vacationoffer.com"
		}
		
		if let authSession = AuthModel.getSession() {
			self.token = authSession
			baseHeaders["authentication-token"] = authSession
		}
	}
	
	// MARK: - login()
	public func login(email: String, password: String, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let url = "\(baseUrl)/auth/sign_in"
		let params = ["email": email, "password": password]
		APIHelper.buildRequest(url: url, params: params, method: .post, handler: handler)
	}
}

