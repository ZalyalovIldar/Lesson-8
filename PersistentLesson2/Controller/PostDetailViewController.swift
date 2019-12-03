//
//  PostDetailViewController.swift
//  BlocksSwift
//
//  Created by Евгений on 25.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

//Post deleting function delegate
protocol PostDeletingDelegate {
    func deletePost(post: PostStructure)
}

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PostDeletingDelegate {
    
    
    //Custom tableview cell reuse identifier
    let customPostCellReuseIdentifier = "postCustomCell"
    //Custom tableview cell nib identifier
    let customPostCellNibName = "PostTableViewCell"
    //Action sheet title
    let deleteActionSheetTitle = "Удаление"
    //Action sheet message
    let deleteActionSheetMessage = "Удалить?"
    //Action sheet cancel button title
    let cancelActionSheetButton = "Отмена"
    //Action sheet delete button title
    let deleteActionSheetButton = "Удалить"
    //Estimated row height
    let estimatedRowHeight: CGFloat = 500
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var postsTableView: UITableView!
    
    //Array of posts
    var posts: [PostStructure]!
    //Index path of row to scroll to
    var scrollToIndexPath: IndexPath!
    //Data Manager singleton
    var dataManager = DataManager.dataManagerSingleton
    //Is data downloaded yet
    var isDataOk = false
    //Counter of posts in array
    var numberOfPosts: Int!
    //Delegate to work with
    var delegate: PostDeletingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isDataOk {
            dataManager.asyncGet { posts in
                
                self.posts = posts
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
            }
            
            postsTableView.register(UINib(nibName: customPostCellNibName, bundle: nil), forCellReuseIdentifier: customPostCellReuseIdentifier)
            postsTableView.estimatedRowHeight = estimatedRowHeight
            postsTableView.rowHeight = UITableView.automaticDimension
            postsTableView.delegate = self
            postsTableView.dataSource = self
            postsTableView.keyboardDismissMode = .onDrag
            searchBar.delegate = self
            isDataOk = true
        }
        
        postsTableView.scrollToRow(at: scrollToIndexPath, at: .middle, animated: false)
    }
    
    //MARK: - TableView Delegate, DataSource; SearchBar Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTableView.dequeueReusableCell(withIdentifier: customPostCellReuseIdentifier) as! PostTableViewCell
        cell.configure(with: posts[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            
            dataManager.asyncSearch(searchText) { posts in
                
                self.posts = posts
                self.numberOfPosts = posts.count
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
            }
        } else {
            
            dataManager.asyncGet { posts in
                
                self.posts = posts
                self.numberOfPosts = posts.count
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Controller configure
    
    
    /// Configures the controller with needed parameters
    /// - Parameter numberOfPosts: Number of posts in data manager
    /// - Parameter indexPath: IndexPath to scroll to
    /// - Parameter delegate: Delegate to work with
    func configure(numberOfPosts: Int, indexPath: IndexPath, delegate: PostDeletingDelegate) {
        
        self.numberOfPosts = numberOfPosts
        self.scrollToIndexPath = indexPath
        self.delegate = delegate
    }
    
    //MARK: - Posts actions
    
    /// Delegate delete function
    /// - Parameter post: Post, which need to delete
    func deletePost(post: PostStructure) {
        
        let actionSheetController = UIAlertController(title: deleteActionSheetTitle, message: deleteActionSheetMessage, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelActionSheetButton, style: .cancel)
        let deleteAction = UIAlertAction(title: deleteActionSheetButton, style: .destructive) { [weak self] action -> Void in
            
            self?.dataManager.asyncDelete(post) { posts in
                
                DispatchQueue.main.async {
                    self?.posts = posts
                    self?.numberOfPosts = posts.count
                    self?.delegate?.deletePost(post: post)
                    self?.postsTableView.reloadData()
                }
            }
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(deleteAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
