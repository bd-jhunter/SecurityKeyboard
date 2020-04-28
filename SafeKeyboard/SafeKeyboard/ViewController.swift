//
//  ViewController.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/4/23.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit
import CYRKeyboardButton

class ViewController: UIViewController {
    @IBOutlet weak var pwdTextField: UITextField!
    
    private var keyboardView: KeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupKeyboard()
    }

    private func setupKeyboard() {
        guard let keyboardView: KeyboardView = Bundle.main.loadNibNamed("KeyboardView", owner: self, options: nil)?.first as? KeyboardView else { return }

        self.keyboardView = keyboardView
        keyboardView.textInput = pwdTextField
        keyboardView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 260)
        pwdTextField.inputView = keyboardView.inputContainer
        pwdTextField.inputAccessoryView = keyboardView.accessoryView
    }
}

