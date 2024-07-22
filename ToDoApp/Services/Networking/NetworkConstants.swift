import Foundation

enum NetworkConstants {
    static let baseUrl = "https://hive.mrdekk.ru"
    static let token = "Bearer Eldalote"
    
    enum Paths {
        static let todoList = "/todo/list"
    }
    
    enum Headers {
        static let authorization = "Authorization"
        static let lastRevision = "X-Last-Known-Revision"
    }
}
