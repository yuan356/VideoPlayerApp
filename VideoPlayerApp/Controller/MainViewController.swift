//
//  ViewController.swift
//  VideoPlayerApp
//
//  Created by 阿遠 on 2020/8/27.
//  Copyright © 2020 阿遠. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, VPtabViewControllerDelegate {

    @IBOutlet var rootView: UIView!
   
    @IBOutlet weak var tabViewContainer: UIView!
    @IBOutlet weak var tabBarView: UIView!
    
    var tabViewController = VPtabViewController(pages: [
        ViewControllerPage(name: "home", identifier: "home"),
        ViewControllerPage(name: "setting", identifier: "setting")
    ])
    var currentRootViewController: UIViewController?
    
    override func viewDidLoad() {
        
        addViewControllerToContainerView(containerView: tabBarView, controller: tabViewController)
        tabViewController.delegate = self
        
        super.viewDidLoad()
        
        addBlurEffectViewToTabViewContainer()

        switchPage(identifier: "home")
    }
    
    func addViewControllerToContainerView(containerView: UIView, controller: UIViewController) {
        if let view = controller.view {
            containerView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addConstraints([
                NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        }
    }
    
    func switchPage(identifier: String) {
        
        var controller: UIViewController?
        
        switch identifier {
        case "home":
            controller = HomeViewController()
        case "setting":
            controller = SettingViewController()
        default:
            break
        }
        
        controller?.restorationIdentifier = identifier
        
        if let controller = controller, controller.restorationIdentifier != currentRootViewController?.restorationIdentifier {
            
            // remove
            self.currentRootViewController?.removeFromParent()
            self.currentRootViewController?.view.removeFromSuperview()
            
            // add
            self.addChild(controller)
            addViewControllerToContainerView(containerView: self.rootView, controller: controller)
            self.currentRootViewController = controller
        }
    }
    
    func addBlurEffectViewToTabViewContainer() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tabViewContainer.addSubview(blurEffectView)
        self.tabViewContainer.sendSubviewToBack(blurEffectView)
    }

}

