//
//  RecentPostsDataSource.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation
import UIKit.UITableView
import UIKit.UITableViewCell

class RecentPostsDataSource: NSObject
{
    // MARK: - Private Properties
    private let recentPostsCell = "RecentPostTableViewCell"
    private let emptyCell = "NoInformationAvailableTableViewCell"
    // MARK: - Public Properties
    var posts: [PostModel]

    init(tablewView: UITableView)
    {
        posts = []
        tablewView.register(UINib(nibName: recentPostsCell, bundle: Bundle.main),
                            forCellReuseIdentifier: recentPostsCell)
        tablewView.register(UINib(nibName: emptyCell, bundle: Bundle.main),
        forCellReuseIdentifier: emptyCell)
    }
}

extension RecentPostsDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count > 0 ? posts.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch posts.count > 0 {
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: recentPostsCell,
                                                           for: indexPath) as? RecentPostTableViewCell else {
                return UITableViewCell()
            }

            let post = posts[indexPath.row]

            cell.postTitleLabel.text = post.title
            cell.postBodyLabel.text = post.body

            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: emptyCell,
                                                           for: indexPath) as? NoInformationAvailableTableViewCell else {
                return UITableViewCell()
            }

            return cell
        }
    }
}

extension RecentPostsDataSource: UITableViewDelegate
{
    
}
