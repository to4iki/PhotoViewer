import Foundation

public struct Photo {
    public let id: Id<Photo>
    public let title: String
    public let imageURL: URL
}

extension Photo: CustomStringConvertible {
    public var description: String {
        return "Photo(id: \(id), title: \(title), imageURL: \(imageURL))"
    }
}

extension Photo: Equatable {
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo: Serializable {
    static func decode(from dic: [String : Any]) throws -> Photo {
        guard let rawId = dic["photo_id"] else { throw DecodeError.missingKey("photo_id") }
        guard let id = rawId as? Int else { throw DecodeError.typeMismatch(expected: "Int", key: "photo_id") }
        guard let rawTitle = dic["photo_title"] else { throw DecodeError.missingKey("photo_title") }
        guard let title = rawTitle as? String else { throw DecodeError.typeMismatch(expected: "String", key: "photo_title") }
        guard let rawImageURL = dic["image_url"] else { throw DecodeError.missingKey("image_url") }
        guard let imageURL = (rawImageURL as? String).flatMap(URL.init) else { throw DecodeError.typeMismatch(expected: "URL", key: "image_url") }
        return Photo(id: Id(value: id), title: title, imageURL: imageURL)
    }
    
    func encode() -> [String : Any] {
        return [
            "photo_id": id.value,
            "photo_title": title,
            "image_url": imageURL.absoluteString
        ]
    }
}
