//
//  IntroLoadingViewController.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/9/1.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

class IntroLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Service load data
        let modelService = ModelService.shared
        modelService.loadRoutes {
            modelService.loadVideos {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "routesLoaded", sender: nil)
                }
            }            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
