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
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String?
    let blurHash: String?
    let downloads: Int?
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let exif: Exif?
    let location: Location?
    let user: User
    let urls: PhotoURLs
    let currentUserCollections: [UserCollection]?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case downloads
        case likes
        case likedByUser = "liked_by_user"
        case description
        case exif
        case location
        case user
        case urls
        case currentUserCollections = "current_user_collections"
    }
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let totalLikes: Int?
    let totalPhotos: Int?
    let totalCollections: Int?
    let instagramUsername: String?
    let twitterUsername: String?
    let links: UserLinks

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case portfolioURL = "portfolio_url"
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case links
    }
}

struct UserLinks: Codable {
    let `self`: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Location: Codable {
    let name: String?
    let city: String?
    let country: String?
    let position: Position?

    struct Position: Codable {
        let latitude: Double?
        let longitude: Double?
    }
}

struct Exif: Codable {
    let make: String?
    let model: String?
    let exposureTime: String?
    let aperture: String?
    let focalLength: String?
    let iso: Int?

    enum CodingKeys: String, CodingKey {
        case make
        case model
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
}

struct UserCollection: Codable {
    let id: Int
    let title: String
    let publishedAt: String
    let lastCollectedAt: String
    let updatedAt: String
    let coverPhoto: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case coverPhoto = "cover_photo"
        case user
    }
}
