import UIKit

class PhotoCollectionViewController: UICollectionViewController, UISearchBarDelegate {

    private var photos: [Photo] = []
    private let searchBar = UISearchBar()
    private var currentQuery: String = "random"
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var isLastPage: Bool = false

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.returnKeyType = .done
        setupCollectionView()
        setupSearchBar()
        fetchPhotos(query: currentQuery, page: currentPage)
    }

    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .white
    }

    private func setupSearchBar() {
        navigationItem.titleView = searchBar
    }

    private func fetchPhotos(query: String, page: Int) {
        guard !isLoading else { return }
        isLoading = true
        UnsplashAPIClient.fetchPhotos(query: query, page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let photos):
                if photos.isEmpty {
                    self.isLastPage = true
                    print("Больше нет фотографий")
                } else {
                    if page == 1 {
                        self.photos = photos
                    } else {
                        self.photos.append(contentsOf: photos)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                print("Ошибка при загрузке фотографий: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }

    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height * 2 {
            if !isLoading && !isLastPage {
                currentPage += 1
                fetchPhotos(query: currentQuery, page: currentPage)
            }
        }
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        let detailVC = PhotoDetailViewController(photo: selectedPhoto)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            currentQuery = query
            currentPage = 1
            isLastPage = false
            photos.removeAll()
            collectionView.reloadData()
            fetchPhotos(query: currentQuery, page: currentPage)
        }
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
