import SwiftUI
import MapKit

class DestinationMapCoordinator: NSObject, MKMapViewDelegate {
	var parent: DestinationMapView
	
	init(_ parent: DestinationMapView) {
		self.parent = parent
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		// Make a fast exit if the annotation is not our custom type, so we fallback to defaults
		guard annotation.isKind(of: DestinationAnnotation.self) else {
			Debug.log(ident: "not kind of DestinationAnnotation", data: type(of: annotation))
			return nil
		}
		
		let identifier = "destination"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
		
		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView?.canShowCallout = true
			annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		else {
			annotationView?.annotation = annotation
		}
				
		if let customAnnotation = annotation as? DestinationAnnotation {
			annotationView?.image = customAnnotation.image
		}
		
		return annotationView
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
		addCityAnnotation(mapView: mapView)
		
		return mapView
	}
	
	func updateUIView(_ mapView: MKMapView, context: Context) {
		addCoffeeShops(mapView: mapView)
	}
	
	func makeCoordinator() -> DestinationMapCoordinator {
		DestinationMapCoordinator(self)
	}
	
	private func addCityAnnotation(mapView: MKMapView) {
		if destination.latitude >= -90 && destination.latitude <= 90 {
			let coordinate = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
			let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = destination.title
			mapView.addAnnotation(annotation)
			mapView.centerCoordinate = coordinate
			mapView.setRegion(region, animated: true)
		}
		else {
			Debug.log(ident: "Geocoding request in DestinationMapView", data: destination)
			DestinationController.geocode(destination: destination)
		}
	}
	
	private func addCoffeeShops(mapView: MKMapView) {
		for coffeeShop in cafes.venues {
			let coordinate = CLLocationCoordinate2D(latitude: coffeeShop.venue.location.lat, longitude: coffeeShop.venue.location.lng)
			let annotation = DestinationAnnotation(coordinate: coordinate, type: .coffee)
			annotation.title = coffeeShop.venue.name
			mapView.addAnnotation(annotation)
		}
	}
}
