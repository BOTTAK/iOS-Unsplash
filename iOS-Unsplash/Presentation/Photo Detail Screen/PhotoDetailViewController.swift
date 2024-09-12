import UIKit

class PhotoDetailViewController: UIViewController {
    private let photo: Photo
    private let favoritesKey = "favorites"

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        if let url = URL(string: photo.urls.regular) {
            ImageCache.shared.getImage(forUrl: url) { [weak self] image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])

        let authorLabel = UILabel()
        authorLabel.text = "Author: \(photo.user.name)"
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorLabel)

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let dateLabel = UILabel()
        dateLabel.text = "Created at: \(photo.createdAt)"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let locationLabel = UILabel()
        locationLabel.text = "Location: \(photo.location?.position)"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let downloadsLabel = UILabel()
        downloadsLabel.text = "Downloads: \(photo.downloads)"
        downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downloadsLabel)

        NSLayoutConstraint.activate([
            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let favoriteButton = UIButton(type: .system)
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func addToFavorites() {
        let encoder = JSONEncoder()
        if let encodedPhoto = try? encoder.encode(photo) {
            var favorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Data] ?? []
            favorites.append(encodedPhoto)
            UserDefaults.standard.setValue(favorites, forKey: favoritesKey)

            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
            showAlert("Photo added to Favorites")
        } else {
            showAlert("Failed to add to Favorites")
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
