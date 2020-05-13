import Foundation
import SwiftUI

struct NeueTextInputStyles {
	struct normal: NeueTextInputStyle {
		static let background = Color(red: 0.9, green: 0.97, blue: 1.00)
		static let border = Color.clear
		static let color = Color(red: 0.07, green: 0.45, blue: 0.87)
		static let placeholder = Color(red: 0.35, green: 0.44, blue: 0.52)
	}
	
	struct active: NeueTextInputStyle {
		static let background = Color(red: 0.85, green: 0.92, blue: 1.00)
		static let border = Color(red: 0.0, green: 0.35, blue: 0.77)
		static let color = Color(red: 0.0, green: 0.40, blue: 0.82)
		static let placeholder = Color(red: 0.30, green: 0.39, blue: 0.47)
	}
}
