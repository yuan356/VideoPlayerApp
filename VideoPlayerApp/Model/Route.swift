//
//  route.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/31.
//  Copyright © 2020 阿遠. All rights reserved.
//

import Foundation

class Route {
    
    var data: [String: Any] = [:]
    
    var youtube: [String: Any]? {
        return self.data["youtube"] as? [String: Any]
    }
    
    var videos: [String: String]? {
        return self.youtube?["videos"] as? [String: String]
    }
    
    var playlists : [String: String]? {
        return self.youtube?["playlists"] as? [String: String]
    }
    
    var videoIndexUrl: URL? {
        return getUrlOrNil(url: self.videos?["index"])
    }
    
    var playlistIndexUrl: URL? {
        return getUrlOrNil(url: self.playlists?["index"])
    }
    
    var videoIndexStr: String? {
        return self.videos?["index"]
    }
    
    var playlistIndexStr: String? {
        return self.playlists?["index"]
    }
    
    private func getUrlOrNil(url: String?) -> URL? {
        if let url = url {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    
    init(_ data: [String: Any]) {
        self.data = data
    }
    
}
