import Foundation

public struct FileUtility {

	public enum Directory {
		case caches(appGroup: String? = nil)
		case documents(appGroup: String? = nil)
	}

	let directory: Directory
	let encoder: JSONEncoder
	let decoder: JSONDecoder

	public static func caches(appGroup: String? = nil) -> Directory {
		Directory.caches(appGroup: appGroup)
	}

	public static func documents(appGroup: String? = nil) -> Directory {
		Directory.documents(appGroup: appGroup)
	}

}

public extension FileUtility {

	// MARK: - Write

	func write<E: Encodable>(_ value: E?, fileName: String, encoder: JSONEncoder? = nil) throws {
		guard let value = value else {
			try remove(fileName: fileName)
			return
		}

		let url = directory.baseURL.appendingPathComponent(fileName, isDirectory: false)

		let data = try (encoder ?? self.encoder).encode(value)
		if FileManager.default.fileExists(atPath: url.path) {
			try FileManager.default.removeItem(at: url)
		}
		FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
	}

	// MARK: - Read

	func read<D: Decodable>(fileName: String, decoder: JSONDecoder? = nil) throws -> D {
		let url = directory.baseURL.appendingPathComponent(fileName)

		guard let data = FileManager.default.contents(atPath: url.path) else {
			throw NSError(code: 7, description: "File does not exist")
		}

		return try (decoder ?? self.decoder).decode(D.self, from: data)
	}

	// MARK: - Delete

	func remove(fileName: String) throws {
		let url = directory.baseURL.appendingPathComponent(fileName, isDirectory: false)
		guard FileManager.default.fileExists(atPath: url.path) else {
			return
		}
		try FileManager.default.removeItem(at: url)
	}

	func removeAll(options: FileManager.DirectoryEnumerationOptions = []) throws {
		let contents = try FileManager.default.contentsOfDirectory(at: directory.baseURL, includingPropertiesForKeys: nil, options: options)
		try contents.forEach { url in
			try FileManager.default.removeItem(at: url)
		}
	}

}

private extension FileUtility.Directory {

	/// Returns URL constructed from specified directory
	var baseURL: URL {
		switch self {
		case .documents(let appGroup), .caches(let appGroup):
			if let appGroup = appGroup {
				return makeBaseURL(appGroup)
			} else {
				return makeBaseURL()
			}
		}
	}

	private func makeBaseURL(_ appGroup: String) -> URL {
		guard let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
			fatalError("Could not find container URL for specified app group")
		}
		switch self {
		case .documents:
			return baseURL.appendingPathComponent("Library").appendingPathComponent("Documents")
		case .caches:
			return baseURL.appendingPathComponent("Library").appendingPathComponent("Caches")
		}
	}

	private func makeBaseURL() -> URL {
		var searchPathDirectory: FileManager.SearchPathDirectory

		switch self {
		case .documents:
			searchPathDirectory = .documentDirectory
		case .caches:
			searchPathDirectory = .cachesDirectory
		}

		if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
			return url
		} else {
			fatalError("Could not create URL for specified directory!")
		}
	}

}
