//
//  UserInfoCell.swift
//  Threads
//
//  Created by Amir on 24.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class UserInfoCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    //MARK: - Property
    var posts: [Post]!
    
    //MARK: - Configuring cell
    func setupCell(with user: User) {
        
        Manager.shared.asyncGetPosts { [weak self] postsArray in
            self?.posts = postsArray            
        }
        
        DispatchQueue.main.async {
            self.configureCell(with: user)
        }
    }
    
    private func configureCell(with user: User) {
        
        configureImageView(user)
        configureMainBlock(user)
        configureEditButton()
    }
    
    private func configureImageView(_ user: User) {
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.image = UIImage(named: user.profileImage!)
        profileImageView.layer.borderColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        profileImageView.layer.borderWidth = 1
        profileImageView.clipsToBounds = true
    }
    
    private func configureMainBlock(_ user: User) {
        
        postsCountLabel.text = String(posts.count)
        followersCountLabel.text = String(64)
        followingsCountLabel.text = String(151)
        nameLabel.text = user.name
    }
    
    private func configureEditButton() {
        
        editButton.layer.cornerRadius = 5
        editButton.layer.borderColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        editButton.layer.borderWidth = 1
    }
    
}
