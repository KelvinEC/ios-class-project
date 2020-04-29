//
//  RecentPostsViewProtocol.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

protocol RecentPostsViewProtocol: AnyObject
{
    func showPosts(_ posts: [PostModel])

    func showLoading()

    func hideLoading()

    func navigateToPostComments(post: PostModel)
}
