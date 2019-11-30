import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    func setup(for postModel: PostModel) {
        image.image = postModel.photo
    }
}
