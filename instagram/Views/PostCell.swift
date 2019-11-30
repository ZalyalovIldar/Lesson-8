import UIKit

class PostCell: UITableViewCell {

    var postModel: PostModel!
    weak var postCellDelegate: PostCellDelegate!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func showMoreButtonPressed(_ sender: UIButton) {
        
        let actionSheet = getActionSheet()
        postCellDelegate.presentActionSheet(actionSheet: actionSheet)
    }
    
    //MARK: - Setups
    
    func setup(for postModel: PostModel) {
        
        setupUI()
        
        self.postModel = postModel
        
        userImage.image = postModel.userImage
        userName.text = postModel.nickName
        photo.image = postModel.photo
        postText.text = postModel.text
        dateLabel.text = postModel.date
    }
    
    func setupUI() {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        selectionStyle = .none
    }
    
    //MARK: - ActionSheet
    
    func getActionSheet() -> UIAlertController {
        
        let mainActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            LocalDataManager.shared.asyncDeletePost(with: self.postModel.id) {
                self.postCellDelegate.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        mainActionSheet.addAction(deleteAction)
        mainActionSheet.addAction(cancelAction)
        return mainActionSheet
    }
}
