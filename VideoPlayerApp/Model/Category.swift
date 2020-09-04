//
//  Category.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/30.
//  Copyright © 2020 阿遠. All rights reserved.
//

class Category {
    var name: String
    var videos: [Video]
    
    init(name: String, videos: [Video]) {
        self.name = name
        self.videos = videos
    }
    
    class func convertFromArray(data: [[String: Any]]) -> [Category] {
        var categories: [Category] = []
        for dict in data {
            categories.append(self.covertFromDictionary(dict: dict))
        }
        return categories
    }
    
    class func covertFromDictionary(dict: [String: Any]) -> Category {
        let name = dict["name"] as? String ?? ""
        let _videos = dict["videos"] as? [[String: Any]] ?? []
        let videos = Video.convertFromArray(data: _videos)
        
        return Category(name: name, videos:videos)
    }
}
