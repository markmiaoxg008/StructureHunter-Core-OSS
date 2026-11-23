import Foundation
import XCTest
@testable import SnapshotFileKit

final class SnapshotFileKitTests: XCTestCase {
    private func withFolder(_ body: (URL) throws -> Void) throws {
        let base = ProcessInfo.processInfo.environment["SNAPSHOT_FILE_KIT_TEST_ROOT"]
            .map { URL(fileURLWithPath: $0, isDirectory: true) }
            ?? FileManager.default.temporaryDirectory
        let folder = base.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: folder) }
        try body(folder)
    }

    // Known FNV-1a/64 byte-string vectors, without a trailing NUL.
    func testKnownFNVVectors() {
        XCTAssertEqual(FNV1a64.hex(""), "cbf29ce484222325")
        XCTAssertEqual(FNV1a64.hex("a"), "af63dc4c8601ec8c")
        XCTAssertEqual(FNV1a64.hex("foobar"), "85944171f73967e8")
    }

    func testObjectAndOriginalBytes() throws {
        try withFolder { folder in
            let url = folder.appendingPathComponent("fixture.json")
            let data = Data(#"{"label":"sample","count":2}"#.utf8)
            try data.write(to: url)
            let result = try JSONFile.loadObject(from: url)
            XCTAssertEqual(result.data, data)
            XCTAssertEqual(result.object["label"] as? String, "sample")
            XCTAssertEqual(result.object["count"] as? Int, 2)
        }
    }

    func testArrayIsRejected() throws {
        try withFolder { folder in
            let url = folder.appendingPathComponent("array.json")
            try Data("[]".utf8).write(to: url)
            XCTAssertThrowsError(try JSONFile.loadObject(from: url)) {
                XCTAssertEqual($0 as? JSONFileError, .expectedObject)
            }
        }
    }

    func testMalformedJSONIsRejected() throws {
        try withFolder { folder in
            let url = folder.appendingPathComponent("invalid.json")
            try Data("{".utf8).write(to: url)
            XCTAssertThrowsError(try JSONFile.loadObject(from: url))
        }
    }

    func testMissingFileIsRejected() throws {
        try withFolder { folder in
            XCTAssertThrowsError(try JSONFile.loadObject(from: folder.appendingPathComponent("missing.json")))
        }
    }

    func testNonFileURLIsRejected() throws {
        let url = try XCTUnwrap(URL(string: "https://example.invalid/fixture.json"))
        XCTAssertThrowsError(try JSONFile.loadObject(from: url)) {
            XCTAssertEqual($0 as? JSONFileError, .notFileURL)
        }
    }
}
