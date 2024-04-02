import Combine
import Foundation

/// Interface of a service which requests GIFs for given search query
/// sourcery: AutoMockable
protocol GifSearchServiceProtocol: AnyObject {
    /// Requests GIFs for given search query
    /// - Parameters:
    ///   - query: Search query
    ///   - offset: Paging offset
    ///   - limit: Page size (maximum number of GIFs in response)
    /// - Returns: Found GIFs publisher
    func getGifsForSearchQuery(_ query: String, offset: UInt32, limit: UInt32) -> AnyPublisher<[GifObjectDto], Error>
}
