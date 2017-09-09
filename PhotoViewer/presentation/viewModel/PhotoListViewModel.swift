import API
import Bond

struct PhotoListViewModel: RequestListType {
    typealias Item = Photo
    let items: MutableObservableArray<Item> = MutableObservableArray([])
    let state: Observable<RequestState> = Observable(.none)
    let hasVisibleItems: Observable<Bool> = Observable(false)
    let noViewHidden: Observable<Bool> = Observable(true)
    let indicatorViewHidden: Observable<Bool> = Observable(true)
    let errorViewHidden: Observable<Bool> = Observable(true)

    private let repository: PhotoRepository

    init(repository: PhotoRepository = PhotoRepository()) {
        self.repository = repository
        bind()
    }

    func search(keyword: String, limit: Int = 30, offset: Int = 0) {
        let request = SearchPhotoRequest(keyword: keyword, limit: limit, offset: offset)
        state.value = .requesting
        repository.search(request: request) { result in
            switch result {
            case .success(let value):
                self.state.value = .none
                self.items.insert(contentsOf: value.elements, at: self.items.count)
//                self.nextRequest = response.nextRequest
            case .failure(let error):
                print("error: \(error)")
                self.state.value = .error
            }
        }
    }
}
