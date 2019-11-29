//
//  ImageCollectionViewCell.swift
//  BlocksSwift
//
//  Created by Amir on 25.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class PostImageCell: UICollectionViewCell {
    
    //MARK: - Outlet
    @IBOutlet weak var cellImageView: UIImageView!
    
    //MARK: - Configuring cell
    func configure(with post: Post) {
        cellImageView.image = UIImage(named: post.image!)
    }
}
