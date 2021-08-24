import Foundation

public struct FileUtility {

	// MARK: - Nested Types

	public struct Options {
		public static let `default` = Options(encoder: .init(), decoder: .init(), removeFileIfWritingNilValue: true)

		let encoder: JSONEncoder
		let decoder: JSONDecoder
		let removeFileIfWritingNilValue: Bool

		public init(encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder(), removeFileIfWritingNilValue: Bool = true) {
			self.encoder = encoder
			self.decoder = decoder
			self.removeFileIfWritingNilValue = removeFileIfWritingNilValue
		}

		public func updated(encoder: JSONEncoder? = nil, decoder: JSONDecoder? = nil, removeFileIfWritingNilValue: Bool? = nil) -> Self {
			Options(
				encoder: encoder ?? self.encoder,
				decoder: decoder ?? self.decoder,
				removeFileIfWritingNilValue: removeFileIfWritingNilValue ?? self.removeFileIfWritingNilValue
			)
		}
	}

	// MARK: - Properties

	let directory: Directory
	let options: Options

	// MARK: - Init

	public init(directory: Directory, options: Options = .default) {
		self.directory = directory
		self.options = options
	}

}

public extension FileUtility {

	// MARK: - Write

	func writeValue<E: Encodable>(_ value: E?, fileName: String, encoder: JSONEncoder? = nil) throws {
		guard let value = value else {
			if options.removeFileIfWritingNilValue {
				try removeFile(named: fileName)
			}
			return
		}

		let baseURL = try directory.makeBaseURL()
		let url = baseURL.appendingPathComponent(fileName)

		try FileManager.default.writeValue(value, to: url, encoder: encoder ?? options.encoder)
	}

	// MARK: - Read

	func readValue<D: Decodable>(atFile fileName: String, decoder: JSONDecoder? = nil) throws -> D {
		let baseURL = try directory.makeBaseURL()
		let url = baseURL.appendingPathComponent(fileName)

		return try FileManager.default.readValue(at: url, decoder: decoder ?? options.decoder)
	}

	// MARK: - Delete

	func removeFile(named fileName: String) throws {
		let baseURL = try directory.makeBaseURL()
		let url = baseURL.appendingPathComponent(fileName, isDirectory: false)
		guard FileManager.default.fileExists(atPath: url.path) else {
			return
		}
		try FileManager.default.removeItem(at: url)
	}

}
