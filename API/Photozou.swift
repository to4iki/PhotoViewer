import Foundation
import Result

public final class Photozou {
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    private init() {}

    fileprivate static func send<T: Request>(_ request: T, completion: @escaping (Result<T.Response, APIError>) -> Void) {
        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(Result(error: .connectionError(error)))
            case let (data?, response?, _):
                do {
                    let value = try request.response(from: data, urlResponse: response)
                    completion(Result(value: value))
                } catch let error as APIError {
                    completion(Result(error: error))
                } catch {
                    completion(Result(error: .responseParseError(error)))
                }
            default:
                fatalError("invalid response combination")
            }
        }
        task.resume()
    }
}

extension Photozou {
    public static func searchPhoto(
        keyword: String,
        limit: Int? = nil,
        offset: Int? = nil,
        completion: @escaping (Result<[Photo], APIError>) -> Void)
    {
        let request = API.PhotoSearch(keyword: keyword, limit: limit, offset: offset)
        send(request, completion: completion)
    }
}
