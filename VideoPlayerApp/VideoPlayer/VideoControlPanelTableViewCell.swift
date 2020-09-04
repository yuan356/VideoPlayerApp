 //
//  VideoControlPanelTableViewCell.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/9/2.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

 protocol VideoControlPanelTableViewCellDelegate: AnyObject {
    func timeChanged(_ value: TimeInterval)
    func playClicked()
 }
 
class VideoControlPanelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    weak var delegate: VideoControlPanelTableViewCellDelegate?
    
    var videoDuration: TimeInterval = 0 {
        didSet {
            self.timeSlider.maximumValue = Float(self.videoDuration)
            self.durationLabel.text = convertTimeIntervalToString(self.videoDuration)
        }
    }
    
    var currentTime: TimeInterval = 0 {
        didSet {
            self.timeSlider.value = Float(self.currentTime)
            self.currentTimeLabel.text = self.convertTimeIntervalToString(self.currentTime)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeSlider.minimumValue = 0.0
        self.timeSlider.maximumValue = 0.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func convertTimeIntervalToString(_ value: TimeInterval) -> String {
        let intValue = Int(value)
        let seconds = String(format: "%02d", intValue % 60)
        let minutes = String(format: "%02d", (intValue / 60) % 60)
        let hours = String(format: "%02d", intValue / 3600)
        
        if intValue >= 3600 {
            return "\(hours):\(minutes):\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        self.delegate?.timeChanged(TimeInterval(self.timeSlider.value))
    }
    @IBAction func backwardButtonClicked(_ sender: UIButton) {
        let value: Float = max(0.0, self.timeSlider.value - 10.0)
        self.timeSlider.value = value
        self.delegate?.timeChanged(TimeInterval(value))
    }
    @IBAction func playButtonClicked(_ sender: UIButton) {
        self.delegate?.playClicked()
    }
    @IBAction func forwardButtonClicked(_ sender: UIButton) {
        let value: Float = min(Float(self.videoDuration), self.timeSlider.value + 10.0)
        self.timeSlider.value = value
        self.delegate?.timeChanged(TimeInterval(value))
    }
 }
