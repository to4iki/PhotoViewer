public enum APIError: Error {
    case connectionError(Error)
    case responseParseError(Error)
    case requestError(String)
    case other(String)
}
