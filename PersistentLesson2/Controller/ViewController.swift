//
//  ViewController.swift
//  BlocksSwift
//
//  Created by Ильдар Залялов on 16/10/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var user: User!
    var posts: [Post]!
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove separator line from navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        configureVC()
    }
    
    //MARK: - Configuring
    func configureVC() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        Manager.shared.asyncGetUser { [weak self] user in
            self?.user = user
           
            DispatchQueue.main.async { [weak self] in
                self?.title = user.nickName
            }
        }
        
        Manager.shared.asyncGetPosts { [weak self] posts in
            
            self?.posts = posts

            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    //MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            performSegue(withIdentifier: Constants.showFullPhotoSegueId, sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.showFullPhotoSegueId,  let indexPath = sender as? IndexPath {
            
            let dest = segue.destination as! AllPostsController
            
            dest.delegate = self
            dest.indexPathRow = indexPath.row
        }
    }
}

//MARK: - CollectionView DataSource
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section > 0 {
            return posts.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section != 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.postImageCellId, for: indexPath) as! PostImageCell
            
            let post = posts[indexPath.item]
            
            cell.configure(with: post)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.userInfoCellId, for: indexPath) as! UserInfoCell
                        
            cell.setupCell(with: user)            
            
            return cell
        }
    }
}
//MARK: - DeletePostDelegate
extension ViewController: DeletePostDelegate {
    
    func delete(post model: Post) {
        
        Manager.shared.asyncGetPosts { [weak self] posts in
            
            self?.posts = posts
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView layout
extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section != 0 {
            
            let width = (view.bounds.width - 4) / 3
            
            return CGSize(width: width, height: width);
            
        } else {
            return CGSize(width: self.view.bounds.width, height: Constants.userInfoCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
