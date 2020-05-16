import Foundation
import SwiftUI
import RealmSwift

class DestinationController: ObservableObject {
	@Published var destinations = [HTBDestination]()
	@Published var total = 0
	@Published var groupedByState: Dictionary<String, [HTBDestination]> = [:]
	
	private var records = 0
	private var cursor = 0
	private var maxCursor = 1
	
	init() {
		refreshState()
		fetchNext()
	}
	
	public func byState(code: String) -> [HTBDestination] {
		if groupedByState.count == 0 {
			groupedByState = Dictionary(grouping: destinations, by: { $0.state })
		}
		
		return (groupedByState[code] ?? []).sorted(by: { (r1: HTBDestination, r2: HTBDestination) in
			return r1.title < r2.title
		})
	}
	
	func refreshState() {
		let realm = try! Realm()
		let records = Array(realm.objects(HTBDestination.self))
		self.destinations = records
		self.total = records.count
		self.records = records.count
	}
	
	func fetchNext() {
		if (cursor >= maxCursor) {
			refreshState()
			return
		}

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
			
			if (self.records == resource.total) {
				Debug.log(ident: "DestinationController.fetchNext()", data: "API and local storage match. Skipping additional requests.")
				return
			}
			
			if (self.cursor == 0) {
				self.total = resource.total
				self.maxCursor = Int(ceil(Double(resource.total) / 100.0))
			}
			
			self.cursor += 1
			
			Debug.log(ident: "Request Destinations", data: "cursor: \(self.cursor), max: \(self.maxCursor), from: \(from), to: \(to)")
			
			DispatchQueue(label: "app.controllers.destinations.fetch").async {
				var destinations: [HTBDestination] = []
				for destination in resource.destinations {
					destination.title = destination.rawName.content
					destination.zones = destination.rawZones.map { $0.name }.joined(separator: ",")
					
					if destination.countryCode == "US" {
						let parts = destination.title.split(separator: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
						
						if parts.count == 2 {
							destination.title = parts[0]
							destination.state = parts[1]
							destination.address = "\(parts[0]), \(parts[1])"
						}
					}
					
					destinations.append(destination)
				}
				
				let realm = try! Realm()
				try! realm.write {
					realm.add(destinations, update: .modified)
				}
			}
			
			
			Debug.log(ident: "Destinations loop: ", data: "Total: \(self.total), Records: \(self.records)")
			if self.total > self.records {
				self.fetchNext()
			}
		}
	}
	
	static func geocode(destination: HTBDestination) {
		guard destination.latitude == 0 else {
			Debug.log(ident: "No need to geocode", data: "")
			return
		}
		
		Location.getCoordinate(address: destination.address) { location, error in
			guard error == nil else {
				Debug.log(ident: "Error in DestinationController.geocode()", data: error!)
				return
			}
			
			let realm = try! Realm()
			if let destination = realm.object(ofType: HTBDestination.self, forPrimaryKey: destination.code) {
				try! realm.write {
					destination.latitude = location.latitude
					destination.longitude = location.longitude
				}
				
				Debug.log(ident: "Geocoded", data: destination)
			}
		}
		
	}
}

