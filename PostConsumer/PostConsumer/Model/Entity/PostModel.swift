//
//  PostModel.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

struct PostModel
{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension PostModel: Codable
{
}
