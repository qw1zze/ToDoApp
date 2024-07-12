import Foundation

public protocol StringIdentifiable: Identifiable where ID == String {}

public protocol FileJsonCachable {
    init?(dict: [String: Any])
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

public typealias FileCachable = FileJsonCachable & StringIdentifiable
