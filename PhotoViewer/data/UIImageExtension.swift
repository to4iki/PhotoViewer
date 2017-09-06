import UIKit

extension UIImageView {
    func setImage(with url: URL, expire: TimeInterval = 5 * 60) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: expire)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            switch (data, error) {
            case (_, let error?):
                print("error: \(error.localizedDescription)")
            case (let data?, _):
                guard let image = UIImage(data: data) else {
                    print("error: convert to UIImage")
                    break
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            default:
                break
            }

        }
        task.resume()
    }
}
