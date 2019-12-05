//
//  ExtensionTableViewController.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 19.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

extension TableViewController: UISearchResultsUpdating {
    
    /// Method of Search Controller for updating
    /// - Parameter searchController: searchController
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
