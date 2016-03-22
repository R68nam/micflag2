//
//  PresentImgSelectViewAnimator.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/21/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit

class PresentImgSelectViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.5
    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        containerView?.insertSubview(toView, belowSubview: fromView)
        
        let fromViewFrame = fromView.frame
        
        let xScaleFactor = originFrame.width / fromViewFrame.width
        let yScaleFactor = originFrame.height / fromViewFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                fromView.transform = scaleTransform
                fromView.center = CGPoint(
                    x: CGRectGetMidX(self.originFrame),
                    y: CGRectGetMidY(self.originFrame)
                )
            }, completion: {_ in
                transitionContext.completeTransition(
                    !transitionContext.transitionWasCancelled()
                )
        })
        
    }
    
}
