import Foundation

/// [Giphy](https://developers.giphy.com/docs/api/endpoint#search) search request model
struct GifSearchRequest: Request {
    
    // MARK: - Model
    
    struct Response: Decodable {
        let data: [GifObjectDto]
        let meta: GifResponseMetadataDto
    }
    
    struct Body: Encodable {
        let apiKey: String
        let query: String
        let offset: UInt32
        let limit: UInt32
        let bundle: String = "clips_grid_picker"
    }
    
    // MARK: - Properties
    
    let relativePath: String = "search"
    let method: HttpMethod = .get
    let body: Body
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameters:
    ///   - apiKey: Giphy  API key
    ///   - query: Search query
    ///   - offset: Paging offset
    ///   - limit: Page size
    init(apiKey: String, query: String, offset: UInt32, limit: UInt32) {
        body = Body(apiKey: apiKey, query: query, offset: offset, limit: limit)
    }
}

// MARK: - CodingKeys

extension GifSearchRequest.Body {
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case query = "q"
        case offset = "offset"
        case limit = "limit"
        case bundle = "bundle"
    }
}
