import Foundation
import SwiftUI
import RealmSwift

class HotelController: ObservableObject {
	@Published var hotels = [HTBHotel]()
	@Published var total = 0
	@Published var groupedByState: Dictionary<String, [HTBHotel]> = [:]
	
	private var records = 0
	private var cursor = 0
	private var maxCursor = 1
	
	init() {
		refreshState()
		fetchNext()
	}
	
	func refreshState() {
		let realm = try! Realm()
		let records = Array(realm.objects(HTBHotel.self))
		self.hotels = records
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
		
		HTBService.shared.getHotels(params: params) { data, response, error in
			guard let data = data else {
				Debug.log(ident: "Fetch failed in HotelController", data: error ?? "Unknown error")
				return
			}
			
			guard let resource = try? JSONDecoder().decode(HTBHotelResponse.self, from: data) else {
				Debug.log(ident: "Decoding failed in HotelController", data: response ?? "Unknown error")
				return
			}
			
			if (self.records == resource.total) {
				Debug.log(ident: "HotelController.fetchNext()", data: "API and local storage match. Skipping additional requests.")
				return
			}
			
			if (self.cursor == 0) {
				self.total = resource.total
				self.maxCursor = Int(ceil(Double(resource.total) / 100.0))
			}
			
			self.cursor += 1
			
			Debug.log(ident: "Request Hotels", data: "cursor: \(self.cursor), max: \(self.maxCursor), from: \(from), to: \(to)")
			
			DispatchQueue(label: "app.controllers.hotels.fetch").async {
				var hotels: [HTBHotel] = []
				for hotel in resource.hotels {
					hotels.append(hotel)
				}
				
				let realm = try! Realm()
				try! realm.write {
					realm.add(hotels, update: .modified)
				}
			}
			
			
			Debug.log(ident: "Hotels loop: ", data: "Total: \(self.total), Records: \(self.records)")
			if self.total > self.records {
				self.fetchNext()
			}
		}
	}
}

