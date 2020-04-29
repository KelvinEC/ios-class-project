//
//  RecentPostsViewPresenter.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

class RecentPostsViewPresenter
{
    // MARK: - Private Properties
    private let _getRecentPosts: GetRecentPostsInteractor
    private var _recentPosts: [PostModel]

    // MARK: - Public Properties
    weak var view: RecentPostsViewProtocol?

    init(getRecentPostsInteractor: GetRecentPostsInteractor)
    {
        _getRecentPosts = getRecentPostsInteractor
        _recentPosts = []
    }

    // MARK: - Public Methods
    func refreshPosts()
    {
        _getRecentPosts.resume { [weak self] result in
            guard let selfBlocked = self else {
                return
            }

            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    selfBlocked._recentPosts.append(contentsOf: posts)
                    selfBlocked.view?.showPosts(selfBlocked._recentPosts)
                case .failure(let err): break
                }
            }
        }
    }

    func postTapped(post: PostModel)
    {
        // Load recent posts and show new screen with Comments
    }
}

// MARK: - Presenter Extension
extension RecentPostsViewPresenter: Presenter
{
    func viewDidLoad()
    {
        refreshPosts()
    }

    func viewWillAppear()
    {
    }

    func viewDidAppear()
    {
    }

    func viewWillDisappear()
    {
    }

    func viewDidDisappear()
    {
    }
}
