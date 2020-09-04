//
//  Video.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/30.
//  Copyright © 2020 阿遠. All rights reserved.
//

class Video: VPModel {
    var id: String
    var title: String
    var description: String
    var image_url: String
    
    
    init(id: String, image_url: String) {
        self.id = id
        self.image_url = image_url
        self.title = ""
        self.description = ""
    }
    
    init(youtubeData: [String: Any]) {
        let idDict = VPModel.getDictionary(key: "id", data: youtubeData)
        let snippetDict = VPModel.getDictionary(key: "snippet", data: youtubeData)
        
        // image
        let thumbnails = VPModel.getDictionary(key: "thumbnails", data: snippetDict)
        let highImage = VPModel.getDictionary(key: "high", data: thumbnails)
        
        self.id = VPModel.getString(key: "videoId", data: idDict)
        self.title = VPModel.getString(key: "title", data: snippetDict)
        self.description = VPModel.getString(key: "description", data: snippetDict)
        self.image_url = VPModel.getString(key: "url", data: highImage)
    }
    
    static func createVideoByYoutubeData(youtubeData: [String: Any]) -> Video? {
        if self.isVideoFromYoutube(youtubeData: youtubeData) {
            return Video(youtubeData: youtubeData)
        }
        
        return nil
    }
    
    static func isVideoFromYoutube(youtubeData: [String: Any]) -> Bool {
        let idDict = self.getDictionary(key: "id", data: youtubeData)
        let kind = self.getString(key: "kind", data: idDict)
        return kind == "youtube#video"
    }
    
    class func convertFromArray(data: [[String: Any]]) -> [Video] {
         var videos: [Video] = []
         for dict in data {
             videos.append(self.covertFromDictionary(dict: dict))
         }
         return videos
     }
     
    class func covertFromDictionary(dict: [String: Any]) -> Video {
         let id = dict["id"] as? String ?? ""
         let image_url = dict["title"] as? String ?? ""
         
         return Video(id: id, image_url: image_url)
     }
}
