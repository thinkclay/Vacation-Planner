import Foundation
import MapKit

struct Location {
	
	static func getCoordinate(address : String, handler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(address) { (placemarks, error) in
			if error == nil {
				if let placemark = placemarks?[0] {
					let location = placemark.location!
					
					handler(location.coordinate, nil)
					return
				}
			}
			
			handler(kCLLocationCoordinate2DInvalid, error as NSError?)
		}
	}
	
}
