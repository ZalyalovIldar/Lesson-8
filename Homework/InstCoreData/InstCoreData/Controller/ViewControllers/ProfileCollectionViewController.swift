//
//  ProfileCollectionViewController.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import UIKit

//MARK: Identifiers of cells
private let headerIden = HeaderCollectionViewCell.cellIden()
private let postIden = PostCollectionViewCell.cellIden()

//MARK: Identifiers of Segue
private let segueListIden = "goToList"

class ProfileCollectionViewController: UICollectionViewController {
    
    //MARK: DataManagers
    let postDM = PostDataManager.shared
    let userDM = UserDataManager()
    
    //MARK: Fields
    var idOfUser = 1
    var user: User!
    var postsOfUser: [Post]!
    var getPostFromArray: ((Int) -> Post)!

    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //В принципе user уже должен быть после авторизации, поэтому это костыль
        self.user = userDM.getUser(nickname: "romash_only")
        
        getPostFromArray = { [weak self] index in
            self!.postsOfUser[index]
        }

        // Register cell classes
        self.collectionView.registerCell(HeaderCollectionViewCell.self)
        self.collectionView.registerCell(PostCollectionViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postsOfUser = postDM.syncGetAllOfUser(user: user)
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if section == 0 {
            return 1
        }
        else {
            return postsOfUser.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerIden, for: indexPath) as! HeaderCollectionViewCell
            
            cell.configure(with: user)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postIden, for: indexPath) as! PostCollectionViewCell

            cell.configure(with: getPostFromArray(indexPath.item))
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section != 0 {
            performSegue(withIdentifier: segueListIden, sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueListIden, let index = sender as? IndexPath {

            let destController = segue.destination as! TableViewController
            
            destController.postsOfUser = postsOfUser
            destController.cursorIndex = IndexPath(row: index.item, section: 0)
        }
    }
}
