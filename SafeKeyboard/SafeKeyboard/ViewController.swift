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
    @IBOutlet weak var imageView: UIImageView!
    
    private var keyboardView: SRTKeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupKeyboard()
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapBarButton(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        imageView.image = FunctionIcons.shift(color: .blue)
    }

    private func setupKeyboard() {
        guard let keyboardView: SRTKeyboardView = Bundle.main.loadNibNamed("SRTKeyboardView", owner: self, options: nil)?.first as? SRTKeyboardView else { return }

        self.keyboardView = keyboardView
        keyboardView.title = "捷信金融安全键盘"
        keyboardView.titleBackgroundColor = .white
        keyboardView.titleColor = .red
        keyboardView.textInput = pwdTextField
        pwdTextField.inputView = keyboardView
        pwdTextField.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 禁掉外接键盘的输入
        return false
    }
    
    @IBAction func tapPresentButton(_ sender: UIButton) {
        let dialog = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SomeDialog")
        dialog.modalPresentationStyle = .overCurrentContext
        present(dialog, animated: true, completion: nil)
    }
    
    @objc func tapBarButton(_ sender: UIBarButtonItem) {
        pwdTextField.resignFirstResponder()
        keyboardView.reset()
        keyboardView.title = "志哥好"
        keyboardView.titleColor = .red
        keyboardView.titleBackgroundColor = .yellow
    }
}

class AppendTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 禁掉选择、粘贴这些操作
        return false
    }
}
