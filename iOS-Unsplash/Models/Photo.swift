import Foundation

struct UnsplashPhotoResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photo]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Photo: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let color: String?
    let blurHash: String?
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: User
    let urls: PhotoURLs
    let downloads: Int?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case user
        case urls
        case downloads
        case location
    }
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
}

struct Location: Codable {
    let city: String?
    let country: String?

    var fullLocation: String {
        [city, country].compactMap { $0 }.joined(separator: ", ")
    }
}
