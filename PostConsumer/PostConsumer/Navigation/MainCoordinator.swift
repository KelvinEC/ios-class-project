//
//  MainCoordinator.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class MainCoordinator: NSObject, Coordinator
{
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController)
    {
        self.navigationController = navigationController
    }
    
    func start()
    {
        let getRecentPostsInteractor = GetRecentPostsInteractor(postsNetworking: PostsNetworking())
        let presenter = RecentPostsViewPresenter(getRecentPostsInteractor: getRecentPostsInteractor)
        let vc = RecentPostsViewController.instantiate()
        
        vc.coordinator = self
        vc.eventHandler = presenter
        presenter.view = vc
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func postComments(post: PostModel)
    {
        let getCommentsInteractor = GetPostCommentsInteractor(postsNetworking: PostsNetworking())
        let presenter = PostCommentsPresenter(post: post, getPostCommentsInteractor: getCommentsInteractor)
        let vc = PostCommentsViewController.instantiate()
        
        vc.coordinator = self
        vc.eventHandler = presenter
        presenter.view = vc
        
        navigationController.pushViewController(vc, animated: true)
    }
}
