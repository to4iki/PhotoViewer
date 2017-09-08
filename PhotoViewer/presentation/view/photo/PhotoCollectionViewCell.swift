import UIKit
import API
import Kingfisher

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let ReuseIdentifier = "PhotoCollectionViewCell"
    
    @IBOutlet fileprivate weak var imageView: UIImageView!

    func setupLayout(photo: Photo) {
        imageView.kf.setImage(with: photo.imageURL)
    }
}
