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

//    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let lruView = XHLRUView.init(frame: CGRect.init(x: 0, y: 100, width: view.bounds.size.width, height: 50))

        view.addSubview(lruView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

