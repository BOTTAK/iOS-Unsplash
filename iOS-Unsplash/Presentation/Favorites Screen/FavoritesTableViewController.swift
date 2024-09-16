import UIKit

class FavoritesTableViewController: UITableViewController, UITableViewDragDelegate, UITableViewDropDelegate {

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

        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    @objc private func loadFavorites() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.array(forKey: favoritesKey) as? [Data] {
            favoritePhotos = savedData.compactMap { try? decoder.decode(Photo.self, from: $0) }
        }
        tableView.reloadData()
    }

    private func saveFavorites() {
        let encoder = JSONEncoder()
        let data = favoritePhotos.compactMap { try? encoder.encode($0) }
        UserDefaults.standard.set(data, forKey: favoritesKey)
    }

    // MARK: - Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePhotos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let photo = favoritePhotos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoritePhotos.remove(at: indexPath.row)
            saveFavorites()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        }
    }

    // MARK: - UITableViewDragDelegate

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let photo = favoritePhotos[indexPath.row]
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = photo
        return [dragItem]
    }

    // MARK: - UITableViewDropDelegate

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UITableViewDropProposal(operation: .forbidden)
        }
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath,
               let photo = dropItem.dragItem.localObject as? Photo {

                tableView.performBatchUpdates({
                    favoritePhotos.remove(at: sourceIndexPath.row)
                    favoritePhotos.insert(photo, at: destinationIndexPath.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                }, completion: nil)

                coordinator.drop(dropItem.dragItem, toRowAt: destinationIndexPath)
                saveFavorites()
                NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
            }
        }
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
