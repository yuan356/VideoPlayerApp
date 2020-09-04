//
//  VPWKWebView.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/9/2.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit
import WebKit

class VPWKWebView: WKWebView {

    required init?(coder: NSCoder) {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        super.init(frame: CGRect.zero, configuration: configuration)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
