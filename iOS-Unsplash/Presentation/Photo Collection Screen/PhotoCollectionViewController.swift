import UIKit

class PhotoCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    private var photos: [Photo] = []
    private let searchBar = UISearchBar()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupCollectionView()
        setupSearchBar()
        fetchPhotos()
    }
    
    func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .white
    }
    
    func setupSearchBar() {
        navigationItem.titleView = searchBar
    }
    
    func fetchPhotos(query: String = "random") {
        UnsplashAPIClient.fetchPhotos(query: query) { result in
            switch result {
            case .success(let photos):
                print("Received \(photos.count) photos")
                if photos.isEmpty {
                    print("No photos received")
                } else {
                    for (index, photo) in photos.enumerated() {
                        print("Photo \(index + 1) URL: \(photo.urls.regular)")
                    }

                    self.photos = photos
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }

            case .failure(let error):
                print("Error fetching photos: \(error.localizedDescription)")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        let detailVC = PhotoDetailViewController(photo: selectedPhoto)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchPhotos(query: searchBar.text ?? "random")
    }
}
