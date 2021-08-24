# HPStorage

HPStorage is a set of utilities to conveniently manage disk storage in your Swift applications. It includes a helper type and a property wrapper which both built on top of `FileManager` extensions which are also publicly available.

## Installation

To use HPStorage, simply add `.package(url: "https://github.com/henrik-dmg/HPStorage", from: "1.0.0")` to your Package.swift or the URL in Xcode when it prompts you for it

## Usage

### FileStorage property wrapper

Use it like other property wrappers, like `AppStorage` for example.

```swift
struct MyView: View {

    @FileStorage("yourFilename")
    private var storedValue: SomeCodableStruct

    var body: some View {
        Button("Do something") {
          storedValue = //... assign new value
        }
    }

}
```

Notice in the example above that you can mutate the wrapped value of `FileStorage` even when contained in value types

### FileUtility helper

`FileUtility` is the worker type used by `FileStorage`. You can use it directly though as following:

```swift
let utility = FileUtility(directory: .caches())

// Writing values
try utility.writeValue(someEncodableValue, fileName: "yourFilename")

// Reading values
let someDecodableValue: SomeCodableStruct = try utility.readValue(atFile: "yourFilename")

```

## Contributors

- [Henrik Panhans](https://twitter.com/henrik_dmg)
