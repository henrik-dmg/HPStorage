import Foundation

public extension FileManager {

	func readValue<D: Decodable>(at url: URL, decoder: JSONDecoder) throws -> D {
		guard let data = contents(atPath: url.path) else {
			throw NSError(code: 7, description: "File does not exist")
		}

		return try decoder.decode(D.self, from: data)
	}

	func writeValue<E: Encodable>(_ value: E, to url: URL, encoder: JSONEncoder) throws {
		let data = try encoder.encode(value)
		let containingFolderURL = url.deletingLastPathComponent()
		if !FileManager.default.fileExists(atPath: containingFolderURL.path) {
			try createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
		}
		createFile(atPath: url.path, contents: data, attributes: nil)
	}

	func removeAllItems(at url: URL, options: FileManager.DirectoryEnumerationOptions = []) throws {
		let contents = try contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options)
		try contents.forEach { try removeItem(at: $0) }
	}

}
