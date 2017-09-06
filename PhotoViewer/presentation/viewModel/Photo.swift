import Foundation
import struct API.Photo

struct Photo {
    let url: URL

    /// translate from api data
    init(from: API.Photo) {
        self.url = from.imageURL
    }
}
