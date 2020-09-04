//
//  Playlist.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/9/1.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

class Playlist: VPModel {
    
    var id: String
    var title: String
    var description: String
    var image_url: String
    
    private var _videos: [Video] = []
    var videos: [Video] {
        return _videos 
    }
    
    init(youtubeData: [String: Any]) {
        let idDict = VPModel.getDictionary(key: "id", data: youtubeData)
        let snippetDict = VPModel.getDictionary(key: "snippet", data: youtubeData)
        
        // image
        let thumbnails = VPModel.getDictionary(key: "thumbnails", data: snippetDict)
        let highImage = VPModel.getDictionary(key: "high", data: thumbnails)
        
        self.id = VPModel.getString(key: "playlistId", data: idDict)
        self.title = VPModel.getString(key: "title", data: snippetDict)
        self.description = VPModel.getString(key: "description", data: snippetDict)
        self.image_url = VPModel.getString(key: "url", data: highImage)
    }
    
    static func createPlaylistByYoutubeData(youtubeData: [String: Any]) -> Playlist? {
        if self.isPlaylistFromYoutube(youtubeData: youtubeData) {
            return Playlist(youtubeData: youtubeData)
        }
        
        return nil
    }
    
    static func isPlaylistFromYoutube(youtubeData: [String: Any]) -> Bool {
        let idDict = self.getDictionary(key: "id", data: youtubeData)
        let kind = self.getString(key: "kind", data: idDict)
        return kind == "youtube#playlist"
    }
    
    func setVideos(videos: [Video]) {
        self._videos = videos 
    }
}
