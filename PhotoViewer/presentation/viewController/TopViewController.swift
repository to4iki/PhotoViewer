import UIKit

final class TopViewController: UIViewController {
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    fileprivate let usecase = SearchPhotoUseCase()
    fileprivate var photos: [Photo] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.becomeFirstResponder()
    }
}

extension TopViewController {
    fileprivate func searchPhoto(keyword: String) {
        usecase.execute(keyword: keyword) { result in
            switch result {
            case .success(let response):
                self.photos = response
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }

    fileprivate func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        photos = []
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension TopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.ReuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.setupLayout(photo: photos[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: lazy clauculate
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = (collectionView.frame.width / 2) - (layout.minimumLineSpacing / 2)
        let height = width
        return CGSize(width: width, height: height)
    }
}
