//
//  HttpService.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/9/1.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

class HttpService {
    
    func getJsonData(url: URL, completionHandler: @escaping (_ json: Any) -> Void) {
        //var semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: url,timeoutInterval: 2)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler(json)
                } catch {
                    
                }
            }
        }

        task.resume()
    }
}
