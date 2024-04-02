import Combine
import Foundation

/// Ad-hoc REST API communicator
final class RestApiRequester: Requesting {
    
    // MARK: - Properties
    
    private let apiUrl: String
    private let encoder: Encoding
    private let decoder: Decoding
    private let header: [String: String]
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    // MARK: - Initialisers
    
    init(apiUrl: String, encoder: Encoding, decoder: Decoding, header: [String: String]) {
        self.apiUrl = apiUrl
        self.encoder = encoder
        self.decoder = decoder
        self.header = header
    }
    
    // MARK: - Public
    
    func make<T>(request: T) -> AnyPublisher<T.Response, Error> where T : Request {
        let urlRequest: URLRequest?
        
        switch request.method {
        case .get:
            urlRequest = urlRequestForGetRequest(request)
        case .post:
            urlRequest = urlRequestForPostRequest(request)
        }
        
        guard var urlRequest else {
            return Fail(error: URLError.badURL).eraseToAnyPublisher()
        }
        
        header.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let publisher = session.dataTaskPublisher(
            for: urlRequest
        ).tryMap { [decoder] data, _ in
            return try decoder.decode(T.Response.self, from: data)
        }.mapError { error in
            return error as Error
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private func urlRequestForPostRequest<T>(_ request: T) -> URLRequest? where T : Request {
        guard
            let query = (apiUrl + "/" + request.relativePath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: query)
        else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            urlRequest.httpBody = try encoder.encode(request.body)
            return urlRequest
        } catch {
            return nil
        }
    }
    
    private func urlRequestForGetRequest<T>(_ request: T) -> URLRequest? where T : Request {
        guard
            let body = try? encoder.encode(request.body),
            let queryParams = String(data: body, encoding: .utf8),
            let query = (apiUrl + "/" + request.relativePath + "?" + queryParams).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: query)
        else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
            
        return urlRequest
    }
}
