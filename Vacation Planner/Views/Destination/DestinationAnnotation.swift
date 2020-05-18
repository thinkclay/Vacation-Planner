import Foundation
import MapKit

class DestinationAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var image: UIImage
	var title: String?
	var type: DestinationType
	
	enum DestinationType {
		case coffee
	}
	
	init(coordinate: CLLocationCoordinate2D, type: DestinationType) {
		self.coordinate = coordinate
		self.type = type
		
		switch (type) {
			case .coffee:
				self.image = UIImage(named: "IconCoffee")!.tint(with: UIColor.brown)!
		}
	}
}
