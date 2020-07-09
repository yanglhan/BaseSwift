//
//  EPTransitionAnimator.swift
//  EPPlay
//
//  Created by TEZWEZ on 2019/8/13.
//  Copyright © 2019 YuXiTech. All rights reserved.
//

import UIKit

class EPTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case present
        case dismiss
    }
    
    // MARK: Object Life Cycle
    var transitionType: TransitionType
    var maskView: UIView
    var contentView: UIView
    
    init(transitionType: TransitionType, maskView: UIView, contentView: UIView) {
        self.transitionType = transitionType
        self.maskView = maskView
        self.contentView = contentView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            animatePresentTransition(using: transitionContext)
        case .dismiss:
            animateDismissTransition(using: transitionContext)
        }
    }
    
    // MARK: Private Method
    private func animatePresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        let duration = self .transitionDuration(using: transitionContext)
        let maskBtnOriginalAlpha = self.maskView.alpha
        
        maskView.alpha = 0.0
        // 通知view更新布局(使autolayout值生效)
        toVC.view.layoutIfNeeded()
        self.contentView.origin = CGPoint(x: 0, y: containerView.height)
        UIView.animate(withDuration: duration, animations: {
            self.maskView.alpha = maskBtnOriginalAlpha
            self.contentView.origin = CGPoint(x: 0, y: (containerView.height - self.contentView.height))
        }) { (isFinish) in
            let isComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isComplete)
        }
    }
    
    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let _ = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        containerView.addSubview(fromVC.view)
        UIView.animate(withDuration: duration, animations: {
            self.maskView.alpha = 0.0
            self.contentView.origin = CGPoint(x: 0, y: containerView.height + self.contentView.height)
        }) { (isFinish) in
            let isComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isComplete)
        }
    }
}
