//
//  NavigationDelegate.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import Foundation
import UIKit

class NavDelegate: NSObject, UINavigationControllerDelegate {
    private let animator = Animator()

    // Return the animator for performing custom animations
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = fromVC as? VideoListViewController,
            let _ = toVC as? VideoPlayerViewController {
                return animator
        }
            
        else if let _ = fromVC as? VideoPlayerViewController,
            let _ = toVC as? VideoListViewController {
                return animator
        }
        return nil
    }
}
