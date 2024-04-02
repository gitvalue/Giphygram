import Foundation

/// Giphy endpoind response metadata DTO
struct GifResponseMetadataDto: Decodable {
    /// Response status code
    let status: GifResponseStatusDto
}
