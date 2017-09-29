//
//  Animator.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import Foundation
import UIKit

// The class where animations are defined
class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    private var selectedCellFrame: CGRect? = nil // To store the selected cell position in the screen
    private var originalCollectionViewY: CGFloat? = nil // To store the collectionview y position in the screen
    
    // duration of transition
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animationDuration = transitionDuration(using: transitionContext)

        // Push animation
        if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? VideoListViewController,
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as?
            VideoPlayerViewController {
            
            var selectedCell:VideoCollectionCell?
            var openingFrame = CGRect.zero
            
            // Get the index of the selected item and its corresponding cell frame
            if let indexPath = fromViewController.collectionView.indexPathsForSelectedItems {
                let attributes = fromViewController.collectionView.layoutAttributesForItem(at: indexPath[0])
                let attributesFrame = attributes?.frame
                openingFrame = fromViewController.collectionView.convert(attributesFrame!, to: fromViewController.collectionView.superview)
                selectedCell = fromViewController.collectionView.cellForItem(at: indexPath[0]) as? VideoCollectionCell
                selectedCellFrame = selectedCell?.frame
            }
            
            // Save the collection view y position
            originalCollectionViewY = fromViewController.collectionView.frame.origin.y

            let containerView = transitionContext.containerView
            containerView.addSubview(toViewController.view)
            
            // Create a temporary thumbnail image view for animation
            let imageView = createTransitionImageViewWith(frame: openingFrame)
            imageView.image = selectedCell?.thumbnailImg?.image
            imageView.alpha = 0.0
            toViewController.view.addSubview(imageView)
        
            // Animate thumbnail view frame and alpha simultaneously
            UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: Constants.initialSpringDamping, initialSpringVelocity: Constants.initialSpringVelocity, options: .curveEaseIn, animations: {() -> Void in
                imageView.frame = CGRect(x: 0.0, y: toViewController.videoPlayerView.frame.origin.x, width: toViewController.view.frame.width, height: toViewController.view.frame.size.height)
                imageView.alpha = 1.0
                toViewController.view.alpha = 1.0
                
            }) { (finished) -> Void in
                toViewController.view.alpha = 1.0
                //Remove the temporary view
                imageView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
        //Pop animation
        else if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? VideoPlayerViewController,
                let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as?
                VideoListViewController
        {
            transitionContext.containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 1.0
            
            // Save the current snapshot in an image
            UIGraphicsBeginImageContext(fromViewController.videoPlayerView.frame.size)
            let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // Create a temporary view to show while the animation is running
            let imageView = createTransitionImageViewWith(frame: fromViewController.videoPlayerView.frame)
            imageView.image = snapshotImage
            toViewController.view.addSubview(imageView)
            
            // Animate temporary view alpha and frame
            UIView.animate(withDuration: animationDuration, animations: {
                fromViewController.view.alpha = 0.0
                toViewController.view.alpha = 1.0
                imageView.alpha = 0.0
                toViewController.collectionView.frame.origin.y = self.originalCollectionViewY ?? toViewController.collectionView.frame.origin.y
                imageView.frame = self.selectedCellFrame ?? imageView.frame
            }, completion: { (finished) in
                // Remove the temporary view
                imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    // create a temporary snapshot image view which is to be shown during animation
    private func createTransitionImageViewWith(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
