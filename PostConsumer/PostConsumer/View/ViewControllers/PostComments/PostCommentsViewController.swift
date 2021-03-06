//
//  PostCommentsViewController.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

class PostCommentsViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var postCommentTableView: UITableView!
    
    // MARK: - Private Properties
    private var _dataSource: PostCommentsDataSource?
    private var _refreshControl: UIRefreshControl?
    
    // MARK: - Public Properties
    var eventHandler: PostCommentsPresenter?
    weak var coordinator: MainCoordinator?
    
    // MARK: - View Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        _setupTableView()
    }
    
    // MARK: - Setup Functions
    private func _setupTableView()
    {
        _dataSource = PostCommentsDataSource(tablewView: postCommentTableView)
        
        postCommentTableView.delegate = _dataSource
        postCommentTableView.dataSource = _dataSource
        postCommentTableView.tableFooterView = UIView()
        
        _refreshControl = UIRefreshControl()
        _refreshControl?.addTarget(eventHandler, action: #selector(eventHandler?.refreshComments), for: .valueChanged)
        _refreshControl?.attributedTitle =  NSAttributedString(string: NSLocalizedString("Updating your data",
                                                                                         comment: ""))
        
        postCommentTableView.refreshControl = _refreshControl
    }
}

extension PostCommentsViewController: PostCommentsViewProtocol
{
    func showTitle(postName: String)
    {
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = .black
        label.text = NSLocalizedString("What people says about", comment: "") + "\n" + postName
        self.navigationItem.titleView = label
    }
    
    func showComments(_ comments: [PostCommentsModel])
    {
        _dataSource?.comments.removeAll()
        _dataSource?.comments.append(contentsOf: comments)
        
        postCommentTableView.reloadData()
    }
    
    func showLoading()
    {
        _refreshControl?.beginRefreshing()
    }
    
    func hideLoading()
    {
        _refreshControl?.endRefreshing()
    }
}
