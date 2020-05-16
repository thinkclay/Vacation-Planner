import SwiftUI
import MapKit

class DestinationMapCoordinator: NSObject, MKMapViewDelegate {
	var parent: DestinationMapView
	
	init(_ parent: DestinationMapView) {
		self.parent = parent
	}
}

struct DestinationMapView: UIViewRepresentable {
	@ObservedObject var cafes: FoursquareController
	
	let destination: HTBDestination
	
	init(destination: HTBDestination) {
		self.destination = destination
		
		cafes = FoursquareController(params: [
			"ll": "\(destination.latitude),\(destination.longitude)",
			"query": "coffee",
			"limit": "10"
		])
	}
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		
		if destination.latitude >= -90 && destination.latitude <= 90 {
			let location = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
			let region = MKCoordinateRegion(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
			let annotation = MKPointAnnotation()
			annotation.coordinate = location
			mapView.addAnnotation(annotation)
			mapView.centerCoordinate = location
			mapView.setRegion(region, animated: true)
		}
		else {
			Debug.log(ident: "Geocoding request in DestinationMapView", data: destination)
			DestinationController.geocode(destination: destination)
		}

		return mapView
	}
	
	func updateUIView(_ view: MKMapView, context: Context) {
		Debug.log(ident: "updateUIView", data: cafes.venues)
		
		for coffeeShop in cafes.venues {
			let annotation = MKPointAnnotation()
			annotation.title = coffeeShop.venue.name
			annotation.coordinate = CLLocationCoordinate2D(latitude: coffeeShop.venue.location.lat, longitude: coffeeShop.venue.location.lng)
			view.addAnnotation(annotation)
		}
	}
	
	func makeCoordinator() -> DestinationMapCoordinator {
		DestinationMapCoordinator(self)
	}
}
