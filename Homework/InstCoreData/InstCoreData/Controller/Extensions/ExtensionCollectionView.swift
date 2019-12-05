//
//  ExtensionCollectionView.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    /// Method for register cell
    /// - Parameter cell: cell for register
    func registerCell(_ cell: CustomCell.Type) {
        register(cell.cellNib(), forCellWithReuseIdentifier: cell.cellIden())
    }
}

extension UITableView {
    
    /// Method for register cell
    /// - Parameter cell: cell for register
    func registerCell(_ cell: CustomCell.Type) {
        register(cell.cellNib(), forCellReuseIdentifier: cell.cellIden())
    }
}
