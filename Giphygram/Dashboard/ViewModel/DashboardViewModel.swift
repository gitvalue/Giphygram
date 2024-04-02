import Combine
import Foundation
import UIKit

/// Dashboard business logic
final class DashboardViewModel {
    
    // MARK: - Events publishers
    
    /// Alert show event publisher
    let alertEvent = PassthroughSubject<(title: String, mesage: String, action: String), Never>()
    /// Search bar editing end event publisher
    let endSearchBarEditingEvent = PassthroughSubject<Void, Never>()
    /// Search results list reload event publisher
    let reloadEvent = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    /// Search results list header text
    let searchResultsSectionHeader: String = "Search results"
    /// Search bar placeholder text
    let searchBarPlacehloder: String = "Search"
    
    /// Search bar 'cancel' button visibility indicator
    @Published private(set) var isSearchBarCancelButtonVisible: Bool = false
    /// Search results list visibility indicator
    @Published private(set) var areSearchResultsHidden: Bool = true
    /// Search results
    @Published private(set) var searchResults: [SearchResultCellModel] = []
    /// Random GIF details view visibility indicator
    @Published private(set) var areDetailsHidden: Bool = false {
        didSet {
            if areDetailsHidden {
                detailsViewModel.stop()
            } else {
                detailsViewModel.start()
            }
        }
    }
    
    private var searchQuery: String? = nil
    private let searchOperationQueue: OperationQueue = .serial
        
    private let router: DashboardRouterProtocol
    private let service: GifSearchServiceProtocol
    private let imageLoader: ImageLoading
    private let detailsViewModel: DashboardGifDetailsViewModelProtocol
    private var subscriptions: [AnyCancellable] = []
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameters:
    ///   - router: Dashboard router
    ///   - service: GIF service
    ///   - imageLoaderConstructor: Image data loader constructor
    ///   - detailsViewModel: Random GIF details view model
    init(
        router: DashboardRouterProtocol,
        service: GifSearchServiceProtocol,
        imageLoaderConstructor: (_ countLimit: Int) -> (ImageLoading),
        detailsViewModel: DashboardGifDetailsViewModelProtocol
    ) {
        self.router = router
        self.service = service
        self.imageLoader = imageLoaderConstructor(150)
        self.detailsViewModel = detailsViewModel
    }
    
    // MARK: - Public
    
    /// Subscribes view model to 'search bar did begin editing' event
    /// - Parameter subject: 'Search bar did begin editing' event publisher
    func subscribeToSearchBarDidBeginEditingEvent(_ subject: AnyPublisher<Void, Never>) {
        subject.sink { [weak self] in
            self?.isSearchBarCancelButtonVisible = true
            self?.areSearchResultsHidden = false
            self?.areDetailsHidden = true
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to 'search bar text did change' event
    /// - Parameter subject: 'Search bar text did change' event publisher
    func subscribeToSearchBarTextDidChangeEvent(_ subject: AnyPublisher<String, Never>) {
        subject.filter { [searchQuery] text in
            searchQuery != text
        }.map { [weak self] text in
            self?.searchQuery = text
            return text
        }.debounce(
            for: .milliseconds(600),
            scheduler: RunLoop.main
        ).sink { [weak self] text in
            guard let self else { return }
            
            self.searchOperationQueue.cancelAllOperations()
            self.searchResults.removeAll()
            
            if 1 < text.count {
                self.loadNextPage()
            }
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to 'search bar cancel button clicked' event
    /// - Parameter subject: 'Search bar cancel button clicked' event publisher
    func subscribeToSearchBarCancelButtonClickedEvent(_ subject: AnyPublisher<Void, Never>) {
        subject.sink { [weak self] in
            self?.isSearchBarCancelButtonVisible = false
            self?.areDetailsHidden = false
            self?.areSearchResultsHidden = true
            self?.endSearchBarEditingEvent.send()
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to 'search bar 'search' button clicked' event
    /// - Parameter subject: 'Search bar 'search' button clicked' event publisher
    func subscribeToSearchBarSearchButtonClickedEvent(_ subject: AnyPublisher<Void, Never>) {
        subject.sink { [weak self] in
            self?.isSearchBarCancelButtonVisible = false
            self?.endSearchBarEditingEvent.send()
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to results list cell press event
    /// - Parameter subject: Results list cell press event publisher
    func subscribeToCellPressedEvent(_ subject: AnyPublisher<SearchResultCellModel, Never>) {
        subject.compactMap { [imageLoader] item in
            guard
                let objectUrl = URL(string: item.gifObject.url),
                let dataUrl = URL(string: item.gifObject.details.metadata.url),
                let data = imageLoader.imageData(forUrl: dataUrl)
            else {
                return nil
            }
            
            let details = GifDetails(
                data: data,
                title: item.gifObject.title,
                url: objectUrl,
                rating: item.gifObject.rating
            )
            
            return details
        }.sink { [router] details in
            router.openDetails(details)
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to 'results list did scroll to bottom' event
    /// - Parameter subject: 'Results list did scroll to bottom' event publisher
    func subscribeToScrolledToBottomEvent(_ subject: AnyPublisher<Void, Never>) {
        subject.throttle(
            for: .seconds(2),
            scheduler: RunLoop.main,
            latest: true
        ).sink { [weak self] in
            self?.loadNextPage()
        }.store(
            in: &subscriptions
        )
    }
    
    func subscribeToSearchBarTextDidEndEditingEvent(_ subject: AnyPublisher<Void, Never>) {
        subject.sink { [weak self] in
            guard let self, self.searchQuery?.isEmpty != false else {
                return
            }
            
            self.areDetailsHidden = false
            self.areSearchResultsHidden = true
        }.store(
            in: &subscriptions
        )
    }
    
    // MARK: - Private
    
    private func loadNextPage() {
        guard let searchQuery else { return }
        
        searchOperationQueue.cancelAllOperations()
        
        let operation = AsynchronousOperation()
        operation.task = { [weak operation, weak self] in
            guard 
                let self,
                let operation,
                operation.isRunning
            else {
                operation?.finish()
                return
            }

            self.service.getGifsForSearchQuery(searchQuery, offset: UInt32(self.searchResults.count), limit: 21).sink(
                receiveCompletion: { [weak operation, weak self] result in
                    operation?.finish()
                    
                    if case .failure = result {
                        self?.alertEvent.send(("Error", "Request failed. Please try again later", "Ok"))
                    }
                },
                receiveValue: { [weak self, weak operation] objects in
                    guard let self, let operation, operation.isRunning else { return }
                    
                    self.searchResults.append(contentsOf: objects.map { self.cellModel(fromObject: $0) })
                    operation.finish()
                }
            ).store(
                in: &self.subscriptions
            )
        }
        
        searchOperationQueue.addOperation(operation)
    }
    
    private func cellModel(fromObject gifObject: GifObjectDto) -> SearchResultCellModel {
        return SearchResultCellModel(gifObject: gifObject) { [weak self] in
            guard
                let self,
                let url = URL(string: gifObject.details.metadata.url)
            else {
                return nil
            }
            
            if let image = self.imageLoader.image(forUrl: url) {
                return image
            } else {
                self.fetchImage(url)
                return nil
            }
        }
    }
    
    private func fetchImage(_ url: URL) {
        imageLoader.fetchImage(url) { [weak self] result in
            guard let self else { return }
            
            if case .success = result {
                self.reloadEvent.send()
            } else {
                self.fetchImage(url)
            }
        }
    }
}

// MARK: - Model

extension DashboardViewModel {
    /// Search result cell model
    struct SearchResultCellModel: Hashable {
        
        // MARK: - Properties
        
        /// Preview image to display
        var image: UIImage? { lazyImage() }
        /// If `true`, activity indicator should be shown, hidden otherwise
        var isActivityIndicatorActive: Bool { image == nil }
        
        fileprivate let gifObject: GifObjectDto
        private let lazyImage: () -> (UIImage?)
        
        // MARK: - Initialisers
        
        fileprivate init(gifObject: GifObjectDto, lazyImage: @escaping () -> (UIImage?)) {
            self.gifObject = gifObject
            self.lazyImage = lazyImage
        }
        
        // MARK: - Public
                
        static func == (lhs: DashboardViewModel.SearchResultCellModel, rhs: DashboardViewModel.SearchResultCellModel) -> Bool {
            return lhs.gifObject == rhs.gifObject
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(gifObject)
        }
        
        #if TESTING
        static func testModel(withGifObject gifObject: GifObjectDto, lazyImage: @escaping () -> (UIImage?)) -> SearchResultCellModel {
            return SearchResultCellModel(gifObject: gifObject, lazyImage: lazyImage)
        }
        #endif
    }
}
