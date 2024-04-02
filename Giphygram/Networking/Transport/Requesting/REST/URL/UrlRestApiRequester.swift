import Combine
import Foundation

/// URL-encoded requests manager
final class UrlRestApiRequester: Requesting {
    
    // MARK: - Properties
    
    private let requester: RestApiRequester
    
    /// Designated initialiser
    /// - Parameter apiUrl: URL of the API
    init(apiUrl: String) {
        self.requester = RestApiRequester(
            apiUrl: apiUrl,
            encoder: URLEncoder(),
            decoder: JSONDecoder(),
            header: ["Content-Type": "application/x-www-form-urlencoded"]
        )
    }
    
    // MARK: - Public
    
    func make<T>(request: T) -> AnyPublisher<T.Response, Error> where T : Request {
        return requester.make(request: request)
    }
}
