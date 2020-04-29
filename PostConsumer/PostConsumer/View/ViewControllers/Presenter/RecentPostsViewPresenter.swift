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
    @objc func refreshPosts()
    {
        view?.showLoading()
        _getRecentPosts.resume { [weak self] result in
            guard let selfBlocked = self else {
                return
            }
            
            DispatchQueue.main.async {
                selfBlocked.view?.hideLoading()
                switch result {
                case .success(let posts):
                    selfBlocked._recentPosts.append(contentsOf: posts)
                    selfBlocked.view?.showPosts(selfBlocked._recentPosts)
                case .failure(let err):
                    switch err {
                    case .connectionError:
                        selfBlocked.view?.showNetworkError()
                    case .decodingError, .serverUnavailable:
                        selfBlocked.view?.showUnknownError()
                    case .noInternetConnection, .serverError:
                        selfBlocked.view?.showNoInternetConnection()
                    }
                }
            }
        }
    }
    
    func postTapped(post: PostModel)
    {
        view?.navigateToPostComments(post: post)
    }
}

// MARK: - Presenter Extension
extension RecentPostsViewPresenter: Presenter
{
    func viewDidLoad()
    {
    }
    
    func viewWillAppear()
    {
    }
    
    func viewDidAppear()
    {
        refreshPosts()
    }
    
    func viewWillDisappear()
    {
    }
    
    func viewDidDisappear()
    {
    }
}
