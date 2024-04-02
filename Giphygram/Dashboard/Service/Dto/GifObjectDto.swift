import Foundation

/// GIF info DTO
struct GifObjectDto: Decodable, Hashable {
    /// Unique GIF object identifier
    let id: String
    /// URL to the GIF webpage
    let url: String
    /// Content rating ('g', 'pg', 'pg13' or 'r')
    let rating: String
    /// GIF title
    let title: String
    /// GIF details
    let details: GifDetailsDto
}

// MARK: - CodingKeys

extension GifObjectDto {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case rating = "rating"
        case title = "title"
        case details = "images"
    }
}

