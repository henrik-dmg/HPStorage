import Foundation

extension NSError {

	convenience init(code: Int, description: String, domain: String) {
		let dictionary = [NSLocalizedDescriptionKey: description]
		self.init(domain: domain, code: code, userInfo: dictionary)
	}

	convenience init(code: Int, description: String) {
		self.init(code: code, description: description, package: "HPStorage")
	}

	convenience init(code: Int, description: String, package: String) {
		self.init(code: code, description: description, domain: "dev.panhans.\(package)")
	}

	static let unknown = NSError(code: 1, description: "Unknown error")
	static let fileDoesNotExist = NSError(code: 7, description: "File does not exist")
	static let unknownContainer = NSError(code: 8, description: "Could not find container URL for specified app group")
	static let unknownDirectory = NSError(code: 9, description: "Could not find URL for specified directory")

}
