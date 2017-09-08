protocol PaginationRequestType {
    associatedtype Response: PaginationResponseType
    var limit: Int { get }
    var offset: Int { get }
}

protocol PaginationResponseType {
    associatedtype Element
    var elements: [Element] { get }
}
