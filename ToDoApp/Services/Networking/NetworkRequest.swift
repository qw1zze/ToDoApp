import Foundation

struct NetworkRequest {
    enum Methods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    var baseUrl: String
    var path: String
    var headers: [String: String]?
    var queryItems: [(key: String, value: String)]?
    var body: Data?
    var method: Methods
    
    init(baseUrl: String,
         path: String,
         headers: [String: String]? = nil,
         queryItems: [(key: String, value: String)]? = nil,
         body: Data? = nil,
         method: Methods = .get)
    {
        self.baseUrl = baseUrl
        self.path = path
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
        self.method = method
    }
}
