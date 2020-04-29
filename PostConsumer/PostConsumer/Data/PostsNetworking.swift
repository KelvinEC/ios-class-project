//
//  PostsNetworking.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

class PostsNetworking
{
    private enum Endpoints: String
    {
        case recentPosts = "posts"
        case commentsForPosts = "posts/{post_id}/comments"
    }

    private enum Parameters: String
    {
        case postId = "{post_id}"
    }

    func getRecentPosts(handler: @escaping (Result<[PostModel], NetworkErrors>) -> Void)
    {
        guard let request = Networking.shared.createRequest(operation: Endpoints.recentPosts.rawValue,
                                                            type: .get,
                                                            parameters: nil) else {
            return
        }

        Networking.shared.execute(request: request, handler: handler)
    }

    func getPostComments(postId: Int, handler: @escaping (Result<[PostCommentsModel], NetworkErrors>) -> Void)
    {
        let operation = _setupRouteParameter(route: .commentsForPosts, parameter: .postId, value: postId)
        guard let request = Networking.shared.createRequest(operation: operation, type: .get, parameters: nil) else {
            return
        }

        Networking.shared.execute(request: request, handler: handler)
    }

    private func _setupRouteParameter(route: Endpoints, parameter: Parameters, value: Int) -> String
    {
        let range = NSRange(location: 0, length: route.rawValue.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\\{(.*?)\\}")

        return regex.stringByReplacingMatches(in: route.rawValue,
                                              options: [],
                                              range: range,
                                              withTemplate: value.description)
    }
}
