//
//  VDCustomNavigationViewController.swift
//  VDAnimatedTransition
//
//  Created by lyb on 2016/11/15.
//  Copyright © 2016年 lyb. All rights reserved.
//

import UIKit

class VDCustomNavigationViewController: UINavigationController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置代理
        self.delegate = self
    }

    //实现代理方法判断跳转状态并返回相应动画
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        switch operation {
        case .push:
            return presentAnimator()
        case .pop:
            return dismissAnimator()
        default:
            return nil
        }
        
    }

    
    
}
