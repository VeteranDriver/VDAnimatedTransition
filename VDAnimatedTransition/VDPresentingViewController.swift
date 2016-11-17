//
//  VDPresentingViewController.swift
//  VDAnimatedTransition
//
//  Created by lyb on 2016/11/17.
//  Copyright © 2016年 lyb. All rights reserved.
//

import UIKit

class VDPresentingViewController: UIViewController,UIViewControllerTransitioningDelegate {

    let panInteractiveTransition = VDPanInteractiveTransition()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置视图
        self.setUpUI()
        
        //把自己传递给转场动画控制器
        panInteractiveTransition.setUpPresentingVC(presentingVC: self)
        
        //设置代理
        self.transitioningDelegate = self
    }
 
    //设置视图
    func setUpUI() {
        
        view.backgroundColor = UIColor.yellow
        view.addSubview(titleLabel)
        titleLabel.center = view.center
        titleLabel.text = "向下拖拽"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
    }
    
    // 返回`提供解除转场动画`的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return interactiveDismissAnimator()
    }
    
    //返回解除转场动画控制器
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return self.panInteractiveTransition.interacting ? self.panInteractiveTransition : nil
    }
}
