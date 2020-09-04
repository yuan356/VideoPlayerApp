//
//  VPtabViewController.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/27.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

protocol VPtabViewControllerDelegate: AnyObject {
    func switchPage(identifier: String)
}

class ViewControllerPage {
    var name: String
    var identifier: String
    
    init(name: String, identifier: String) {
        self.name = name
        self.identifier = identifier
    }
}

class VPtabViewController: UIViewController {

    weak var delegate: VPtabViewControllerDelegate?
    
    var pages: [ViewControllerPage] = []
    
    init(pages: [ViewControllerPage]) {
        super.init(nibName: String(describing: VPtabViewController.self), bundle: nil)
        self.pages = pages
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.initTabButtons()
        // Do any additional setup after loading the view.
    }
    
    func initTabButtons() {
        
        // 清空subviews避免誤用第二次
        for subview in self.view.subviews {
            subview.removeConstraints(subview.constraints)
            subview.removeFromSuperview()
        }
        
        for (index, page) in self.pages.enumerated() {
            addTabButton(page: page, isLast: (index == pages.count-1))
        }
    }
    
    func addTabButton(page: ViewControllerPage, isLast: Bool ) {
        let button = UIButton()
        button.setTitle(page.name, for: .normal)
        
        button.backgroundColor = .clear
        button.restorationIdentifier = page.identifier
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(VPtabViewController.tabClicked(_:)), for: .touchUpInside)
        
        
        
        var lastView: UIView? = nil
        if self.view.subviews.count > 0 {
            lastView = self.view.subviews[self.view.subviews.count-1]
        }
        
        self.view.addSubview(button)
        
        self.view.addConstraints([
            // Top
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            // Bottom
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.view,
                               attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        if let lastButton = lastView {
            
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: lastButton, attribute: .trailing , multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: lastButton, attribute: .width , multiplier: 1, constant: 0))
            
        } else {
            // first
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        }
        
        if isLast { // last
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing , multiplier: 1, constant: 0))
        }
    }

    @IBAction func tabClicked(_ sender: UIButton) {
        if let identifier = sender.restorationIdentifier {
            self.delegate?.switchPage(identifier: identifier)
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
