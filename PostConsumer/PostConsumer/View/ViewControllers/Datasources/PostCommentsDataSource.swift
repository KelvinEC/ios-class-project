//
//  PostCommentsDataSource.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation
import UIKit.UITableView

class PostCommentsDataSource: NSObject
{
    // MARK: - Private Properties
    private let commentCell = "PostCommentTableViewCell"
    private let emptyCell = "NoInformationAvailableTableViewCell"
    // MARK: - Public Properties
    var comments: [PostCommentsModel]

    init(tablewView: UITableView)
    {
        comments = []
        tablewView.register(UINib(nibName: commentCell, bundle: Bundle.main),
                            forCellReuseIdentifier: commentCell)
        tablewView.register(UINib(nibName: emptyCell, bundle: Bundle.main),
        forCellReuseIdentifier: emptyCell)
    }
}

extension PostCommentsDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return comments.count > 0 ? comments.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch comments.count > 0 {
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: commentCell,
                                                           for: indexPath) as? PostCommentTableViewCell else {
                return UITableViewCell()
            }

            let comment = comments[indexPath.row]

            cell.nameLabel.text = comment.name
            cell.emailLabel.text = comment.email
            cell.commentBodyLabel.text = comment.body
            
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

extension PostCommentsDataSource: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

