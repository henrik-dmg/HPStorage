import XCTest
@testable import HPStorage

final class FileUtilityTests: BaseTestCase {

	let utility = FileUtility(directory: .caches())

	override var baseURL: URL {
		FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}

	override var testFileURL: URL {
		baseURL.appendingPathComponent("codable.json")
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		try cleanUp()
	}

	func testWritingToFile() throws {
		let value = DebugCodableStruct(value: 6)
		try utility.writeValue(value, fileName: testFileURL.lastPathComponent)

		XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path))
	}

	func testReadingFromFile() throws {
		let value = DebugCodableStruct(value: 6)
		try utility.writeValue(value, fileName: "codable.json")
		let decodedValue: DebugCodableStruct = try utility.readValue(atFile: "codable.json")

		XCTAssertEqual(decodedValue, value)
	}

	func testWritingTwice() throws {
		let value = DebugCodableStruct(value: 6)
		try utility.writeValue(value, fileName: testFileURL.lastPathComponent)
		try utility.writeValue(value, fileName: testFileURL.lastPathComponent)

		XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path))
	}

	func testReadingNonExistentFile() throws {
		XCTAssertThrowsError(try utility.readValue(atFile: "codable.json") as DebugCodableStruct)
	}

	func testUpdatingOptions() {
		let options = FileUtility.Options.default
		let updatedOptions = options.updated(removeFileIfWritingNilValue: false)

		XCTAssertEqual(updatedOptions.removeFileIfWritingNilValue, false)
	}

}
