import Foundation

/// GIF details DTO
struct GifDetailsDto: Decodable, Hashable {
    
    // MARK: - Model
    
    struct Metadata: Decodable, Hashable {
        /// URL to the actual GIF file
        let url: String
    }
    
    // MARK: - Properties
    
    /// GIF metadata
    let metadata: Metadata
}

// MARK: - CodingKeys

extension GifDetailsDto {
    private enum CodingKeys: String, CodingKey {
        case metadata = "fixed_width"
    }
}
