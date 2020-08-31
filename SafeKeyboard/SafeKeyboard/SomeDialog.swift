//
//  SomeDialog.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/8/31.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit

class SomeDialog: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
