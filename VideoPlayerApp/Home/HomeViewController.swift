//
//  HomeViewController.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/27.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

enum CellSection: Int {
    case topMargin = 0
    case titleSection
    case topicSection
    case playlistSection
    
    case last
    
    static func value(_ value: CellSection) -> Int {
        return value.rawValue
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeTopicTableViewCellDelegate, PlayVideoDelegate {

    var playlists: [Playlist] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var topics: [Video] = [] {
        didSet {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: CellSection.value(.topicSection))], with: .fade)
        }
    }
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.allowsSelection = false
        
        // tableViewCell register
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(UINib(nibName: "HomeTableViewTitleCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewTitleCell")
        tableView.register(UINib(nibName: "HomeTopicTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTopicTableViewCell")
        tableView.register(UINib(nibName: "HomePlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: "HomePlaylistTableViewCell")
        
        // hide nav bar
        showNavBar(show: false, animate: false)
       
        // Get topic data
        if let url = URL(string: "http://127.0.0.1:5500/topicVideos.json") {
            ModelService.shared.getJsonData(url: url) { (json) in
                if let jsonObj = json as? [String: [String]], let topicsVideoIds = jsonObj["topics"] {
                    if let topicVideos = ModelService.shared.videoService?.getVideosById(ids: topicsVideoIds) {
                        
                        DispatchQueue.main.async {
                            self.topics = topicVideos
                        }
                                
                    }
                }
            }
        }
               
        ModelService.shared.playlistService?.loadIndex {
            ModelService.shared.playlistService?.loadAllData {
                DispatchQueue.main.async {
                    if let playlists = ModelService.shared.playlistService?.orderdPlaylist {
                        self.playlists = playlists
                    }
                }
            }
        }
    }
    
    func showNavBar(show: Bool, animate: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        
        if self.navView.alpha != alpha {
            if animate {
                UIView.animate(withDuration: 0.2) {
                    self.navView.alpha = alpha
                }
            } else {
                self.navView.alpha = alpha
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return CellSection.value(.last)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CellSection.value(.topMargin): // empty cell
            return 1
        case CellSection.value(.titleSection):
            return 1
        case CellSection.value(.topicSection):
            return 1
        case CellSection.value(.playlistSection):
            return playlists.count
        default:
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableView 滑動的位移
        if scrollView.contentOffset.y > 60 {
            showNavBar(show: true, animate: true)
        } else {
            showNavBar(show: false, animate: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CellSection.value(.topMargin) {
            return self.navView.frame.size.height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = nil
        switch indexPath.section {
        case CellSection.value(.topMargin): //  empty cell
            cell = self.tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell?.backgroundColor = .clear
        case CellSection.value(.titleSection):
            if let tmpCell = self.tableView.dequeueReusableCell(withIdentifier: "HomeTableViewTitleCell", for: indexPath) as? HomeTableViewTitleCell {
                cell = tmpCell
            }
        case CellSection.value(.topicSection):
            if let tmpCell = self.tableView.dequeueReusableCell(withIdentifier: "HomeTopicTableViewCell", for: indexPath) as? HomeTopicTableViewCell {
                tmpCell.topics = self.topics
                tmpCell.delegate = self
                cell = tmpCell
            }
        case CellSection.value(.playlistSection):
            if let tmpCell = self.tableView.dequeueReusableCell(withIdentifier: "HomePlaylistTableViewCell", for: indexPath) as? HomePlaylistTableViewCell {
                tmpCell.playlist = self.playlists[indexPath.row]
                tmpCell.delegate = self
                cell = tmpCell
            }
        default:
            break
        }
        
        return cell ?? UITableViewCell()

    }
    
    func topicSelected(_ id: String) {
        let newViewController = VideoIframeViewController(videoId: id)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func playVideo(video: Video) {
        topicSelected(video.id)
    }

}
