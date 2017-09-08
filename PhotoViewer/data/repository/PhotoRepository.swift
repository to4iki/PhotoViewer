import API
import Result

struct SearchPhotoRequest: PaginationRequestType {
    typealias Response = SearchPhotoResponse
    let keyword: String
    let limit: Int
    let offset: Int
}

struct SearchPhotoResponse: PaginationResponseType  {
    let elements: [Photo]
    let nextRequest: SearchPhotoRequest?
}

struct PhotoRepository {
    func search(request: SearchPhotoRequest, completion: @escaping (Result<SearchPhotoResponse, APIError>) -> Void) {
        Photozou.searchPhoto(keyword: request.keyword, limit: request.limit, offset: request.offset) { result in
            switch result {
            case .success(let value):
                let count = value.count
                let nextOffset = request.offset + count
                let hasNext = (count == request.limit)
                if hasNext {
                    let nextRequest = SearchPhotoRequest(
                        keyword: request.keyword,
                        limit: request.limit,
                        offset: nextOffset
                    )
                    let response = SearchPhotoResponse(elements: value, nextRequest: nextRequest)
                    completion(Result(value: response))
                } else {
                    let response = SearchPhotoResponse(elements: value, nextRequest: nil)
                    completion(Result(value: response))
                }

            case .failure(let error):
                completion(Result(error: error))
            }
        }
    }
}
