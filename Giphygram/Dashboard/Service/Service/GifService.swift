import Combine
import Foundation

/// GIF requesting service
final class GifService: RandomGifServiceProtocol, GifSearchServiceProtocol {
    
    // MARK: - Properties
    
    private let apiKey = "c2zhJAWwvZMMBJ0qP3RzlobjO1zKjagh"
    private let requester: Requesting
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameter requesterConstructor: Network requesting object constructor
    init(requesterConstructor: (_ apiUrl: String) -> (Requesting)) {
        self.requester = requesterConstructor("https://api.giphy.com/v1/gifs")
    }
    
    // MARK: - Public
    
    func getRandomGif() -> AnyPublisher<GifObjectDto, Error> {
        let request = RandomGifRequest(apiKey: apiKey)
        
        let result = requester.make(request: request).tryMap { response in
            if case .success = response.meta.status {
                return response.data
            } else {
                throw GifServiceError(code: response.meta.status)
            }
        }
        
        return result.eraseToAnyPublisher()
    }
    
    func getGifsForSearchQuery(_ query: String, offset: UInt32, limit: UInt32) -> AnyPublisher<[GifObjectDto], Error> {
        let request = GifSearchRequest(apiKey: apiKey, query: query, offset: offset, limit: limit)
        
        let result = requester.make(request: request).tryMap { response in
            if case .success = response.meta.status {
                return response.data
            } else {
                throw GifServiceError(code: response.meta.status)
            }
        }
        
        return result.eraseToAnyPublisher()
    }
}
