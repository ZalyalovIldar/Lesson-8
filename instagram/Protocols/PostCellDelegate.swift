import UIKit

protocol PostCellDelegate: AnyObject {
    
    func presentActionSheet(actionSheet: UIAlertController)
    
    func reloadData()
}
