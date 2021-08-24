import XCTest
@testable import HPStorage

final class FileManagerExtensionTests: BaseTestCase {

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		try cleanUp()
	}

	func testWritingToFile() throws {
		let value = DebugCodableStruct(value: 6)
		try FileManager.default.writeValue(value, to: testFileURL, encoder: .init())

		XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path))
	}

	func testReadingFromFile() throws {
		let value = DebugCodableStruct(value: 6)
		try FileManager.default.writeValue(value, to: testFileURL, encoder: .init())
		let decodedValue: DebugCodableStruct = try FileManager.default.readValue(at: testFileURL, decoder: .init())

		XCTAssertEqual(decodedValue, value)
	}

	func testWritingTwice() throws {
		let value = DebugCodableStruct(value: 6)
		try FileManager.default.writeValue(value, to: testFileURL, encoder: .init())
		try FileManager.default.writeValue(value, to: testFileURL, encoder: .init())

		XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path))
	}

	func testReadingNonExistentFile() throws {
		XCTAssertThrowsError(try FileManager.default.readValue(at: testFileURL, decoder: .init()) as DebugCodableStruct)

	}

	func testRemoveAll() throws {
		let value = DebugCodableStruct(value: 6)
		try FileManager.default.writeValue(value, to: testFileURL, encoder: .init())
		XCTAssertNoThrow(try FileManager.default.removeAllItems(at: baseURL))
	}

}

struct DebugCodableStruct: Codable, Equatable {

	let value: Int

}
