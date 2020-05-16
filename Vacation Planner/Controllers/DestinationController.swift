import Foundation
import SwiftUI
import RealmSwift

class DestinationObserver: ObservableObject {
	@Published var destinations = [HTBDestination]()
	@Published var total = 0
	@Published var groupedByState: Dictionary<String, [HTBDestination]> = [:]
	
	private var storeCount = try! Realm().objects(HTBDestination.self).count
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
		destinations = records
		total = records.count
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
			
			if (self.cursor == 0) {
				self.total = resource.total
				self.maxCursor = Int(ceil(Double(resource.total) / 100.0))
			}
			
			self.cursor += 1
			
			Debug.log(ident: "Request Destinations", data: "cursor: \(self.cursor), max: \(self.maxCursor), from: \(from), to: \(to)")
			
			DispatchQueue(label: "app.controllers.destinations.batchWrite").async {
				let realm = try! Realm()
				for destination in resource.destinations {
					try! realm.write {
						destination.title = destination.rawName.content
						
						if destination.countryCode == "US" {
							let parts = destination.title.split(separator: "-")
							if parts.count == 2 {
								destination.title = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
								destination.state = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
							}
						}
						
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

