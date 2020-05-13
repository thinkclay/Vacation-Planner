import Foundation
import CryptoKit

struct HTBService {
	public enum mode {
		case development, production
	}
	
	public static var shared = HTBService(mode: .development)
	
	private let key: String = "zjpwfn7pbeufupd7ub2eme97"
	private let secret: String = "J6n8vzyXuS"
	private var token: String?
	private var baseUrl: String
	private var baseHeaders: [String: String] = [:]
	
	init(mode: mode) {
		switch (mode) {
			case .development:
				baseUrl = "https://api.test.hotelbeds.com"
			case .production:
				baseUrl = "https://corporate.vacationoffer.com"
		}
		
		let sigPayload = key + secret + String(format: "%.0f", Date().timeIntervalSince1970)
		token = SHA256.hash(data: Data(sigPayload.utf8)).compactMap { String(format: "%02x", $0) }.joined()
		
		baseHeaders["Api-key"] = key
		baseHeaders["secret"] = secret
		baseHeaders["X-Signature"] = token
	}
	
	//	MARK: - getDestinations()
	public func getDestinations(params: [String: Any] = [:], handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let url = "\(baseUrl)/hotel-content-api/1.0/locations/destinations"
		var parameters: [String: Any] = [
			"fields": "all",
			"countryCodes": "US",
			"language": "ENG",
			"from": 1,
			"to": 5,
			"useSecondaryLanguage": false
		]
		parameters.merge(params) { (_, new) in new }
		
		APIHelper.buildRequest(url: url, params: parameters, headers: baseHeaders, handler: handler)
	}
}

