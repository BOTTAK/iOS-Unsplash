import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()

    private init() {}

    func getImage(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString

        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: key)
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}

