import Foundation

@propertyWrapper public struct FileStorage<C: Codable> {

	private let fileName: String
	private let utility: FileUtility
	private let assertOnErrors: Bool

	public init(
		_ fileName: String,
		directory: Directory = .caches(),
		encoder: JSONEncoder = .init(),
		decoder: JSONDecoder = .init(),
		assertOnErrors: Bool = false
	) {
		self.fileName = fileName
		self.utility = FileUtility(directory: directory, options: .init(encoder: encoder, decoder: decoder, removeFileIfWritingNilValue: true))
		self.assertOnErrors = assertOnErrors
	}

	public var wrappedValue: C? {
		get {
			do {
				return try utility.readValue(atFile: fileName)
			} catch let error {
				#if DEBUG
				if assertOnErrors {
					assertionFailure(error.localizedDescription)
				}
				#endif
				return nil
			}
		}
		nonmutating set {
			do {
				try utility.writeValue(newValue, fileName: fileName)
			} catch let error {
				#if DEBUG
				if assertOnErrors {
					assertionFailure(error.localizedDescription)
				}
				#endif
			}
		}
	}

}
