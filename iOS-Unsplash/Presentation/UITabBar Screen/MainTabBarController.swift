import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let photoCollectionVC = PhotoCollectionViewController()
        let favoritesVC = FavoritesTableViewController()

        photoCollectionVC.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "photo"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        viewControllers = [UINavigationController(rootViewController: photoCollectionVC),
                           UINavigationController(rootViewController: favoritesVC)]
    }
}
