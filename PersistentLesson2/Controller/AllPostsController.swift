//
//  DetailTableViewController.swift
//  BlocksSwift
//
//  Created by Amir on 03.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class AllPostsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var user: User!
    var posts: [Post]!
    var indexPathRow: Int!
    
    weak var delegate: DeletePostDelegate!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPosts = [Post]()
    
    var searchBarIsEmpty: Bool {
        
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool { return searchController.isActive && !searchBarIsEmpty }
    
    //MARK: - VC Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTable()
        setupSearchController()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.scrollToRow(at: IndexPath(row: indexPathRow , section: 0), at: .top, animated: false)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredPosts.count : posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellId, for: indexPath) as! PostCell
        
        var post: Post
        
        post = isFiltering ? filteredPosts[indexPath.row] : posts[indexPath.row]
        
        cell.post = post
        cell.cellDelegate = self
        cell.configure(with: user)
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - Configure VC
extension AllPostsController {
    
    private func setupTable() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getData() {
        
        Manager.shared.asyncGetUser { [weak self] user in
            
            self?.user = user
        }
        
        Manager.shared.asyncGetPosts { [weak self] postsArray in
            
            self?.posts = postsArray
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: - SearchController setup
extension AllPostsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        Manager.shared.asyncSearchPost(for: searchController.searchBar.text!) { filteredPosts in
            
            self.filteredPosts = filteredPosts
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Post delete delegate
extension AllPostsController: DeletePostDelegate {
    
    func delete(post model: Post) {
        
        let alertController = UIAlertController(title: Constants.deleteAlertTitle, message: Constants.deleteAlertMessage, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Constants.cancelActionTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: Constants.deleteActionTitle, style: .destructive) { [weak self] action -> Void in
            
            Manager.shared.asyncDeletePost(with: model) { [weak self] posts in
                
                self?.posts = posts
                
                DispatchQueue.main.async {
                                    
                    self?.delegate?.delete(post: model)
                    self?.tableView.reloadData()
                }
            }
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
