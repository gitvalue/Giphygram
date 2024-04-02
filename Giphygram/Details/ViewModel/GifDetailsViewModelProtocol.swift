import Combine
import Foundation

/// GIF details view model interface
/// sourcery: AutoMockable
protocol GifDetailsViewModelProtocol: AnyObject {
    /// Title text
    var title: String { get }
    /// GIF binary data
    var imageData: AnyPublisher<Data, Never> { get }
    /// GIF title text
    var descriptionTitle: AnyPublisher<String, Never> { get }
    /// GIF description text
    var descriptionSubtitle: AnyPublisher<NSAttributedString, Never> { get }
    /// Content rating model
    var ratingModel: AnyPublisher<GifDetailsRatingModel, Never> { get }
    
    /// Subscribes view model to URL click event
    /// - Parameter publisher: URL click event publisher
    func subscribeToUrlClickedEvent(_ publisher: AnyPublisher<URL, Never>)
}

// MARK: - Default

extension GifDetailsViewModelProtocol {
    /// Gets GIF title from details model
    /// - Parameter details: GIF details model
    /// - Returns: Title text
    func descriptionTitle(fromDetails details: GifDetails) -> String {
        let titleWithoutWhitespaceCharacters = details.title.filter { !$0.isWhitespace }
        let title: String = titleWithoutWhitespaceCharacters.isEmpty ? "Noname GIF" : titleWithoutWhitespaceCharacters
        return title
    }
    
    /// Gets GIF description from details model
    /// - Parameter details: GIF details model
    /// - Returns: Description attributed text
    func descriptionSubtitle(fromDetails details: GifDetails) -> NSAttributedString {
        return NSAttributedString(
            string: details.url.absoluteString,
            attributes: [
                .link: details.url
            ]
        )
    }
    
    /// Gets content rating model from GIF details
    /// - Parameter details: GIF details model
    /// - Returns: Content rating model
    func ratingModel(fromDetails details: GifDetails) -> GifDetailsRatingModel {
        switch details.rating {
        case "g": GifDetailsRatingModel(title: "0+", style: .harmless)
        case "pg": GifDetailsRatingModel(title: "8+", style: .neutral)
        case "pg-13": GifDetailsRatingModel(title: "13+", style: .warning)
        case "r": GifDetailsRatingModel(title: "17+", style: .accent)
        default: GifDetailsRatingModel(title: details.rating, style: .accent)
        }
    }
}
