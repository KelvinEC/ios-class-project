//
//  ViewController.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

class RecentPostsViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var recentPostTableView: UITableView!

    // MARK: - View Private Properties
    private var _datasource: RecentPostsDataSource?

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

    // MARK: - Setup Functions
    private func _setupTableView()
    {
        _datasource = RecentPostsDataSource(tablewView: recentPostTableView)

        recentPostTableView.delegate = _datasource
        recentPostTableView.dataSource = _datasource
        recentPostTableView.tableFooterView = UIView()
        _datasource?.delegate = self
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
    }

    func hideLoading()
    {
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
