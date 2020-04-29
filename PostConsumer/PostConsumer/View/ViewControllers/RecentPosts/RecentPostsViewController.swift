//
//  ViewController.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

// Accordingly https://openradar.appspot.com/27468436 UIRefresh control is broke when calls begin Rereshing.
class RecentPostsViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var recentPostTableView: UITableView!
    
    // MARK: - View Private Properties
    private var _datasource: RecentPostsDataSource?
    private var _refreshControl: UIRefreshControl?
    
    // MARK: - View Public Properties
    var eventHandler: RecentPostsViewPresenter?
    weak var coordinator: MainCoordinator?
    
    // MARK: - View Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        _setupTableView()
        _setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        eventHandler?.viewDidAppear()
    }
    
    // MARK: - Setup Functions
    private func _setupTableView()
    {
        _datasource = RecentPostsDataSource(tablewView: recentPostTableView)
        
        recentPostTableView.delegate = _datasource
        recentPostTableView.dataSource = _datasource
        recentPostTableView.tableFooterView = UIView()
        _datasource?.delegate = self
        
        _refreshControl = UIRefreshControl()
        _refreshControl?.attributedTitle =  NSAttributedString(string: NSLocalizedString("Updating your data",
                                                                                         comment: ""))
        _refreshControl?.addTarget(eventHandler, action: #selector(eventHandler?.refreshPosts), for: .valueChanged)
        recentPostTableView.refreshControl = _refreshControl
    }
    
    private func _setupNavigationBar()
    {
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        self.navigationItem.title = NSLocalizedString("Recent Posts", comment: "")
    }
}

extension RecentPostsViewController: RecentPostsViewProtocol
{
    func showPosts(_ posts: [PostModel])
    {
        _datasource?.posts.removeAll()
        _datasource?.posts.append(contentsOf: posts)
        
        recentPostTableView.reloadData()
    }
    
    func showLoading()
    {
        guard let refresh = _refreshControl else {
            return
        }
        
        refresh.beginRefreshing()
    }
    
    func hideLoading()
    {
        _refreshControl?.endRefreshing()
    }
    
    func navigateToPostComments(post: PostModel)
    {
        coordinator?.postComments(post: post)
    }
}

extension RecentPostsViewController: RecentPostInteraction
{
    func tappedOnPost(post: PostModel, index: IndexPath)
    {
        eventHandler?.postTapped(post: post)
    }
}
