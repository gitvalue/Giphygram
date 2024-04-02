import Combine
import XCTest

@testable import Giphygram

final class GifDetailsViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var urlClickEventPublisher: PassthroughSubject<URL, Never>!
    private var subscriptions: [AnyCancellable] = []
    
    private var router: GifDetailsRouterProtocolMock!
    private var subject: GifDetailsViewModel!
    
    // MARK: - Public
    
    override func setUpWithError() throws {
        router = GifDetailsRouterProtocolMock()
        subject = GifDetailsViewModel(details: TestData.details, router: router)
        urlClickEventPublisher = PassthroughSubject<URL, Never>()
        subscriptions = []
    }
    
    override func tearDownWithError() throws {
        router = nil
        subject = nil
        urlClickEventPublisher = nil
        subscriptions = []
    }
    
    // MARK: - Tests
    
    func testInitialState() throws {
        // given test details
        
        // when object is created
        
        // then published values should be correct
        
        var expectations: [XCTestExpectation] = []
        
        XCTAssert(subject.title == "Details")
        
        expectations.append(XCTestExpectation(description: "GIF data should be taken from details"))
        subject.imageData.sink { data in
            XCTAssert(data == TestData.details.data)
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "GIF title should be taken from details"))
        subject.descriptionTitle.sink { text in
            XCTAssert(text == TestData.details.title)
            expectations[1].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "GIF description should be details URL"))
        subject.descriptionSubtitle.sink { text in
            XCTAssert(text.string == TestData.details.url.absoluteString)
            expectations[2].fulfill()
        }.store(
            in: &subscriptions
        )
        
        expectations.append(XCTestExpectation(description: "Rating model should be correct"))
        subject.ratingModel.sink { model in
            XCTAssert(model.style == .warning)
            XCTAssert(model.title == "13+")
            expectations[3].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testLinkPress() throws {
        // given test details
        let url = TestData.details.url
        
        subject.subscribeToUrlClickedEvent(urlClickEventPublisher.eraseToAnyPublisher())
        
        // when user presses the link
        urlClickEventPublisher.send(url)
        
        // then
        let expectation = XCTestExpectation(description: "correct URL should be opened")
        
        router.openUrlUrlURLVoidClosure = { receivedUrl in
            XCTAssert(receivedUrl == url)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - TestData

private extension GifDetailsViewModelTests {
    enum TestData {
        static let details = GifDetails(
            data: Data(),
            title: "title",
            url: URL(string: "https://google.com")!,
            rating: "pg-13"
        )
    }
}
