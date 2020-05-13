import Foundation

struct VOCService {
	public enum mode {
		case development, production
	}
	
	public static var shared = VOCService(mode: .development)
	
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
	
	//	MARK: - getHotels()
	/*
	requestParams:
		page: [Optional] Page Number
		filter:
			destination_code: [Optional] - Return hotels filtered by a destination
			code: 							[Optional] - Return hotels filtered by a hotel code
			name:								[Optional] - Return hotels filtered with a prefix name
			lat:								[Optional] - Return hotels within a 20 mile radius of (lat, long) coordinates. Requires long.
			long:							 	[Optional] - Return hotels within a 20 mile radius of (lat, lng) coordinates. Requires lat.
			include:					 	[Optional] - Comma separated string of associated records (images, featured_images, hotels_facilities, rooms)
	*/
	public func getHotels(params: [String: Any], handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let url = "\(baseUrl)/hotel_beds/hotels"
		APIHelper.buildRequest(url: url, params: params, handler: handler)
	}
}

