import Combine
import Foundation

/// Interface of the service which returns random GIF
protocol RandomGifServiceProtocol: AnyObject {
    /// Requests random GIF
    /// - Returns: GIF object publisher
    func getRandomGif() -> AnyPublisher<GifObjectDto, Error>
}
