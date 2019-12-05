//
//  PostCollectionViewCell.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import UIKit

/// Controller of Posts
class PostCollectionViewCell: UICollectionViewCell, CustomCell {
    
    //MARK: Outlets
    @IBOutlet weak var imageOfPost: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Content filling
    /// Function for content filling of Cell
    /// - Parameter post: post of Cell
    func configure(with post: Post) {
        imageOfPost.image = UIImage(named: post.image!)
    }
    
    //MARK: CustomCell Protocol implementation
    static func cellNib() -> UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static func cellIden() -> String {
        return String(describing: self)
    }
}
