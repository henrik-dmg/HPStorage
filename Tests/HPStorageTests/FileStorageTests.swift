import XCTest
@testable import HPStorage

final class FileStorageTests: BaseTestCase {

	@FileStorage("codable.json")
	var value: DebugCodableStruct?

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

	func testReadingNilFile() {
		XCTAssertNil(value)
	}

	func testWritingToFile() {
		value = DebugCodableStruct(value: 10)
		XCTAssertEqual(value?.value, 10)
	}

	func testSettingNilValue() {
		value = DebugCodableStruct(value: 10)
		XCTAssertNotNil(value)
		value = nil
		XCTAssertNil(value)
	}

	func testImmutableValue() {
		let container = Container(value: .init("codable.json"))
		XCTAssertNil(container.value)
		container.value = DebugCodableStruct(value: 4)
		XCTAssertEqual(container.value?.value, 4)
	}

}

struct Container {

	@FileStorage("codable.json")
	var value: DebugCodableStruct?

}
