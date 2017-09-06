import UIKit
import API

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Photozou.searchPhoto(keyword: "watermelon") { result in
            switch result {
            case .success(let response):
                print("success count: \(response.count)")
                print("success value: \(response)")
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
