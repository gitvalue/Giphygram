import Foundation

/// [Giphy](https://developers.giphy.com/docs/api/endpoint#random) random GIF request model
struct RandomGifRequest: Request {
    
    // MARK: - Model
    
    struct Response: Decodable {
        let data: GifObjectDto
        let meta: GifResponseMetadataDto
    }
    
    struct Body: Encodable {
        let apiKey: String
    }
    
    // MARK: - Properties
    
    let relativePath: String = "random"
    let method: HttpMethod = .get
    let body: Body
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameter apiKey: Giphy API key
    init(apiKey: String) {
        body = Body(apiKey: apiKey)
    }
}

// MARK: - CodingKeys

extension RandomGifRequest.Body {
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
