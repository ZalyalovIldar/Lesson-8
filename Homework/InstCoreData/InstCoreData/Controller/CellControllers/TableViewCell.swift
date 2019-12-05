//
//  TableViewCell.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import UIKit

/// Cell Controller Of TableView
class TableViewCell: UITableViewCell, CustomCell {
    
    //MARK: Fields
    var post: Post!
    weak var delegate: TableViewControllerDelegate?
    
    //MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var showCommentsButton: UIButton!
    @IBOutlet weak var textOfPostLabel: UILabel!
    @IBOutlet weak var dateOfPostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customAvatar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deletePostButtonPressed(_ sender: Any) {
        delegate?.didChangeInfo(post)
    }
    
    //MARK: Content filling
    /// Function for content filling of Cell
    /// - Parameter post: post of Cell
    func configure(with post: Post) {
        self.post = post
        preparePost()
    }
    
    
    func preparePost() {
        avatarImageView.image = UIImage(named: post.user!.avatarImage!)
        userNicknameLabel.setTitle(post.user!.nickname, for: .normal)
        postImageView.image = UIImage(named: post.image!)
        textOfPostLabel.text = post.text
        dateOfPostLabel.text = datePrepare(date: post.date!)
    }
    
    //MARK: Avatar Settings
    /// Function for settings Avatar
    func customAvatar() {
        
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = (avatarImageView.bounds.width ) / 2
        avatarImageView.clipsToBounds = true
    }
    
    //MARK: CustomCell Protocol implementation
    static func cellNib() -> UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static func cellIden() -> String {
        return String(describing: self)
    }
    
    //MARK: DateSettings
    func datePrepare(date: Date) -> String {
        let calendar = Calendar.current
        
       return  "\(calendar.component(.day, from: date)) \(calendar.component(.month, from: date))"
    }
}
