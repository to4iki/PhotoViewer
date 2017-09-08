import Foundation

struct API {
    struct SearchPhoto: Request {
        typealias Response = [Photo]

        var path: String {
            return "/search_public.json"
        }

        var method: HTTPMethod {
            return .get
        }

        var parameters: [String: Any]? {
            var dic: [String: Any] = ["keyword": keyword]
            if let limit = limit {
                dic["limit"] = limit
            }
            if let offset = offset {
                dic["offset"] = offset
            }
            return dic
        }

        let keyword: String
        let limit: Int?
        let offset: Int?

        func response(from data: Data, urlResponse: URLResponse) throws -> [Photo] {
            if case (200..<300)? = (urlResponse as? HTTPURLResponse)?.statusCode {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dic = json as? [String: Any] else {
                    throw APIError.other("failure convert any to dictionary")
                }
                guard let rawInfo = dic["info"] else {
                    throw DecodeError.missingKey("info")
                }
                guard let info = rawInfo as? [String: Any] else {
                    throw DecodeError.typeMismatch(expected: "[String: Any]", key: "info")
                }
                guard let photoNum = info["photo_num"] as? Int else {
                    throw DecodeError.missingKey("photo_num")
                }
                guard photoNum > 0 else {
                    return []
                }
                guard let rawPhotos = info["photo"] else {
                    throw DecodeError.missingKey("photo")
                }
                guard let photos = rawPhotos as? [[String: Any]] else {
                    throw DecodeError.typeMismatch(expected: "[[String: Any]]", key: "photo")
                }
                return try photos.map(Response.Element.decode)
            } else {
                // TODO: parase error response
                throw APIError.requestError("failure request")
            }
        }
    }
}
