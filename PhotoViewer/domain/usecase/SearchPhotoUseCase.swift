import API
import Result

struct SearchPhotoUseCase {
    // TODO: pagination
    func execute(keyword: String, completion: @escaping (Result<[Photo], APIError>) -> Void) {
        Photozou.searchPhoto(keyword: keyword) { result in
            switch result {
            case .success(let response):
                completion(.success(response.map(Photo.init)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
