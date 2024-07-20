import Foundation

enum RequestProcessorError: Error {
    case wrongBaseUrl(String)
    case wrongUrl(URLComponents)
    case unexpectedResponse(URLResponse)
    case failedResponse(HTTPURLResponse)
}

final class DefaultNetworkingService {
    private static let httpStatusCodeSuccess = 200..<300
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private func makeUrl(request: NetworkRequest) throws -> URL {
        guard var components = URLComponents(string: request.baseUrl) else {
            throw RequestProcessorError.wrongBaseUrl(request.baseUrl)
        }
        components.path = request.path
        
        if let queryItems = request.queryItems {
            components.queryItems = queryItems.map { item in
                URLQueryItem(name: item.key, value: item.value)
            }
        }
        
        guard let url = components.url else {
            throw RequestProcessorError.wrongUrl(components)
        }
        return url
    }
    
    private func makeURlRequest(request: NetworkRequest) throws -> URLRequest {
        let url = try makeUrl(request: request)
        
        var newRequest = URLRequest(url: url)
        newRequest.httpMethod = request.method.rawValue
        if let body = request.body {
            newRequest.httpBody = body
        }

        if let headers = request.headers {
            for header in headers {
                newRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        return newRequest
    }
    
    func sendRequest<T: Decodable>(request: NetworkRequest) async throws -> T {
        let urlRequest = try makeURlRequest(request: request)
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestProcessorError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestProcessorError.failedResponse(response)
        }
        
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
