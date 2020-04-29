//
//  PostCommentTableViewCell.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell
{
    // MARK: - IBoutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!

    // MARK: - UIView Methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        _setupFonts()
        _setupImage()
    }

    // MARK: - Setup Methods
    private func _setupFonts()
    {
        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        emailLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        commentBodyLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)

        commentBodyLabel.numberOfLines = 0
        commentBodyLabel.textAlignment = .justified
    }

    private func _setupImage()
    {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2

        guard let avatarImage = UIImage(named: "avatar") else {
            return
        }

        avatarImageView.image = avatarImage
    }
}
