import Combine
import XCTest

@testable import Giphygram

final class DashboardViewModelTests: XCTestCase {
    
    // MARK: - Events publishers
    
    private let collectionViewDidSelectCellEvent = PassthroughSubject<DashboardViewModel.SearchResultCellModel, Never>()
    private let scrollDidReachBottomEvent = PassthroughSubject<Void, Never>()
    private let searchBarTextDidBeginEditingEvent = PassthroughSubject<Void, Never>()
    private let searchBarTextDidChangeEvent = PassthroughSubject<String, Never>()
    private let searchBarCancelButtonClickedEvent = PassthroughSubject<Void, Never>()
    private let searchBarSearchButtonClickedEvent = PassthroughSubject<Void, Never>()
    private let searchBarTextDidEndEditingEvent = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private var router: DashboardRouterProtocolMock!
    private var service: GifSearchServiceProtocolMock!
    private var imageLoader: ImageLoadingMock!
    private var detailsViewModel: DashboardGifDetailsViewModelProtocolMock!
    private var subject: DashboardViewModel!
    private var subscriptions: [AnyCancellable] = []
    
    // MARK: - Public
    
    override func setUpWithError() throws {
        router = DashboardRouterProtocolMock()
        service = GifSearchServiceProtocolMock()
        imageLoader = ImageLoadingMock()
        detailsViewModel = DashboardGifDetailsViewModelProtocolMock()
        
        subject = DashboardViewModel(
            router: router,
            service: service,
            imageLoaderConstructor: { _ in imageLoader },
            detailsViewModel: detailsViewModel
        )
        subject.subscribeToScrolledToBottomEvent(scrollDidReachBottomEvent.eraseToAnyPublisher())
        subject.subscribeToSearchBarDidBeginEditingEvent(searchBarTextDidBeginEditingEvent.eraseToAnyPublisher())
        subject.subscribeToSearchBarTextDidChangeEvent(searchBarTextDidChangeEvent.eraseToAnyPublisher())
        subject.subscribeToSearchBarCancelButtonClickedEvent(searchBarCancelButtonClickedEvent.eraseToAnyPublisher())
        subject.subscribeToSearchBarSearchButtonClickedEvent(searchBarSearchButtonClickedEvent.eraseToAnyPublisher())
        subject.subscribeToCellPressedEvent(collectionViewDidSelectCellEvent.eraseToAnyPublisher())
        subject.subscribeToSearchBarTextDidEndEditingEvent(searchBarTextDidEndEditingEvent.eraseToAnyPublisher())
        
        subscriptions = []
    }
    
    override func tearDownWithError() throws {
        router = nil
        service = nil
        imageLoader = nil
        detailsViewModel = nil
        subject = nil
        subscriptions = []
    }
    
    // MARK: - Tests
    
    func testInitialState() throws {
        // given test data
        
        // when object gets initialised
        
        // then
        let expectation = XCTestExpectation(description: "static values should be correct")
        XCTAssert(subject.searchResultsSectionHeader == "Search results")
        XCTAssert(subject.searchBarPlacehloder == "Search")
        expectation.fulfill()
        
        wait(for: [expectation])
    }
    
    func testSearchStart() throws {
        // given test data
        
        // when user taps on search bar
        searchBarTextDidBeginEditingEvent.send()
        
        // then
        var expectations: [XCTestExpectation] = []
        
        expectations.append(XCTestExpectation(description: "Search bar cancel button should become visible"))
        subject.$isSearchBarCancelButtonVisible.sink { isVisible in
            XCTAssertTrue(isVisible)
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Search results should be shown"))
        subject.$areSearchResultsHidden.sink { areHidden in
            XCTAssertFalse(areHidden)
            expectations[1].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Random GIF details should be hidden"))
        subject.$areDetailsHidden.sink { areHidden in
            XCTAssertTrue(areHidden)
            expectations[2].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Random GIF should stop updating"))
        XCTAssert(detailsViewModel.stopVoidCalled)
        expectations[3].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testSearchTextChange() throws {
        // given search query
        let searchQuery = "query"
        
        // when user puts query into search bar
        searchBarTextDidChangeEvent.send(searchQuery)
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "First page should start loading"))
        service.getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorClosure = { query, offset, pageSize in
            XCTAssert(query == searchQuery)
            XCTAssert(offset == 0)
            XCTAssert(pageSize == 21)
            expectations[0].fulfill()
            
            return PassthroughSubject<[GifObjectDto], Error>().eraseToAnyPublisher()
        }
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testSearchBarCancelButtonPress() throws {
        // given test data
        
        // when user presses search bar cancel button
        DispatchQueue.main.async {
            self.searchBarCancelButtonClickedEvent.send()
        }
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Search bar cancel button should hide"))
        subject.$isSearchBarCancelButtonVisible.sink { isVisible in
            XCTAssertFalse(isVisible)
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Random GIF details should become visible"))
        subject.$areDetailsHidden.sink { areHidden in
            XCTAssertFalse(areHidden)
            expectations[1].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Search results should become hidden"))
        subject.$areSearchResultsHidden.sink { areHidden in
            XCTAssertTrue(areHidden)
            expectations[2].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Search bar should lose focus"))
        subject.endSearchBarEditingEvent.sink {
            expectations[3].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testDoneButtonPress() throws {
        // given test data
        
        // when user presses 'Done' button
        DispatchQueue.main.async {
            self.searchBarSearchButtonClickedEvent.send()
        }
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Cancel button should hide"))
        subject.$isSearchBarCancelButtonVisible.sink { isVisible in
            XCTAssertFalse(isVisible)
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Search bar editing should end"))
        subject.endSearchBarEditingEvent.sink {
            expectations[1].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testCellPress() throws {
        // given test data
        let gifObject = TestData.gifObject
        let cellModel = TestData.cellModel
        
        let testData = Data()
        
        imageLoader.imageDataForUrlUrlURLDataClosure = { _ in
            return testData
        }
        
        // when user presses on the cell
        DispatchQueue.main.async {
            self.collectionViewDidSelectCellEvent.send(cellModel)
        }
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Details screen should be opened with corresponding model"))
        router.openDetailsDetailsGifDetailsVoidClosure = { details in
            XCTAssert(testData == details.data)
            XCTAssert(details.title == gifObject.title)
            XCTAssert(details.url.absoluteString == gifObject.url)
            XCTAssert(details.rating == gifObject.rating)
            expectations[0].fulfill()
        }
        
        wait(for: expectations, timeout: 5.0)
    }
}

// MARK: - TestData

private extension DashboardViewModelTests {
    enum TestData {
        static var cellModel: DashboardViewModel.SearchResultCellModel {
            return .testModel(
                withGifObject: gifObject,
                lazyImage: { UIImage() }
            )
        }
        
        static var gifObject: GifObjectDto {
            return GifObjectDto(
                id: "id",
                url: "https://picnic.nl",
                rating: "r",
                title: "title",
                details: GifDetailsDto(
                    metadata: GifDetailsDto.Metadata(url: "https://google.com")
                )
            )
        }
    }
}
