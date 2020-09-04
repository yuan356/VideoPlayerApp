//
//  ModelService.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/31.
//  Copyright © 2020 阿遠. All rights reserved.
//

import Foundation
class ModelService: HttpService {
    
    static let shared = ModelService()
    
    var route: Route?
    var videoService: VideoService?
    var playlistService: PlaylistService?
    
    func loadVideos(completionHandler: @escaping () -> Void) {
        self.videoService?.loadIndex {
            self.videoService?.loadAllData {
                completionHandler()
            }
        }
    }
    
    func loadRoutes(completionHandler: @escaping () -> Void) {
        
        if let url = URL(string: "http://127.0.0.1:5500/routes.json") {
            self.getJsonData(url: url) { (json) in
                if let jsonObj = json as? [String: Any] {
                    self.route = Route(jsonObj)
                    self.initServices()
                    completionHandler()
                }
            }
        }
    }
    
    private func initServices() {
        if let route = self.route {
            if let videoUrl = route.videoIndexUrl {
                self.videoService = VideoService(indexUrl: videoUrl )
            }
            
            if let playlistUrl = route.playlistIndexUrl  {
                self.playlistService = PlaylistService(indexUrl: playlistUrl )
            }
        }
    }
}
