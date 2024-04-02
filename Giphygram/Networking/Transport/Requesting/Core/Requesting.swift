import Combine
import Foundation

/// Network requests manager interface
protocol Requesting: AnyObject {
    /// Makes a network request
    /// - Parameter request: Request model
    /// - Returns: Response future object
    func make<T>(request: T) -> AnyPublisher<T.Response, Error> where T: Request
}
