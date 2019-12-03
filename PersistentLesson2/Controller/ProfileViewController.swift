//
//  ProfileViewController.swift
//  BlocksSwift
//
//  Created by Евгений on 25.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PostDeletingDelegate {
    
    
    //Custom post cell identifier
    let postImageCellReuseIdentifier = "reusableImageCell"
    //Custom post cell nib identifier
    let customCellNibName = "CustomImagePostCollectionViewCell"
    //CollectionView cell selecting action segue identifier
    let toDetailsSegueIdentifier = "toDetailsPostController"
    //UISpacings
    let minimalSpacingThree: CGFloat = 3
    let minimalSpacingFour: CGFloat = 4
    
    //Data Manager singleton
    var dataManager = DataManager.dataManagerSingleton
    //Array of posts
    var posts: [PostStructure] = []
    
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var profilePostsCollectionView: UICollectionView!
    @IBOutlet weak var profileNameOfUserLabel: UILabel!
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
        profileAvatarImageView.layer.cornerRadius = profileAvatarImageView.bounds.height / 2
        profilePostsCollectionView.dataSource = self
        profilePostsCollectionView.delegate = self
        profilePostsCollectionView.register(UINib(nibName: customCellNibName, bundle: nil), forCellWithReuseIdentifier: postImageCellReuseIdentifier)
        dataManager.asyncGet {  [weak self] posts in
            
            self?.posts = posts
            DispatchQueue.main.async {
                self!.numberOfPostsLabel.text = "\(self!.posts.count)"
                self?.profilePostsCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - CollectionView DelegateFlowLayout, DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = profilePostsCollectionView.dequeueReusableCell(withReuseIdentifier: postImageCellReuseIdentifier, for: indexPath) as! CustomImagePostCollectionViewCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    //Made for Instagram-like collectionView design. Copied from StackOverflow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: minimalSpacingThree, left: minimalSpacingThree, bottom: minimalSpacingThree, right: minimalSpacingThree)
        layout.minimumInteritemSpacing = minimalSpacingThree
        layout.minimumLineSpacing = minimalSpacingThree
        layout.invalidateLayout()
        
        return CGSize(width: ((self.view.frame.width / minimalSpacingThree) - minimalSpacingFour), height:((self.view.frame.width / minimalSpacingThree) - minimalSpacingFour));
    }
    
    //MARK: - CollectionView Cell Selecting Actions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: toDetailsSegueIdentifier, sender: indexPath)
    }
    
    //MARK: - Segue Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == toDetailsSegueIdentifier, let scrollToIndexPath = sender as? IndexPath {
            
            let destinationVC = segue.destination as! PostDetailViewController
            destinationVC.configure(numberOfPosts: posts.count, indexPath: scrollToIndexPath, delegate: self)
        }
    }
    
    //MARK: - Delegate functions
    
    /// Delegate deleting function
    /// - Parameter post: Post, which need to delete
    func deletePost(post: PostStructure) {
        
        dataManager.asyncGet { posts in
            
            self.posts = posts
            DispatchQueue.main.async {
                self.numberOfPostsLabel.text = "\(posts.count)"
                self.profilePostsCollectionView.reloadData()
            }
        }
    }
}
