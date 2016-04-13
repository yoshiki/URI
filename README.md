# URI

[C7](https://github.com/open-swift/C7/).URI extension library.

URI allows you to parse URI string.

This library based on [Zewo/URI](https://github.com/Zewo/URI).

## Requirement

* Install http-parser([See CURIParser's README](https://github.com/yoshiki/CURIParser/blob/master/README.md))

## Build

Specify linker path that http-parser installed.

```
% swift build -Xlinker -L/usr/local/lib
```

## Usage

```
import URI

do {
    let u = try URI("http://example.com/path?key=value")
    print(u.scheme)       // => Optional("http")
    print(u.host)         // => Optional("example.com")
    print(u.path)         // => Optional("/path")
    print(u.query["key"]) // => QueryField(values: [Optional("value")])
}
```

## Swift version

See .swift-version
