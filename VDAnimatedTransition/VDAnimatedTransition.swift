//
//  VDAnimatedTransition.swift
//  VDAnimatedTransition
//
//  Created by lyb on 2016/11/15.
//  Copyright © 2016年 lyb. All rights reserved.
//

import UIKit

class VDAnimatedTransition: NSObject,UIViewControllerTransitioningDelegate
{
    /// 返回`提供展现动画`的对象
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return presentAnimator()
//    }
    
    /// 返回`提供解除转场动画`的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
       return dismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return VDPanInteractiveTransition()
    }
    
}

class presentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    ///
    /// - parameter transitionContext: 转场上下文
    ///
    /// - returns: 动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 2.0
    }
    
    /// 转场动画实现方法 － 一旦实现此函数，系统的动画方法，将由程序员负责
    ///
    /// - parameter transitionContext: 转场上下文 - 提供转场动画的所有细节
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1 获取视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2 添加到容器视图
        transitionContext.containerView.addSubview(toView)
        
        // 3 设置透明度
        toView.alpha = 0
        
        // 4 动画转场
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            //淡入
            toView.alpha = 1
        }) { _ in
            
            //返回完成状态
            transitionContext.completeTransition(true)
        }
    }
}

class dismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    ///
    /// - parameter transitionContext: 转场上下文
    ///
    /// - returns: 动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 2.0
    }
    
    /// 转场动画实现方法 － 一旦实现此函数，系统的动画方法，将由程序员负责
    ///
    /// - parameter transitionContext: 转场上下文 - 提供转场动画的所有细节
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //1 获取toView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
         //2 添加到容器视图
        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.sendSubview(toBack: toView)
        // 3 获取fromView
        let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        // 5 动画转场
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            //淡出
            fromVc.view.alpha = 0
        }) { _ in
            
            //返回完成状态
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled))
        }
    }
}

class interactiveDismissAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    //设置动画时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 2.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //获取到fromVc
        let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        //获取到toVc
        let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        //设置finalFrame
        let screenBounds = UIScreen.main.bounds
        let initFrame = transitionContext.initialFrame(for: fromVc!)
        let finalFrame = initFrame.offsetBy(dx: 0, dy: screenBounds.size.height)
        
        //添加toView到上下文中
        let containerView = transitionContext.containerView
        containerView.addSubview((toVc?.view)!)
        containerView.sendSubview(toBack: (toVc?.view)!)
        
        //开始动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations:{
            
            fromVc?.view.frame = finalFrame
            
        }) { _ in
            
            //返回完成状态
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled))
        }
    }
}

class VDPanInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    /// 需要转场的视图控制器
    var presentingVC : UIViewController?
    
    /// 是否完成
    var shouldComplete = true
    
    /// 是否正在转场
    var interacting = false
    
    /// 设置需要转场的视图控制器
    ///
    /// - Parameter presentingVC: 需要转场的视图控制器
    func setUpPresentingVC(presentingVC: UIViewController) {
        
        self.completionSpeed = 1 - self.percentComplete
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(panGesture:)))
        
        self.presentingVC = presentingVC
        
        self.presentingVC?.view.addGestureRecognizer(pan)
    }
    
    /// 拖拽手势触发方法
    ///
    /// - Parameter panGesture: 拖拽手势
    func pan(panGesture : UIPanGestureRecognizer) {
        
        //获取拖拽点
        let translation = panGesture.translation(in: panGesture.view?.superview)
        
        //判断手势状态并更新动画
        switch panGesture.state {
        case .began:
            
            self.interacting = true
            self.presentingVC?.dismiss(animated: true, completion: nil)
            break
        case .changed:
            
            let pre = translation.y / 300
            
            self.shouldComplete = pre > 0.5
            
            self.update(pre)
            
            print(translation.y / 300)
            break
        case .ended:
            
            self.interacting = false
            if (!self.shouldComplete || panGesture.state == .cancelled) {
                self.cancel()
            } else {
                self.finish()
            }
            break
        case.cancelled:
            
            self.interacting = false
            if (!self.shouldComplete) {
                self.cancel()
            } else {
                self.finish()
            }
            break
        
        default:
            break
        }
    }
}
