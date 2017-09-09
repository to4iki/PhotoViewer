import API
import Bond

final class PhotoListViewModel: RequestListType {
    typealias Item = Photo
    let items: MutableObservableArray<Item> = MutableObservableArray([])
    let state: Observable<RequestState> = Observable(.none)
    let hasVisibleItems: Observable<Bool> = Observable(false)
    let noDataViewHidden: Observable<Bool> = Observable(true)
    let indicatorViewHidden: Observable<Bool> = Observable(true)
    let errorViewHidden: Observable<Bool> = Observable(true)

    private let repository: PhotoRepository
    private var nextRequest: SearchPhotoRequest?

    init(repository: PhotoRepository = PhotoRepository()) {
        self.repository = repository
        bind()
    }

    func search(keyword: String, limit: Int = 50, offset: Int = 0) {
        let request = SearchPhotoRequest(keyword: keyword, limit: limit, offset: offset)
        state.next(.requesting)
        repository.search(request: request) { [unowned self] result in
            switch result {
            case .success(let value):
                self.items.replace(with: self.items.array + value.elements, performDiff: true)
                self.nextRequest = value.nextRequest
                self.state.next(.none)
                self.hasVisibleItems.next(!self.items.isEmpty)
            case .failure(let error):
                print("error: \(error)")
                self.state.next(.error)
            }
        }
    }

    func requestNext() {
        if let nextRequest = nextRequest {
            search(keyword: nextRequest.keyword, limit: nextRequest.limit, offset: nextRequest.offset)
        }
    }

    func clearItems() {
        items.removeAll()
    }
}
