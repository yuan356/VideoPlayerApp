//
//  HomeTopicTableViewCell.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/27.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

protocol HomeTopicTableViewCellDelegate: AnyObject {
    func topicSelected(_ id: String)
}

class HomeTopicTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, HomeTopicCollectionViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeTopicTableViewCellDelegate?
    
    var topics: [Video] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // 時間點在constraint之前
    override func awakeFromNib() {
        super.awakeFromNib()
    
        initializedCollectionView()
    }
    
    func initializedCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "HomeTopicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeTopicCollectionViewCell")
        
        var width = UIScreen.main.bounds.width
        let height = self.collectionView.frame.height
        if width > height {
            width /= 2
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width-50, height: height-50)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        layout.minimumLineSpacing = 10
        self.collectionView.collectionViewLayout = layout
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopicCollectionViewCell", for: indexPath) as? HomeTopicCollectionViewCell {
            cell.delegate = self
            
            let video = self.topics[indexPath.row]
            cell.titleLabel.text = video.title
            cell.sloganLabel.text = video.description
            cell.categoryLabel.text = video.id
            cell.identifier = video.id
            
            let thread = Thread {
                if let url = URL(string: video.image_url) {
                    do {
                        let data = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            cell.coverImageView.image = UIImage(data: data)
                        }
                    } catch {
                        
                    }
                }
            }
            thread.start()
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func cellClicked(_ cell: HomeTopicCollectionViewCell) {
        if let id = cell.identifier {
            self.delegate?.topicSelected(id)
        }
    }
    
}
