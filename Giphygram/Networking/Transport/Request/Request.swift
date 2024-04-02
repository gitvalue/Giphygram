import Foundation

/// Network request model interface
protocol Request {
    associatedtype Response: Decodable
    associatedtype Body: Encodable
    
    /// Relative endpoint path
    var relativePath: String { get }
    /// HTTP method
    var method: HttpMethod { get }
    /// Request body data
    var body: Body { get }
}
