import Foundation
import CryptoKit

struct HBHelper {
	public static func signature(key: String, secret: String) -> String {
		let sigPayload = key + secret + String(format: "%.0f", Date().timeIntervalSince1970)
		return SHA256.hash(data: Data(sigPayload.utf8)).compactMap { String(format: "%02x", $0) }.joined()
	}
}
