import XCTest

class BaseTestCase: XCTestCase {

	var baseURL: URL {
		FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".HPStorage")
	}

	var testFileURL: URL {
		baseURL.appendingPathComponent("Tests/codable.json")
	}

	func cleanUp() throws {
		if FileManager.default.fileExists(atPath: testFileURL.path) {
			try FileManager.default.removeItem(at: testFileURL)
		}
	}

}
