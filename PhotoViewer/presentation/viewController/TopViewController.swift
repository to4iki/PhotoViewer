import UIKit
import API
import Bond

final class TopViewController: UIViewController {
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var indicatorView: UIActivityIndicatorView!
    
    fileprivate lazy var collectionViewCellSize: CGSize = {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (self.collectionView.frame.width / 2) - (layout.minimumLineSpacing / 2)
        let height = width
        return CGSize(width: width, height: height)
    }()

    fileprivate var reachedBottom = false {
        didSet {
            if reachedBottom == oldValue { return }
            guard !reachedBottom else { return }
            didReachBottom()
        }
    }

    fileprivate let viewModel = PhotoListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.delegate = self
        searchBar.becomeFirstResponder()
        bindViewModel()
    }
}

extension TopViewController {
    fileprivate func bindViewModel() {
        viewModel.indicatorViewHidden
            .bind(to: indicatorView.reactive.isHidden)

        _ = viewModel.state
            .observeNext { state in
                UIApplication.shared.isNetworkActivityIndicatorVisible = (state == .requesting)
        }

        _ = viewModel.noDataViewHidden
            .skip(first: 1)
            .debounce(interval: 0.5)
            .observeNext { [unowned self] isHidden in
                if !isHidden {
                    // TODO: show NoDataView
                    self.presentAlert(message: "No Data")
                }
        }

        _ = viewModel.errorViewHidden
            .observeNext { [unowned self] isHidden in
                if !isHidden {
                    // TODO: show RetryRequestView
                    self.presentAlert(message: "Error")
                }
        }

        viewModel.items
            .bind(to: collectionView) { (items, indexPath, collectionView) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCollectionViewCell.ReuseIdentifier,
                    for: indexPath) as! PhotoCollectionViewCell
                cell.setupLayout(photo: items.array[indexPath.row])
                return cell
        }
    }

    fileprivate func searchPhoto(keyword: String) {
        viewModel.clearItems()
        viewModel.search(keyword: keyword)
    }

    fileprivate func didReachBottom() {
        print("scrollViewDidRechBottom")
        viewModel.requestNext()
    }

    private func presentAlert(message: String, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: flag, completion: completion)
    }
}

// MARK: - UISearchBarDelegate
extension TopViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = true
        if let text = searchBar.text, !text.isEmpty {
            searchPhoto(keyword: text)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        viewModel.clearItems()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize
    }
}

// MARK: - UIScrollViewDelegate
extension TopViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxDistance = max(0, scrollView.contentSize.height - scrollView.bounds.height)
        reachedBottom = maxDistance < scrollView.contentOffset.y
    }
}
