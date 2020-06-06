import Foundation
import CryptoKit

struct HTBService {
	public enum mode {
		case development, production
	}
	
	public static var shared = HTBService(mode: .development)
	
	private let key: String = "x5z8jypzw39uhz45z4z5ht99"
	private let secret: String = "Jdn6xje9wt"
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
	
	//	MARK: - getCountries()
	public func getCountries(params: [String: Any] = [:], handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let url = "\(baseUrl)/hotel-content-api/1.0/locations/countries"
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
	
	//	MARK: - getHotels()
	public func getHotels(params: [String: Any] = [:], handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let url = "\(baseUrl)/hotel-content-api/1.0/hotels"
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

