# SnapshotFileKit

A small Swift library with two reusable file-processing primitives:

- `FNV1a64.hex(_:)`: a deterministic, non-cryptographic UTF-8 fingerprint.
- `JSONFile.loadObject(from:)`: read an explicitly supplied local file URL,
  returning its original bytes and top-level JSON object.

This early-stage extraction contains general-purpose utilities only. It is
not the StructureHunter application, a trading system, or its decision core.
No strategies, account data, private snapshots, or application configuration
are included. No third-party package dependencies are required.

## Requirements

Swift 5.9 or later; macOS 13 or later. Other platforms are not validated here.

## Use

Add this directory as a local Swift package dependency, then depend on the
`SnapshotFileKit` product. No published version is assumed.

```swift
import Foundation
import SnapshotFileKit

let fingerprint = FNV1a64.hex("example")
let result = try JSONFile.loadObject(from: URL(fileURLWithPath: "example.json"))
print(fingerprint, result.object.count)
```

## Behavior and limits

The fingerprint is lowercase hexadecimal without leading zero padding. It
is not a cryptographic hash, signature, or tamper-detection mechanism. See
[RFC 9923](https://www.rfc-editor.org/rfc/rfc9923.html).

JSON reading is synchronous and loads the entire file into memory. Supply
small local files appropriate for your application. Non-file URLs and
non-object JSON roots are rejected. I/O and parse failures are reported as
errors. The library does not discover files, access a user-specific default
directory, or interpret application-specific fields.

## Tests

Run `swift test` in this directory. The six tests cover known fingerprint
vectors, byte-preserving object reading, and rejection of arrays, malformed
JSON, missing files, and non-file URLs. All fixtures are synthetic. Tests can
use a caller-selected temporary directory via `SNAPSHOT_FILE_KIT_TEST_ROOT`.
Test success is determined by the actual test run, not by this README.

## License

MIT; see LICENSE. Maintainer: markmiaoxg008.
