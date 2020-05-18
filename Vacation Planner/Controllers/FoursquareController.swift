import Foundation
import SwiftUI
import RealmSwift

class FoursquareController: ObservableObject {
	@Published var venues = [FSQGroupItem]()
	
	init(params: [String: String]) {
		FSQService.shared.getVenues(params: params) { data, response, error in
			guard error == nil else {
				Debug.log(ident: "Decoding failed in FSQ Controller", data: error ?? "Unknown error")
				return
			}
			
			guard let data = data else {
				Debug.log(ident: "Fetch failed in FSQ Controller", data: error ?? "Unknown error")
				return
			}
			
			do {
				let resource = try JSONDecoder().decode(FSQRootResponse.self, from: data)
				self.venues = resource.response.groups[0].items
			}
			catch {
				Debug.log(ident: "Caught error", data: error)
			}
		}
	}
}

