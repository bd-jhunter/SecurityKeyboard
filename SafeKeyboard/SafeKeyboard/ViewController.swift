//
//  ViewController.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/4/23.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pwdTextField: AppendTextField!
    
    private var keyboardView: SRTKeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupKeyboard()
    }

    private func setupKeyboard() {
        guard let keyboardView: SRTKeyboardView = Bundle.main.loadNibNamed("SRTKeyboardView", owner: self, options: nil)?.first as? SRTKeyboardView else { return }

        self.keyboardView = keyboardView
        keyboardView.textInput = pwdTextField
        keyboardView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 260)
        pwdTextField.inputView = keyboardView.inputContainer
        pwdTextField.inputAccessoryView = keyboardView.accessoryView
        pwdTextField.isSelected = false
        pwdTextField.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

class AppendTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
