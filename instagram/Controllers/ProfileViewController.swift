import UIKit

private let imageCellIdentifier = "imageCell"
private let imageCellNibName = "ImageCell"
private let showPostsSegueName = "showPostsSegue"

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postsAmountLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postModels: [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData() {
        
        LocalDataManager.shared.asyncGetPosts { postModels in
            DispatchQueue.main.async {
                self.postModels = postModels
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let postsVC = segue.destination as? PostsViewController else { return }
        guard let postIndexPath = sender as? IndexPath else { return}
        postsVC.postIndexPath = postIndexPath
    }
}

//MARK: - Collection View

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        cell.setup(for: postModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumInteritemSpacing = 03
        layout.minimumLineSpacing = 03
        layout.invalidateLayout()

        return CGSize(width: ((self.view.frame.width/3) - 4), height:((self.view.frame.width / 3) - 4));
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: showPostsSegueName, sender: indexPath)
    }
}

//MARK: - Setup Functions

extension ProfileViewController {
    
    func setupUI() {
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        
        editProfileButton.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = editProfileButton.frame.height / 8
    }
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibCell = UINib(nibName: imageCellNibName, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: imageCellIdentifier)
    }
}
