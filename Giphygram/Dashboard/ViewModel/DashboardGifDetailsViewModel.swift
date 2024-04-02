import Combine
import Foundation

/// Dashboard GIF details view model interface
/// sourcery: AutoMockable
protocol DashboardGifDetailsViewModelProtocol: GifDetailsViewModelProtocol {
    /// Starts showing random GIF with a predefined interval
    func start()
    
    /// Stops showing random GIF with a predefined interval
    func stop()
}

/// Dashboard GIF details business logic
final class DashboardGifDetailsViewModel: DashboardGifDetailsViewModelProtocol {
    
    // MARK: - Properties
    
    let title: String = "Random GIF"
    
    var imageData: AnyPublisher<Data, Never> {
        $gifDetails.compactMap { $0?.data }.eraseToAnyPublisher()
    }
    
    var descriptionTitle: AnyPublisher<String, Never> {
        $gifDetails.compactMap { [weak self] details in
            guard let details else { return nil }
            return self?.descriptionTitle(fromDetails: details)
        }.eraseToAnyPublisher()
    }
    
    var descriptionSubtitle: AnyPublisher<NSAttributedString, Never> {
        $gifDetails.compactMap { [weak self] details in
            guard let details else { return nil }
            return self?.descriptionSubtitle(fromDetails: details)
        }.eraseToAnyPublisher()
    }
    
    var ratingModel: AnyPublisher<GifDetailsRatingModel, Never> {
        $gifDetails.compactMap { [weak self] details in
            guard let details else { return nil }
            return self?.ratingModel(fromDetails: details)
        }.eraseToAnyPublisher()
    }
    
    private lazy var errorGifDetails: GifDetails = {
        let gifURL = Bundle.main.url(forResource: "no_internet", withExtension: "gif")!
        let gifData = try! Data(contentsOf: gifURL)
            
        return GifDetails(
            data: gifData,
            title: "Error",
            url: URL(string: "https://github.com/gitvalue")!,
            rating: "404"
        )
    }()

    @Published var gifDetails: GifDetails?
    private var isRunning: Bool { !subscriptions.isEmpty }
    
    private var subscriptions: [AnyCancellable] = []
    private let service: RandomGifServiceProtocol
    private let router: GifDetailsRouterProtocol
    
    // MARK: - Initialisers
    
    init(service: RandomGifServiceProtocol, router: GifDetailsRouterProtocol) {
        self.service = service
        self.router = router
        
        start()
    }
    
    // MARK: - Public
    
    func start() {
        guard !isRunning else { return }
        
        Timer.publish(every: 10.0, on: .main, in: .default)
            .autoconnect()
            .prepend(.now)
            .flatMap { [service] _ in
                return service.getRandomGif()
            }.compactMap { [weak self] object in
                return self?.gifDetails(fromObject: object)
            }.catch { [errorGifDetails] _ in
                Just(errorGifDetails)
            }.sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] details in
                    self?.gifDetails = details
                }
            ).store(
                in: &subscriptions
            )
    }
    
    func stop() {
        subscriptions.removeAll()
    }
    
    /// Subscribes view model to URL click event
    /// - Parameter publisher: URL click event publisher
    func subscribeToUrlClickedEvent(_ publisher: AnyPublisher<URL, Never>) {
        publisher.receive(
            on: DispatchQueue.main
        ).sink { [router] url in
            router.openUrl(url)
        }.store(
            in: &subscriptions
        )
    }
    
    // MARK: - Private
    
    private func gifDetails(fromObject object: GifObjectDto) -> GifDetails? {
        guard 
            let objectUrl = URL(string: object.url),
            let dataUrl = URL(string: object.details.metadata.url),
            let data = try? Data(contentsOf: dataUrl)
        else {
            return nil
        }
        
        return GifDetails(
            data: data,
            title: object.title,
            url: objectUrl,
            rating: object.rating
        )
    }
}
