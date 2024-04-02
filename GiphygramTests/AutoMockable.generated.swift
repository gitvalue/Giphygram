// Generated using Sourcery 2.1.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine

@testable import Giphygram






















class DashboardGifDetailsViewModelProtocolMock: DashboardGifDetailsViewModelProtocol {


    var title: String {
        get { return underlyingTitle }
        set(value) { underlyingTitle = value }
    }
    var underlyingTitle: (String)!
    var imageData: AnyPublisher<Data, Never> {
        get { return underlyingImageData }
        set(value) { underlyingImageData = value }
    }
    var underlyingImageData: (AnyPublisher<Data, Never>)!
    var descriptionTitle: AnyPublisher<String, Never> {
        get { return underlyingDescriptionTitle }
        set(value) { underlyingDescriptionTitle = value }
    }
    var underlyingDescriptionTitle: (AnyPublisher<String, Never>)!
    var descriptionSubtitle: AnyPublisher<NSAttributedString, Never> {
        get { return underlyingDescriptionSubtitle }
        set(value) { underlyingDescriptionSubtitle = value }
    }
    var underlyingDescriptionSubtitle: (AnyPublisher<NSAttributedString, Never>)!
    var ratingModel: AnyPublisher<GifDetailsRatingModel, Never> {
        get { return underlyingRatingModel }
        set(value) { underlyingRatingModel = value }
    }
    var underlyingRatingModel: (AnyPublisher<GifDetailsRatingModel, Never>)!


    //MARK: - start

    var startVoidCallsCount = 0
    var startVoidCalled: Bool {
        return startVoidCallsCount > 0
    }
    var startVoidClosure: (() -> Void)?

    func start() {
        startVoidCallsCount += 1
        startVoidClosure?()
    }

    //MARK: - stop

    var stopVoidCallsCount = 0
    var stopVoidCalled: Bool {
        return stopVoidCallsCount > 0
    }
    var stopVoidClosure: (() -> Void)?

    func stop() {
        stopVoidCallsCount += 1
        stopVoidClosure?()
    }

    //MARK: - subscribeToUrlClickedEvent

    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCallsCount = 0
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCalled: Bool {
        return subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCallsCount > 0
    }
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedPublisher: (AnyPublisher<URL, Never>)?
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedInvocations: [(AnyPublisher<URL, Never>)] = []
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidClosure: ((AnyPublisher<URL, Never>) -> Void)?

    func subscribeToUrlClickedEvent(_ publisher: AnyPublisher<URL, Never>) {
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCallsCount += 1
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedPublisher = publisher
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedInvocations.append(publisher)
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidClosure?(publisher)
    }


}
class DashboardRouterProtocolMock: DashboardRouterProtocol {




    //MARK: - openDetails

    var openDetailsDetailsGifDetailsVoidCallsCount = 0
    var openDetailsDetailsGifDetailsVoidCalled: Bool {
        return openDetailsDetailsGifDetailsVoidCallsCount > 0
    }
    var openDetailsDetailsGifDetailsVoidReceivedDetails: (GifDetails)?
    var openDetailsDetailsGifDetailsVoidReceivedInvocations: [(GifDetails)] = []
    var openDetailsDetailsGifDetailsVoidClosure: ((GifDetails) -> Void)?

    func openDetails(_ details: GifDetails) {
        openDetailsDetailsGifDetailsVoidCallsCount += 1
        openDetailsDetailsGifDetailsVoidReceivedDetails = details
        openDetailsDetailsGifDetailsVoidReceivedInvocations.append(details)
        openDetailsDetailsGifDetailsVoidClosure?(details)
    }


}
class GifDetailsRouterProtocolMock: GifDetailsRouterProtocol {




    //MARK: - openUrl

    var openUrlUrlURLVoidCallsCount = 0
    var openUrlUrlURLVoidCalled: Bool {
        return openUrlUrlURLVoidCallsCount > 0
    }
    var openUrlUrlURLVoidReceivedUrl: (URL)?
    var openUrlUrlURLVoidReceivedInvocations: [(URL)] = []
    var openUrlUrlURLVoidClosure: ((URL) -> Void)?

    func openUrl(_ url: URL) {
        openUrlUrlURLVoidCallsCount += 1
        openUrlUrlURLVoidReceivedUrl = url
        openUrlUrlURLVoidReceivedInvocations.append(url)
        openUrlUrlURLVoidClosure?(url)
    }


}
class GifDetailsViewModelProtocolMock: GifDetailsViewModelProtocol {


    var title: String {
        get { return underlyingTitle }
        set(value) { underlyingTitle = value }
    }
    var underlyingTitle: (String)!
    var imageData: AnyPublisher<Data, Never> {
        get { return underlyingImageData }
        set(value) { underlyingImageData = value }
    }
    var underlyingImageData: (AnyPublisher<Data, Never>)!
    var descriptionTitle: AnyPublisher<String, Never> {
        get { return underlyingDescriptionTitle }
        set(value) { underlyingDescriptionTitle = value }
    }
    var underlyingDescriptionTitle: (AnyPublisher<String, Never>)!
    var descriptionSubtitle: AnyPublisher<NSAttributedString, Never> {
        get { return underlyingDescriptionSubtitle }
        set(value) { underlyingDescriptionSubtitle = value }
    }
    var underlyingDescriptionSubtitle: (AnyPublisher<NSAttributedString, Never>)!
    var ratingModel: AnyPublisher<GifDetailsRatingModel, Never> {
        get { return underlyingRatingModel }
        set(value) { underlyingRatingModel = value }
    }
    var underlyingRatingModel: (AnyPublisher<GifDetailsRatingModel, Never>)!


    //MARK: - subscribeToUrlClickedEvent

    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCallsCount = 0
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCalled: Bool {
        return subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCallsCount > 0
    }
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedPublisher: (AnyPublisher<URL, Never>)?
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedInvocations: [(AnyPublisher<URL, Never>)] = []
    var subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidClosure: ((AnyPublisher<URL, Never>) -> Void)?

    func subscribeToUrlClickedEvent(_ publisher: AnyPublisher<URL, Never>) {
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidCallsCount += 1
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedPublisher = publisher
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidReceivedInvocations.append(publisher)
        subscribeToUrlClickedEventPublisherAnyPublisherURLNeverVoidClosure?(publisher)
    }


}
class GifSearchServiceProtocolMock: GifSearchServiceProtocol {




    //MARK: - getGifsForSearchQuery

    var getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorCallsCount = 0
    var getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorCalled: Bool {
        return getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorCallsCount > 0
    }
    var getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorReceivedArguments: (query: String, offset: UInt32, limit: UInt32)?
    var getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorReceivedInvocations: [(query: String, offset: UInt32, limit: UInt32)] = []
    var getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorReturnValue: AnyPublisher<[GifObjectDto], Error>!
    var getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorClosure: ((String, UInt32, UInt32) -> AnyPublisher<[GifObjectDto], Error>)?

    func getGifsForSearchQuery(_ query: String, offset: UInt32, limit: UInt32) -> AnyPublisher<[GifObjectDto], Error> {
        getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorCallsCount += 1
        getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorReceivedArguments = (query: query, offset: offset, limit: limit)
        getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorReceivedInvocations.append((query: query, offset: offset, limit: limit))
        if let getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorClosure = getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorClosure {
            return getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorClosure(query, offset, limit)
        } else {
            return getGifsForSearchQueryQueryStringOffsetUInt32LimitUInt32AnyPublisherGifObjectDtoErrorReturnValue
        }
    }


}
class ImageLoadingMock: ImageLoading {




    //MARK: - fetchImage

    var fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidCallsCount = 0
    var fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidCalled: Bool {
        return fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidCallsCount > 0
    }
    var fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidReceivedArguments: (url: URL, completion: (Result<(UIImage, Data), Error>) -> ())?
    var fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidReceivedInvocations: [(url: URL, completion: (Result<(UIImage, Data), Error>) -> ())] = []
    var fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidClosure: ((URL, @escaping (Result<(UIImage, Data), Error>) -> ()) -> Void)?

    func fetchImage(_ url: URL, _ completion: @escaping (Result<(UIImage, Data), Error>) -> ()) {
        fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidCallsCount += 1
        fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidReceivedArguments = (url: url, completion: completion)
        fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidReceivedInvocations.append((url: url, completion: completion))
        fetchImageUrlURLCompletionEscapingResultUIImageDataErrorVoidClosure?(url, completion)
    }

    //MARK: - imageData

    var imageDataForUrlUrlURLDataCallsCount = 0
    var imageDataForUrlUrlURLDataCalled: Bool {
        return imageDataForUrlUrlURLDataCallsCount > 0
    }
    var imageDataForUrlUrlURLDataReceivedUrl: (URL)?
    var imageDataForUrlUrlURLDataReceivedInvocations: [(URL)] = []
    var imageDataForUrlUrlURLDataReturnValue: Data?
    var imageDataForUrlUrlURLDataClosure: ((URL) -> Data?)?

    func imageData(forUrl url: URL) -> Data? {
        imageDataForUrlUrlURLDataCallsCount += 1
        imageDataForUrlUrlURLDataReceivedUrl = url
        imageDataForUrlUrlURLDataReceivedInvocations.append(url)
        if let imageDataForUrlUrlURLDataClosure = imageDataForUrlUrlURLDataClosure {
            return imageDataForUrlUrlURLDataClosure(url)
        } else {
            return imageDataForUrlUrlURLDataReturnValue
        }
    }

    //MARK: - image

    var imageForUrlUrlURLUIImageCallsCount = 0
    var imageForUrlUrlURLUIImageCalled: Bool {
        return imageForUrlUrlURLUIImageCallsCount > 0
    }
    var imageForUrlUrlURLUIImageReceivedUrl: (URL)?
    var imageForUrlUrlURLUIImageReceivedInvocations: [(URL)] = []
    var imageForUrlUrlURLUIImageReturnValue: UIImage?
    var imageForUrlUrlURLUIImageClosure: ((URL) -> UIImage?)?

    func image(forUrl url: URL) -> UIImage? {
        imageForUrlUrlURLUIImageCallsCount += 1
        imageForUrlUrlURLUIImageReceivedUrl = url
        imageForUrlUrlURLUIImageReceivedInvocations.append(url)
        if let imageForUrlUrlURLUIImageClosure = imageForUrlUrlURLUIImageClosure {
            return imageForUrlUrlURLUIImageClosure(url)
        } else {
            return imageForUrlUrlURLUIImageReturnValue
        }
    }


}
