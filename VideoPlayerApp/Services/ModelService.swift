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
        
        //if let url = URL(string: "http://127.0.0.1:5500/routes.json") {
        if let url = Bundle.main.url(forResource: "routes", withExtension: "json") {
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
            if let videoStr = route.videoIndexStr, let videoUrl = Bundle.main.url(forResource: videoStr, withExtension: "json") {
                self.videoService = VideoService(indexUrl: videoUrl)
            }
            
            if let playlistStr = route.playlistIndexStr, let playlistUrl = Bundle.main.url(forResource: playlistStr, withExtension: "json")  {
                self.playlistService = PlaylistService(indexUrl: playlistUrl )
            }
        }
    }
}
