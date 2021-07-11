import Foundation

@propertyWrapper public struct File<C: Codable> {
	
	private let fileName: String
	private let defaultValue: C
	private let utility: FileUtility

	public init(
		wrappedValue: C,
		fileName: String,
		directory: FileUtility.Directory = .caches(),
		encoder: JSONEncoder = .init(),
		decoder: JSONDecoder = .init()
	) {
		self.defaultValue = wrappedValue
		self.fileName = fileName
		self.utility = FileUtility(directory: directory, encoder: encoder, decoder: decoder)
	}
	
	public var wrappedValue: C {
		get {
			do {
				return try utility.read(fileName: fileName)
			} catch let error {
				#if DEBUG
				fatalError(error.localizedDescription)
				#else
				return defaultValue
				#endif
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
