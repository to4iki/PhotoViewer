enum DecodeError: Error {
    case missingKey(String)
    case typeMismatch(expected: String, key: String)
}

protocol Decodable {
    associatedtype T
    static func decode(from dic: [String: Any]) throws -> T
}

protocol Encodable {
    func encode() -> [String: Any]
}

protocol Serializable: Decodable, Encodable {}
