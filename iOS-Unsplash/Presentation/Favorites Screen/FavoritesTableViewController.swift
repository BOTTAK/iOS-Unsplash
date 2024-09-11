import UIKit

class FavoritesTableViewController: UITableViewController {
    private let favoritesKey = "favorites"
    private var favoritePhotos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }

    private func setupTableView() {
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        tableView.rowHeight = 100
    }

    @objc private func loadFavorites() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.array(forKey: favoritesKey) as? [Data] {
            favoritePhotos = savedData.compactMap { try? decoder.decode(Photo.self, from: $0) }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePhotos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let photo = favoritePhotos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = favoritePhotos[indexPath.row]
        let detailVC = PhotoDetailViewController(photo: selectedPhoto)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
}
