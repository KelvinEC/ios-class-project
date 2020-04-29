//
//  GetRecentPostsInteractor.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

class GetRecentPostsInteractor
{
    private let _postsNetworking: PostsNetworking
    
    init(postsNetworking: PostsNetworking)
    {
        self._postsNetworking = postsNetworking
    }
    
    func resume(handler: @escaping (Result<[PostModel], NetworkErrors>) -> Void)
    {
        QueueUtils.interactorsQueue.async {
            self._postsNetworking.getRecentPosts { result in
                switch result {
                case .success(let posts):
                    handler(.success(posts.sorted(by: { $0.id < $1.id })))
                case .failure(let err):
                    handler(.failure(err))
                }
            }
        }
    }
}
