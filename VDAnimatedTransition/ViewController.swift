//
//  ViewController.swift
//  VDAnimatedTransition
//
//  Created by lyb on 2016/11/15.
//  Copyright © 2016年 lyb. All rights reserved.
//

import UIKit

let ButtonWidth = 100.0
let ButtonHeight = 50.0
let MainScreen = UIScreen.main.bounds

class ViewController: UIViewController,UINavigationControllerDelegate {

    let nextVC = UIViewController()
    let topButton = UIButton()
    let bottomButton = UIButton()
    let presentingVC = VDPresentingViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }

    func setUpUI() {
        
       view.backgroundColor = UIColor.white
       nextVC.view.backgroundColor = UIColor.green
        
       view.addSubview(topButton)
       view.addSubview(bottomButton)
        
       topButton.frame = CGRect(x: (Double(MainScreen.width) - ButtonWidth) * 0.5, y: (Double(MainScreen.height) - ButtonHeight) * 0.5 - 100, width: ButtonWidth, height: ButtonHeight)
       topButton.backgroundColor = UIColor.green
       topButton.setTitle("非交互式", for: .normal)
       topButton.addTarget(self, action: #selector(ViewController.noInteractPush), for: .touchUpInside)
        
       bottomButton.frame = CGRect(x: (Double(MainScreen.width) - ButtonWidth) * 0.5, y: (Double(MainScreen.height) - ButtonHeight) * 0.5 + 100, width: ButtonWidth, height: ButtonHeight)
       bottomButton.backgroundColor = UIColor.blue
       bottomButton.setTitle("交互式", for: .normal)
       bottomButton.addTarget(self, action: #selector(ViewController.interactPush), for: .touchUpInside)
    }
    
    //跳转非交互式
    func noInteractPush(){
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //跳转交互式
    func interactPush(){
        
        self.present(presentingVC, animated: true, completion: nil)
    }
    

}

