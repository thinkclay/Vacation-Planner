import SwiftUI

struct AuthView: View {
	@ObservedObject var appState: AppState
	@State var authResponse: AuthResponse?
	@State var username: String = "clay@unicornagency.com"
	@State var password: String = "9Fw2SXnUfePiEFQ"
	
	var body: some View {
		VStack(alignment: .leading) {			
			if authResponse != nil && authResponse?.errors != nil {
				ForEach(authResponse?.errors ?? [], id: \.self) {
					Text("\($0)")
				}
			}
			
			NeueTextInput(text: $username, title: "Email")
			NeueTextInput(text: $password, title: "Password", secure: true)
			
			Button(action: submitHandler) {
				HStack {
					Text("Login")
					
					Image(systemName: "arrow.right")
						.resizable()
						.foregroundColor(.white)
						.frame(width: 15, height: 15)
				}
				.frame(minWidth: 0, maxWidth: .infinity)
				.padding()
				.background(Color.blue)
				.foregroundColor(Color.white)
				.cornerRadius(5)
			}
			.padding(.top, 15)
		}
		.navigationBarTitle(Text("Login"), displayMode: .inline)
		.padding(.horizontal, 20)
	}
	
	func submitHandler() {
		AuthService.shared.login(email: username, password: password) { data, response, error in
			if let data = data {
				if let response = try? JSONDecoder().decode(AuthResponse.self, from: data) {
					// we have good data – go back to the main thread
					DispatchQueue.main.async {
						if response.data != nil {
							let token = Data("\(self.username)-\(self.password)".utf8).base64EncodedString()
							AuthModel.setSession(token: token)
							self.appState.isAuthenticated = true
							self.appState.currentPage = .destinations
						}
						
						// We didn't receive a valid auth, let's update our UI with errors
						self.authResponse = response
					}
					
					// everything is good, so we can exit
					return
				}
			}
			
			// if we're still here it means there was a problem
			Debug.log(ident: "Fetch failed in AuthView", data: error?.localizedDescription ?? "Unknown error")
		}
	}
}


