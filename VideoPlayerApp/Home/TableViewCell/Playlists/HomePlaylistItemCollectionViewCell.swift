//
//  HomeCategoryItemCollectionViewCell.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/28.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

protocol PlayVideoDelegate: AnyObject {
    func playVideo(video: Video)
}

enum videoIdentifier: String {
    case video1
    case video2
    case video3
}

class HomePlaylistItemCollectionViewCell: UICollectionViewCell {

    weak var delegate: PlayVideoDelegate?
    
    var video1: Video? {
        didSet {
            guard video1 != nil else {
                video1containerView.isHidden = true
                return
            }
            video1containerView.isHidden = false
            loadVideoData(index: 0, self.video1)
        }
    }
    var video2: Video? {
        didSet {
            guard video2 != nil else {
                video2ContainerView.isHidden = true
                underline1.isHidden = true
                return
            }
            video2ContainerView.isHidden = false
            underline1.isHidden = false
            loadVideoData(index: 1, self.video2)
        }
    }
    var video3: Video? {
        didSet {
            guard video3 != nil else {
                video3ContainerView.isHidden = true
                underline2.isHidden = true
                return
            }
            video3ContainerView.isHidden = false
            underline2.isHidden = false
            loadVideoData(index: 2, self.video3)
        }
    }
    @IBOutlet weak var video1containerView: UIView!
    @IBOutlet weak var video2ContainerView: UIView!
    @IBOutlet weak var video3ContainerView: UIView!
    @IBOutlet weak var underline1: UIView!
    @IBOutlet weak var underline2: UIView!
    
    @IBOutlet var imageViewCollection: [UIImageView]!
    
    @IBOutlet var titleLabel: [UILabel]!
    
    @IBOutlet var descriptionLabel: [UILabel]!
    
    @IBOutlet var buttonViews: [UIView]! {
        didSet {
            for buttonView in buttonViews {
                buttonView.layer.cornerRadius = 12
            }
        }
    }
    
    
    func loadVideoData(index: Int, _ video: Video?) {
        titleLabel[index].text = video?.title
        descriptionLabel[index].text = video?.description
        
        let thread = Thread {
            if let imageUrl = video?.image_url, let url = URL(string: imageUrl) {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.imageViewCollection[index].image = UIImage(data: data)
                    }
                } catch {}
            }
        }
        thread.start()
    }
    
    func addButtonToFireAction(_ view: UIView, identifier: videoIdentifier) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.restorationIdentifier = identifier.rawValue
        view.addSubview(button)
        view.addConstraints([
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        ])
        
        view.bringSubviewToFront(button)
        button.addTarget(self, action: #selector(self.playVideoButtonClicked(_:)), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addButtonToFireAction(video1containerView, identifier: .video1)
        self.addButtonToFireAction(video2ContainerView, identifier: .video2)
        self.addButtonToFireAction(video3ContainerView, identifier: .video3)
    }
    
    @IBAction func playVideoButtonClicked(_ sender: UIButton) {
        if let identifier = sender.restorationIdentifier, let ident =  videoIdentifier(rawValue: identifier) {
            switch ident {
            case .video1:
                if let video = video1 {
                    self.delegate?.playVideo(video: video)
                }
            case .video2:
                if let video = video2 {
                    self.delegate?.playVideo(video: video)
                }
            case .video3:
                if let video = video3 {
                    self.delegate?.playVideo(video: video)
                }
            }
        }
    }

}
