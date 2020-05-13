import SwiftUI
import Combine

enum NeueTextInputState {
	case normal, active
}

protocol NeueTextInputStyle {
	static var background: Color { get }
	static var border: Color { get }
	static var color: Color { get }
	static var placeholder: Color { get }
}

struct NeueTextInput: View {
	@Binding var text: String
	@State var hasFocus: Bool = false
	@State var style: NeueTextInputStyle = NeueTextInputStyles.normal()
	
	var title = ""
	var secure = false
	var error = ""
	
	var body: some View {
		
		ZStack(alignment: .bottom) {
			ZStack(alignment: .leading) {
				Text(text.isEmpty ? title : "\(title): \(error)")
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.foregroundColor(type(of: style).placeholder)
					.padding()
					.offset(y: hasFocus || !text.isEmpty ? -40 : 0)
					.font(hasFocus || !text.isEmpty ? Font.caption : Font.body)
					.animation(.default)
				
				TextField("", text: $text, onEditingChanged: changeHandler).autocapitalization(.none).padding()
			}
			.background(type(of: style).background)
			.foregroundColor(type(of: style).color)
			
			Rectangle().fill(type(of: style).border).frame(height: 2).animation(.default)

		}
		.padding(.top, 20)
	}
	
	private func changeHandler(hasFocus: Bool) -> Void {
		if hasFocus {
			self.style = NeueTextInputStyles.active()
		}
		else {
			self.style = NeueTextInputStyles.normal()
		}
		
		self.hasFocus = hasFocus
	}
}
