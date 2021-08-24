import Foundation

public enum Directory {
	case caches(appGroup: String? = nil)
	case documents(appGroup: String? = nil)
}

extension Directory {

	/// Returns URL constructed from specified directory
	func makeBaseURL() throws -> URL {
		switch self {
		case .documents(let appGroup), .caches(let appGroup):
			if let appGroup = appGroup {
				return try makeAppGroupBaseURL(appGroup)
			} else {
				return try makeRegularBaseURL()
			}
		}
	}

	private func makeAppGroupBaseURL(_ appGroup: String) throws -> URL {
		guard let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
			throw NSError.unknownContainer
		}
		switch self {
		case .documents:
			return baseURL.appendingPathComponent("Library").appendingPathComponent("Documents")
		case .caches:
			return baseURL.appendingPathComponent("Library").appendingPathComponent("Caches")
		}
	}

	private func makeRegularBaseURL() throws -> URL {
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
			throw NSError.unknownDirectory
		}
	}

}
