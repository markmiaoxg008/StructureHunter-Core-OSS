import Foundation

public enum JSONFileError: Error, Equatable {
    case notFileURL
    case expectedObject
}

public enum JSONFile {
    /// Reads an explicit local file; returns its original bytes and JSON object.
    /// Loads the whole file into memory. I/O and JSON parsing errors propagate.
    public static func loadObject(from url: URL) throws -> (data: Data, object: [String: Any]) {
        guard url.isFileURL else { throw JSONFileError.notFileURL }
        let data = try Data(contentsOf: url)
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw JSONFileError.expectedObject
        }
        return (data, object)
    }
}
