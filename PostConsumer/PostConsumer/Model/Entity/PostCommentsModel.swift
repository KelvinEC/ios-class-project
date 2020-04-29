//
//  PostComments.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

struct PostCommentsModel
{
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

extension PostCommentsModel: Codable
{
}
