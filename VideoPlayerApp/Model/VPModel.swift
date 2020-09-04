//
//  VPModel.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/31.
//  Copyright © 2020 阿遠. All rights reserved.
//

import Foundation

class VPModel {
    
    static func getString(key: String, data: [String: Any]) -> String {
       return data[key] as? String ?? ""
    }
    
    static func getDictionary(key: String, data: [String: Any]) -> [String: Any] {
        return data[key] as? [String: Any] ?? [:]
    }
}
