//
//  VideoService.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/31.
//  Copyright © 2020 阿遠. All rights reserved.
//

import Foundation

class VideoService: HttpService {
    
    var indexUrl: URL
    var pages: [URL] = []
    
    var cacheVideos: [String: Video] = [:]
    var cachePages: [Int: [Video]] = [:]
    
    init(indexUrl: URL) {
        self.indexUrl = indexUrl
    }
    
    func loadIndex(completionHandler: @escaping () -> Void) {
        self.getJsonData(url: self.indexUrl) { (json) in
            if let data = json as? [String: Any], let strPages = data["pages"] as? [String] {
                self.pages = strPages.compactMap { (str) -> URL? in
                    return URL(string: str)
                }
                completionHandler()
            }
        }
    }
    
    func loadAllData(completionHandler: @escaping () -> Void) {
        for (pageIndex, pageUrl) in self.pages.enumerated() {
            
            self.getJsonData(url: pageUrl) { (json) in
                
                if let data = json as? [String: Any], let items = data["items"] as? [[String:Any]] {
                    let videos = items.compactMap { (item) -> Video? in
                        return Video.createVideoByYoutubeData(youtubeData: item)
                    }
                    self.cachePages[pageIndex] = videos
                    for video in videos {
                        self.cacheVideos[video.id] = video
                    }
                    
                    if self.pages.count == self.cachePages.count {
                        completionHandler()
                    }
                    
                }
            }
        }
    }
    
    func getVideosById(ids: [String]) -> [Video] {
        return ids.compactMap { (id) -> Video? in
            self.cacheVideos[id]
        }
    }
    
    func getVideoById(id: String) -> Video? {
        return self.cacheVideos[id]
    }
    

}
