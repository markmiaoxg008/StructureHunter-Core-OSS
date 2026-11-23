/// A non-cryptographic fingerprint of the UTF-8 bytes of a string.
/// Returns lowercase hexadecimal without leading zero padding.
/// Do not use this for authentication or tamper detection.
public enum FNV1a64 {
    public static func hex(_ text: String) -> String {
        var hash: UInt64 = 14695981039346656037
        for byte in text.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1099511628211
        }
        return String(hash, radix: 16)
    }
}
