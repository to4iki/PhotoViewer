import Bond

enum RequestState {
    case none
    case requesting
    case error
}

protocol RequestListType {
    associatedtype Item
    var items: MutableObservableArray<Item> { get }
    var state: Observable<RequestState> { get }
    var hasVisibleItems: Observable<Bool> { get }
    var noViewHidden: Observable<Bool> { get }
    var indicatorViewHidden: Observable<Bool> { get }
    var errorViewHidden: Observable<Bool> { get }
}

extension RequestListType {
    func bind() {
        Observable(!items.isEmpty)
            .bind(to: hasVisibleItems)
        state
            .combineLatest(with: hasVisibleItems)
            .map { (state, hasVisible) -> Bool in
                !(state == .none && !hasVisible)
            }
            .bind(to: noViewHidden)
        state
            .combineLatest(with: hasVisibleItems)
            .map { (state, hasVisible) -> Bool in
                !(state == .requesting && !hasVisible)
            }
            .bind(to: indicatorViewHidden)
        state
            .combineLatest(with: hasVisibleItems)
            .map { (state, hasVisible) -> Bool in
                !(state == .error && !hasVisible)
            }
            .bind(to: errorViewHidden)
    }
}
