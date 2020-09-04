//
//  PlaylistService.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/31.
//  Copyright © 2020 阿遠. All rights reserved.
//

import Foundation

class PlaylistService: HttpService {
    
    var indexUrl: URL
    var cache: [String: Playlist] = [:]
    
    var orderdPlaylist: [Playlist] = []
    
    init(indexUrl: URL) {
        self.indexUrl = indexUrl
    }
    
    func loadIndex(completionHandler: @escaping () -> Void) {
        self.getJsonData(url: self.indexUrl) { (json) in
            if let data = json as? [String: Any], let items = data["items"] as? [[String: Any]] {
                let playlists = items.compactMap { (item) -> Playlist? in
                    return Playlist.createPlaylistByYoutubeData(youtubeData: item)
                }
                
                for playlist in playlists {
                    self.cache[playlist.id] = playlist
                }
                
                self.orderdPlaylist = playlists
                completionHandler()
            }
        }
    }
    
    func loadAllData(completionHandler: @escaping () -> Void) {
        for playlist in self.cache.values {
            if let url = URL(string: "http://127.0.0.1:5500/playlists/\(playlist.id).json") {
                self.getJsonData(url: url) { (json) in
                    if let data = json as? [String: Any], let items = data["items"] as? [[String: Any]] {
                        let videos = items.compactMap { (item) -> Video? in
//                            if let content = item["contentDetails"] as? [String: Any],
//                                let id = content["videoId"] as? String {
//                                return ModelService.shared.videoService?.getVideoById(id: id)
//                            }
//                            return nil
                            if let snippet = item["snippet"] as? [String: Any],
                                let resoureceId = snippet["resourceId"] as? [String:String],
                                let id = resoureceId["videoId"] {
                                return ModelService.shared.videoService?.getVideoById(id: id)
                            }
                            return nil
                        }
                        
                        playlist.setVideos(videos: videos)
                        
                        completionHandler()
                    }
                }
            }
            
        }
     }
}
