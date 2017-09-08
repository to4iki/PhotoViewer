import Foundation

protocol Request {
    associatedtype Response
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    func response(from data: Data, urlResponse: URLResponse) throws -> Response
}

extension Request {
    var baseURL: URL {
        return URL(string: "https://api.photozou.jp/rest")!
    }
}

extension Request {
    func buildURLRequest() -> URLRequest {
        func buildURLComponents(url: URL) -> URLComponents? {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if case .get = method {
                let queryItems = parameters?.map { (key: String, value: Any) in
                    URLQueryItem(name: key, value: String(describing: value))
                }
                components?.queryItems = queryItems
            } else {
                // TODO: support other http method
                fatalError("Unsupported method \(method)")
            }
            return components
        }
        
        let url = baseURL.appendingPathComponent(path)
        let urlComponents = buildURLComponents(url: url)
        var urlRequest = URLRequest(url: url)
        urlRequest.url = urlComponents?.url
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
