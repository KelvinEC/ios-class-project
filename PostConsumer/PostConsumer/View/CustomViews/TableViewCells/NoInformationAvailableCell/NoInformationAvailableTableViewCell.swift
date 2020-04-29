//
//  NoInformationAvailableTableViewCell.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

class NoInformationAvailableTableViewCell: UITableViewCell
{
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        _setupTexts()
        _setupFonts()
        _setupImages()
    }
    
    private func _setupFonts()
    {
        emptyLabel.font = UIFont.systemFont(ofSize: 15,
                                            weight: .light)
    }
    
    private func _setupTexts()
    {
        emptyLabel.text = NSLocalizedString("There's no recent posts to show", comment: "")
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
    }
    
    private func _setupImages()
    {
        guard let sadImage = UIImage(named: "sad-face") else {
            return
        }
        
        emptyImageView.image = sadImage
    }
    
}
