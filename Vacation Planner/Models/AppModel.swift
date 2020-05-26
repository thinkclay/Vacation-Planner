import Foundation
import Combine
import RealmSwift

class AppState: ObservableObject {
	let objectWillChange = PassthroughSubject<AppState, Never>()
	
	enum mode {
		case development, staging, production
	}
	
	enum routes {
		case onboarding, auth, destinations
	}
	
	var currentPage: routes = .onboarding {
		didSet {
			objectWillChange.send(self)
		}
	}
	
	var isUser: Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaults.isUser) {
		didSet {
			UserDefaults.standard.set(isUser, forKey: Constants.UserDefaults.isUser)
			objectWillChange.send(self)
		}
	}
	
	var isAuthenticated: Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaults.vocSessionToken) {
		didSet {
			objectWillChange.send(self)
		}
	}
	
	var hotelsCount: Int = 0 {
		didSet {
			objectWillChange.send(self)
		}
	}
	
	static func setDefaultRealm(version: String) {
		var config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 3,
			
			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion < 1) {
					// Nothing to do!
					// Realm will automatically detect new properties and removed properties
					// And will update the schema on disk automatically
				}
		})
		
		// Use the default directory, but replace the filename with the username
		config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("appV\(version).realm")
		
		Debug.log(ident: "Realm Location", data: Realm.Configuration.defaultConfiguration.fileURL!)
		
		// Set this as the configuration used for the default Realm
		Realm.Configuration.defaultConfiguration = config
	}
}
