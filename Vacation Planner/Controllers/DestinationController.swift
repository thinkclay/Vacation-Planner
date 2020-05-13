import Foundation
import SwiftUI
import RealmSwift

class DestinationObserver: ObservableObject {
	@Published var destinations = [HTBDestination]()
	@Published var total = 0
	
	private var storeCount = try! Realm().objects(HTBDestination.self).count
	private var cursor = 0
	private var maxCursor = 1
	
	init() {
		fetchNext()
	}
	
	//	func getNext() {
	//		if (cursor >= maxCursor) {
	//			return
	//		}
	//
	//		let from = (cursor * 100) + 1
	//		let to = (cursor * 100) + 100
	//		let params: [String: Any] = [ "from": from, "to": to ]
	//
	//		HBService.shared.getDestinations(params: params) { response in
	//			if let resource = response.value {
	//				if (self.cursor == 0) {
	//					self.total = resource.total
	//					self.maxCursor = Int(ceil(Double(resource.total) / 100.0))
	//				}
	//
	//				self.cursor += 1
	//
	//				self.destinations += resource.all
	//
	//				Debug.log(ident: "Request Destinations", data: "cursor: \(self.cursor), max: \(self.maxCursor), from: \(from), to: \(to)")
	//
	//				self.getNext()
	//			}
	//			else {
	//				Debug.log(ident: "Could not fetch or decode destinations", data: response)
	//			}
	//		}
	//	}
	
	func fetchNext() {
		if (cursor >= maxCursor) {
			return
		}

//		let realm = try! Realm()
		let from = (cursor * 100) + 1
		let to = (cursor * 100) + 100
		let params: [String: Any] = [ "from": from, "to": to ]
		
		HTBService.shared.getDestinations(params: params) { data, response, error in
			guard let data = data else {
				Debug.log(ident: "Fetch failed in DestinationController", data: error ?? "Unknown error")
				return
			}
			
			guard let resource = try? JSONDecoder().decode(HTBDestinationResponse.self, from: data) else {
				Debug.log(ident: "Decoding failed in DestinationController", data: response ?? "Unknown error")
				return
			}
			
			if (self.cursor == 0) {
				self.total = resource.total
				self.maxCursor = Int(ceil(Double(resource.total) / 100.0))
			}
			
			self.cursor += 1
//			self.destinations += resource.destinations
			
			Debug.log(ident: "Request Destinations", data: "cursor: \(self.cursor), max: \(self.maxCursor), from: \(from), to: \(to)")
			
			DispatchQueue(label: "app.controllers.destinations.batchWrite").async {
				let realm = try! Realm()
				for destination in resource.destinations {
					try! realm.write {
						destination.title = destination.rawName.content
						destination.zones = destination.rawZones.map { $0.name }.joined(separator: ",")
						realm.add(destination, update: .modified)
					}
				}
			}
			
			if self.total < self.storeCount {
				self.fetchNext()
			}
		}
	}
}

