import XCTest
@testable import HPStorage

final class HPStorageTests: XCTestCase {

	private let baseURl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".HPStorage")
	private var testFileURL: URL {
		baseURl.appendingPathComponent("Tests/codable.json")
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()

		if FileManager.default.fileExists(atPath: baseURl.path) {
			try FileManager.default.removeItem(at: baseURl)
		}
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

}

struct DebugCodableStruct: Codable, Equatable {

	let value: Int

}
