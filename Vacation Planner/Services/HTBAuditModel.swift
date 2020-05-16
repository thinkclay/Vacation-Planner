import Foundation

struct HTBName: Codable {
	let content: String
}

struct HTBAudit: Codable {
	let processTime, timestamp, requestHost, serverID: String
	let environment, release: String
	
	enum CodingKeys: String, CodingKey {
		case processTime, timestamp, requestHost
		case serverID = "serverId"
		case environment, release
	}
}
