//
//  TableViewController.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import UIKit


/// Delegate
protocol TableViewControllerDelegate: AnyObject {
    func didChangeInfo(_ post: Post)
}

//MARK: Identifiers of cells
private let postIden = TableViewCell.cellIden()

class TableViewController: UITableViewController, UISearchBarDelegate, TableViewControllerDelegate {
    
    //MARK: DataManagers
    let postDM = PostDataManager.shared

    //MARK: Fields
    let searchController = UISearchController (searchResultsController: nil )
    var postsOfUser: [Post]!
    var filterPosts: [Post] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    var cursorIndex: IndexPath!
    var getPostFromArray: ((Int) -> Post)!

    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarPrepare()

        getPostFromArray = { [weak self] index in
            self!.postsOfUser[index]
        }
        
        self.tableView.registerCell(TableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        //плохо работает, не понимаю почему совсем
        tableView.scrollToRow(at: cursorIndex, at: .top, animated: false)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filterPosts.count
        }
        return postsOfUser.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: postIden, for: indexPath) as! TableViewCell

        if isFiltering {
            cell.configure(with: filterPosts[indexPath.item])
        }
        else {
            cell.configure(with: getPostFromArray(indexPath.item))
        }
        
        cell.delegate = self

        return cell
    }
    
    /// Showing alerts for deleting
    /// - Parameter post: post for deleting
    func didChangeInfo(_ post: Post) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deletePost = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
        
            let alertDelete = UIAlertController(title: "Удалить пост?", message: nil, preferredStyle: .actionSheet)
            
            let delete = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
                self.postDM.asyncRemove(id: post.id!) { [weak self] (allPosts) in
                    
                    DispatchQueue.main.async {

                        self?.postsOfUser = allPosts
                        self?.tableView.reloadData()
                    }
                }
            }
            let cancelDelete = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alertDelete.addAction(delete)
            alertDelete.addAction(cancelDelete)
            
            self.present(alertDelete, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(deletePost)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    /// Settings of SearchController
    func searchBarPrepare() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск среди постов"
        navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
    }
    
    
    /// Filtering content
    /// - Parameter searchText: text for search
    func filterContentForSearchText(_ searchText: String) {
        
        postDM.asyncSearch(textOfSearch: searchText) { (filterPosts) in
            self.filterPosts = filterPosts
            self.tableView.reloadData()
        }
    }
}
