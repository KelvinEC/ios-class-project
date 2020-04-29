//
//  PostCommentsViewProtocol.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

protocol PostCommentsViewProtocol: AnyObject
{
    func showTitle(postName: String)
    
    func showComments(_ comments: [PostCommentsModel])

    func showLoading()

    func hideLoading()
}
