//
//  PresentRecViewAnimator.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/17/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit

class PresentRecViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.33
    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //1) setup the transition
        let containerView = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        //2) create animation
        let finalFrame = toView.frame
        
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        toView.transform = scaleTransform
        toView.center = CGPoint(
            x: CGRectGetMidX(originFrame),
            y: CGRectGetMidY(originFrame)
        )
        toView.clipsToBounds = true
        
        containerView.addSubview(toView)
        
        UIView.animateWithDuration(duration, delay: 0.0,
            options: [UIViewAnimationOptions.CurveEaseOut], animations: {
                
                toView.transform = CGAffineTransformIdentity
                toView.center = CGPoint(
                    x: CGRectGetMidX(finalFrame),
                    y: CGRectGetMidY(finalFrame)
                )
                
            }, completion: {_ in
                
                //3 complete the transition
                transitionContext.completeTransition(
                    !transitionContext.transitionWasCancelled()
                )
        })
        
    }
    
}
