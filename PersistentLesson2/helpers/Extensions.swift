//
//  Extensions.swift
//  PersistanceLesson1
//
//  Created by Enoxus on 20/11/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Making UIViewController conform to UICollectionViewDelegateFlowLayout in order to achieve insta-like layout
extension UIViewController: UICollectionViewDelegateFlowLayout {
    
    ///Taken from stackoverflow
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
}

extension UITableView {
    
    /// registers the cell by its type
    /// - Parameter cell: type of the cell that should be registered
    func register(cell: UITableViewCell.Type) {
        self.register(UINib(nibName: cell.nibName, bundle: nil), forCellReuseIdentifier: cell.nibName)
    }
}

extension UITableViewCell {
    
    /// returns the name of the class for usage as a nib name
    static var nibName: String {
        
        get {
            return String(describing: self)
        }
    }
}

extension NSManagedObject {
    
    public class var className: String {
        
        get {
            return String(describing: self)
        }
    }
}
