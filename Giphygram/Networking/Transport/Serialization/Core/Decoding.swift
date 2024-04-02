import Foundation

/// Data decoder interface
protocol Decoding: AnyObject {
    /// Decodes object
    /// - Parameters:
    ///   - type: Type of the decoding object
    ///   - data: Binary data
    /// - Returns: Decoded object
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}
