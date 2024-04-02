import Combine
import Foundation

/// GIF details view model
final class GifDetailsViewModel: GifDetailsViewModelProtocol {
    
    // MARK: - Properties
    
    let title: String = "Details"
    var imageData: AnyPublisher<Data, Never> { Just(details.data).eraseToAnyPublisher() }
    var descriptionTitle: AnyPublisher<String, Never> { Just(descriptionTitle(fromDetails: details)).eraseToAnyPublisher() }
    var descriptionSubtitle: AnyPublisher<NSAttributedString, Never> { Just(descriptionSubtitle(fromDetails: details)).eraseToAnyPublisher() }
    var ratingModel: AnyPublisher<GifDetailsRatingModel, Never> { Just(ratingModel(fromDetails: details)).eraseToAnyPublisher() }
    
    private var subscriptions: [AnyCancellable] = []
    private let router: GifDetailsRouterProtocol
    private let details: GifDetails
    
    // MARK: - Initialisers
    
    init(details: GifDetails, router: GifDetailsRouterProtocol) {
        self.router = router
        self.details = details
    }
    
    // MARK: - Public
    
    func subscribeToUrlClickedEvent(_ publisher: AnyPublisher<URL, Never>) {
        publisher.receive(
            on: DispatchQueue.main
        ).sink { [router] url in
            router.openUrl(url)
        }.store(
            in: &subscriptions
        )
    }
}
