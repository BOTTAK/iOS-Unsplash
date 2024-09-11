import Foundation

class UnsplashAPIClient {
    private let baseURL = "https://api.unsplash.com"
    private static let accessKey = "N9ywBDqSu01tSduQJeTPW1NC8CZkSsDtevi7QA1ab2E"
    
    static func fetchPhotos(query: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(accessKey)&per_page=20"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UnsplashPhotoResponse.self, from: data)
                completion(.success(response.results))
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
}
