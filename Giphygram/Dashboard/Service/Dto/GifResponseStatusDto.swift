import Foundation

/// Giphy endpoind response status code model
enum GifResponseStatusDto: Decodable {
    /// Request was successful
    case success
    /// Request was formatted incorrectly or missing a required parameter(s).
    case badRequest
    /// Request lacks valid authentication credentials for the target resource, which
    /// most likely indicates an issue with an API Key or the API Key is missing.
    case unauthorised
    /// User weren't authorized to make this request; most likely this indicates an issue with the API Key.
    case forbidden
    /// The particular GIF or Sticker you are requesting was not found.
    case notFound
    /// The length of the search query exceeds 50 characters.
    case uriTooLong
    /// Specified API Key is making too many requests.
    case tooManyRequests
    /// Unknown status code
    case unknown
    
    // MARK: - Initialisers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(Int.self)
        
        switch code {
        case 200:
            self = .success
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorised
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 414:
            self = .uriTooLong
        case 429:
            self = .tooManyRequests
        default:
            self = .unknown
        }
    }
}
