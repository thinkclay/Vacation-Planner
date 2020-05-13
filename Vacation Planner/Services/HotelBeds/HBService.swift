import Foundation
import Alamofire

struct HBService {
	let apiKey: String = "zjpwfn7pbeufupd7ub2eme97"
	let apiSecret: String = "J6n8vzyXuS"
	
	var baseUrl: String = "https://api.test.hotelbeds.com"
	var baseHeaders: HTTPHeaders = []
	
	static let shared = HBService()
	
	init() {
		baseHeaders["Api-key"] = apiKey
		baseHeaders["secret"] = apiSecret
		baseHeaders["X-Signature"] = HBHelper.signature(key: apiKey, secret: apiSecret)
	}
	
	func getCountries(completionHandler: @escaping (AFDataResponse<HBCountries>) -> Void) {
		let url: String = "\(baseUrl)/hotel-content-api/1.0/locations/countries"
		
		AF
			.request(url, headers: baseHeaders)
			.validate()
			.responseDecodable(of: HBCountries.self, completionHandler: completionHandler)
	}
}
