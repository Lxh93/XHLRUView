//
//  ViewController.swift
//  XHLRUView
//
//  Created by Lxh93 on 03/27/2021.
//  Copyright (c) 2021 Lxh93. All rights reserved.
//

import UIKit
import XHLRUView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let lruView = XHLRUView.init(frame: CGRect.init(x: 0, y: 100, width: view.bounds.size.width, height: 50))
//        lruView.itemBackColor = UIColor.orange
//        lruView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 100), size: CGSize.init(width: view.bounds.size.width, height: 150))
        
//        let cls: AnyClass? = NSClassFromString("XHLRUView")
//        print(cls)
//        let bundle = Bundle(for: cls!)
//        let path = bundle.path(forResource: "XHLRUView.bundle/clear@2x.png", ofType: nil)
        
//
//        let image = UIImage.init(named: "clear.png")
    
        
        view.addSubview(lruView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

