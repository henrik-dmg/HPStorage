import Foundation

extension NSError {

	func withDescription(_ message: String) -> NSError {
		var dict = userInfo
		dict[NSLocalizedDescriptionKey] = message
		return NSError(domain: domain, code: code, userInfo: dict)
	}

	convenience init(code: Int = 1, description: String, domain: String) {
		let dictionary = [NSLocalizedDescriptionKey: description]
		self.init(domain: domain, code: code, userInfo: dictionary)
	}

	convenience init(code: Int = 1, description: String) {
		self.init(code: code, description: description, package: "HPStorage")
	}

	convenience init(code: Int = 1, description: String, package: String) {
		self.init(code: code, description: description, domain: "dev.panhans.\(package)")
	}

	static let unknown = NSError(code: 1, description: "Unknown error")

}
