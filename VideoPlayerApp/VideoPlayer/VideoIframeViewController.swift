//
//  VideoIframeViewController.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/9/2.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit
import WebKit

enum videoState: String {
    case stop = "0"
    case playing = "1"
    case pause = "2"
    case buffuring = "3"
}

class VideoIframeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoControlPanelTableViewCellDelegate, WKNavigationDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    
    var videoDuration: TimeInterval = 0
     
    var videoId: String
    
    var videoUrl: URL? {
        return URL(string: "https://www.youtube.com/embed/\(self.videoId)")
    }
    
    
    var isPlaying: Bool {
        return (self.videoStatus == .playing || self.videoStatus == .buffuring)
    }

    var videoStatus: videoState = .stop {
        didSet {
            switch videoStatus {
            case .stop:
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? VideoControlPanelTableViewCell {
                    cell.playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
                }
                closeButtonHideOrShow(hide: false)
            case .playing:
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? VideoControlPanelTableViewCell {
                    cell.playButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
                }
                closeButtonHideOrShow(hide: true)
            case .pause:
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? VideoControlPanelTableViewCell {
                    cell.playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
                }
                closeButtonHideOrShow(hide: false)
            case .buffuring:
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? VideoControlPanelTableViewCell {
                    cell.playButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
                }
                closeButtonHideOrShow(hide: true)
            }
        }
    }
    
    init(videoId: String) {
        self.videoId = videoId
        super.init(nibName: "VideoIframeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "VideoControlPanelTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoControlPanelTableViewCell")
        
        self.webView.navigationDelegate = self
        
        if let url = Bundle.main.url(forResource: "YT", withExtension: "html") {
            do {

                let settings: [String: Any] = [
                    "videoId": self.videoId,
                    "events": [
                        "onReady": "onReady",
                        "onStateChange": "onStateChange",
                        "onPlaybackQualityChange": "onPlaybackQualityChange",
                        "onError": "onPlayerError"
                    ],  
                    "playerVars": [
                        "controls": 0,
                        "playsinline": 1
                    ]
                ]

                // json data
                let jsonSettings = try JSONSerialization.data(withJSONObject: settings, options: .prettyPrinted)
                // json data to String
                if let strSettings = String(data: jsonSettings, encoding: .utf8) {
                    var str = try String(contentsOf: url)
                    str = str.replacingOccurrences(of: "%@", with: strSettings)
                    self.webView.loadHTMLString(str, baseURL: nil)
                }
            } catch {

            }
        }
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    
    func closeButtonHideOrShow(hide: Bool) {
        let alphaValue: CGFloat = hide ? 0 : 1
        UIView.animate(withDuration: 0.2) {
            self.closeButton.alpha = alphaValue
        }
    }
    
    // MARK: Tableview resources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "VideoControlPanelTableViewCell", for: indexPath) as? VideoControlPanelTableViewCell {
            cell.delegate = self
            cell.videoDuration = self.videoDuration
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: Controlpanel action
    func timeChanged(_ value: TimeInterval) {
        self.seekTo(value)
    }
    
    func playClicked() {
        if self.isPlaying {
            self.pauseVideo()
        } else {
            self.playVideo()
        }
    }
    
    func playVideo() {
        self.webView.evaluateJavaScript("player.playVideo();", completionHandler: nil)
    }
    
    func pauseVideo() {
        self.webView.evaluateJavaScript("player.pauseVideo();", completionHandler: nil)
    }
    
    func seekTo(_ value: TimeInterval) {
        self.webView.evaluateJavaScript("player.seekTo(\(value), true);", completionHandler: nil)
    }
    
    // MARK: Webview Status
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if let host = url.host, host == "about:blank" {
                decisionHandler(.allow)
                return
            }
            
            if let scheme = url.scheme {
                if scheme == "ytplayer" {
                    self.updateYtStatus(url: url)
                    decisionHandler(.cancel)
                    return
                } else if (scheme == "https" || scheme == "http") {
                    if let host = url.host, host == "www.youtube.com" {
                        decisionHandler(.allow)
                        return
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        decisionHandler(.allow)
        return
    }
    
    // 讀取url後參數
    func getQueryItems(url: URL) -> [String: Any] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return [:]
        }
        
        return queryItems.reduce(into: [:]) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    func getDuration(completionHandler: @escaping (_ duration: TimeInterval?) -> Void) {
        self.webView.evaluateJavaScript("player.getDuration();") { (data, error) in
            if let value = data as? Int {
                completionHandler(TimeInterval(value))
            } else {
                completionHandler(nil)
            }
            
        }
    }
    
    func updateYtStatus(url: URL) {
        print(url)
        if let host = url.host {
            switch host {
            case "onYouTubeIframeAPIReady":
                // init
                break
            case "onYouTubeIframeAPIFailedToLoad":
                // error
                break
            case "onPlayTime":
                let queryItems = self.getQueryItems(url: url)
                if let data = queryItems["data"] as? String, let currentTime = Double(data) {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? VideoControlPanelTableViewCell {
                        cell.currentTime = currentTime
                    }
                }
                break
            case "onReady":
                // get video init data
                self.getDuration { (duration) in
                    guard duration != nil else {
                        return
                    }
                    self.videoDuration = duration!
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                break
            case "onStateChange":
                let queryItems = self.getQueryItems(url: url)
                if let data = queryItems["data"] as? String, let videoState = videoState(rawValue: data) {
                    self.videoStatus = videoState
                }
                break
            case "onPlaybackQualityChange":
                
                break
            case "onError":
                break
            default:
                break
            }
        }
    }
}
