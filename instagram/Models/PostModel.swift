import Foundation
import UIKit

class PostModel {
    
    var id = UUID()
    var userImage: UIImage?
    var nickName: String?
    var photo: UIImage?
    var text: String?
    var date: String?
    
    let localDataManager = LocalDataManager.shared

    func convertToPost() -> Post {

        let post = Post(context: localDataManager.context)
        post.id = self.id
        post.date = self.date
        post.nickname = self.nickName
        post.text = self.text
        post.photoData = self.photo?.pngData()
        post.userImageData = self.userImage?.pngData()

        return post
    }
}

