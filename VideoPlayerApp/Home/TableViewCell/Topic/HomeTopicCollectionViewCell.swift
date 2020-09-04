//
//  HomeTopicCollectionViewCell.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/28.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

protocol HomeTopicCollectionViewCellDelegate: AnyObject {
    func cellClicked(_ cell: HomeTopicCollectionViewCell)
}

class HomeTopicCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: HomeTopicCollectionViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView! {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
            coverImageView.layer.cornerRadius = 8.0
        }
    }
    
    var identifier: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func cellButtonClicked(_ sender: UIButton) {
        delegate?.cellClicked(self)
    }
    
}
