//
//  HomeCategoryTableViewCell.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/27.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

class HomePlaylistTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, PlayVideoDelegate {

    var playlist: Playlist? {
        didSet {
            self.titleLabel.text = playlist?.title
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: PlayVideoDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializedCollectionView()
    }
    
    func initializedCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "HomePlaylistItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomePlaylistItemCollectionViewCell")
        
        var width = UIScreen.main.bounds.width
        let height = self.collectionView.frame.height
        if width > height + 200 {
            width /= 2
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width-30, height: height-50)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        layout.minimumLineSpacing = 15
        self.collectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let playlist = self.playlist {
            let plus = (playlist.videos.count % 3 > 0) ? 1 : 0
            return playlist.videos.count / 3 + plus
        } else {
            return 0
        }
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HomePlaylistItemCollectionViewCell", for: indexPath) as? HomePlaylistItemCollectionViewCell {
            
            let index = indexPath.row
            let baseIndex = index * 3
            
            for number in (0...2) {
                let videoIndex = baseIndex + number
                if let playlist = self.playlist, videoIndex < playlist.videos.count {
                    let video = playlist.videos[videoIndex]
                    switch number {
                    case 0:
                        cell.video1 = video
                    case 1:
                        cell.video2 = video
                    case 2:
                        cell.video3 = video
                    default:
                        break
                    }
                } else {
                  switch number {
                    case 0:
                        cell.video1 = nil
                    case 1:
                        cell.video2 = nil
                    case 2:
                        cell.video3 = nil
                    default:
                        break
                    }
                }
            
            }
            cell.delegate = self
            
            return cell
         }
         
         return UICollectionViewCell()
     }
    
    func playVideo(video: Video) {
        self.delegate?.playVideo(video: video)
    }
    
}
