//
//  RecentPostTableViewCell.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

class RecentPostTableViewCell: UITableViewCell
{
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        _setupFonts()
        _setupColors()
        _setupLabelsConfigurations()
    }
    
    private func _setupLabelsConfigurations()
    {
        postTitleLabel.numberOfLines = 1
        postBodyLabel.numberOfLines = 0
        
        postBodyLabel.lineBreakMode = .byWordWrapping
    }
    
    private func _setupFonts()
    {
        postTitleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .light)
        postBodyLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
    }
    
    private func _setupColors()
    {
        postTitleLabel.textColor = UIColor.black
        postBodyLabel.textColor = UIColor.black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
