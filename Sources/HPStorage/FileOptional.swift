import Foundation

@propertyWrapper public struct FileOptional<C: Codable> {

	private let fileName: String
	private let utility: FileUtility

	public init(
		fileName: String,
		directory: FileUtility.Directory = .caches(),
		encoder: JSONEncoder = .init(),
		decoder: JSONDecoder = .init()
	) {
		self.fileName = fileName
		self.utility = FileUtility(directory: directory, encoder: encoder, decoder: decoder)
	}

	public var wrappedValue: C? {
		get {
			do {
				return try utility.read(fileName: fileName)
			} catch {
				return nil
			}
		}
		nonmutating set {
			do {
				try utility.write(newValue, fileName: fileName)
			} catch let error {
				#if DEBUG
				fatalError(error.localizedDescription)
				#endif
			}
		}
	}

}
