//
//  CoverViewController.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/8/21.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit

class CoverViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    private func setup() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = UIScreen.main.bounds
        view.addSubview(blurView)
        view.backgroundColor = .clear
    }
}
