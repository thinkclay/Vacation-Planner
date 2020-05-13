import Foundation

struct Debug {
	
	static func log(ident: String, data: Any) -> Void {
		#if DEBUG
		debugPrint("----")
		debugPrint(ident)
		debugPrint(data)
		#endif
	}
}
