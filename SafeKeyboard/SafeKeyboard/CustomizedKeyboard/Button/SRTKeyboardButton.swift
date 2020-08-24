//
//  SRTKeyboardButton.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/4/28.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit

class SRTKeyboardButton: UIControl {
    // MARK: - Properties
    private(set) var position: SRTKeyboardButtonPosition = .inner
    var input: String = "" {
        didSet {
            inputLabel?.text = input
        }
    }
    var font: UIFont = UIFont.systemFont(ofSize: 22.0) {
        didSet {
            inputLabel?.font = font
        }
    }
    var keyColor: UIColor = .white
    var keyTextColor: UIColor = .black {
        didSet {
            inputLabel?.textColor = keyTextColor
        }
    }
    var keyShadowColor: UIColor = #colorLiteral(red: 0.5333333333, green: 0.5411764706, blue: 0.5568627451, alpha: 1)
    var keyHighlightedColor: UIColor = #colorLiteral(red: 0.8352941176, green: 0.8392156863, blue: 0.8470588235, alpha: 1)
    weak var textInput: UITextInput?

    // MARK: - UI elements
    private weak var inputLabel: UILabel?
    private var keyCornerRadius: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateButtonPosition()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
        updateButtonPosition()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let color = state == .highlighted ? keyHighlightedColor : keyColor
        if state == .highlighted {
            print("ZZZZZZZ")
        }
        let shadowColor = keyShadowColor
        let shadowOffset = CGSize(width: 0.1, height: 1.1)
        let shadowBlurRadius: CGFloat = 0
        
        let roundedRectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 1), cornerRadius: keyCornerRadius)
        context?.saveGState()
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadowColor.cgColor)
        color.setFill()
        roundedRectanglePath.fill()
        context?.restoreGState()
    }
    
    // MARK: - Touch actions
    @objc private func handleTouchDown() {
        UIDevice.current.playInputClick()
    }

    @objc private func handleTouchUpInside() {
        insertText(input)
    }
    
    // MARK: - Private methods
    private func commonInit() {
        backgroundColor = .clear
        clipsToBounds = false
        layer.masksToBounds = false
        contentHorizontalAlignment = .center;
        
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)

        let inputLabel = UILabel(frame: frame)
        inputLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        inputLabel.textAlignment = .center
        inputLabel.backgroundColor = .clear
        inputLabel.isUserInteractionEnabled = false
        inputLabel.textColor = keyTextColor
        inputLabel.font = font
        
        addSubview(inputLabel)
        self.inputLabel = inputLabel;
    }

    private func updateDisplayStyle() {
        setNeedsDisplay()
    }
    
    private func updateButtonPosition() {
        
    }
    
    private func showInputView() {
        setNeedsDisplay()
    }
    
    private func insertText(_ text: String) {
        guard let textInput = textInput else { return }
        var shouldInsertText = true
        
        if let textView = textInput as? UITextView {
            // Call UITextViewDelegate methods if necessary
            let selectedRange = textView.selectedRange
            
            shouldInsertText = textView.delegate?.textView?(textView, shouldChangeTextIn: selectedRange, replacementText: text) ?? true
        } else if let textField = textInput as? UITextField {
            // Call UITextFieldDelgate methods if necessary
            let selectedRange = textInputSelectedRange
            
            shouldInsertText = textField.delegate?.textField?(textField, shouldChangeCharactersIn: selectedRange, replacementString: text) ?? true
        }
        
        if shouldInsertText {
            textInput.insertText(text)
        }
    }
    
    private var textInputSelectedRange: NSRange {
        guard let textInput = textInput, let selectedRange = textInput.selectedTextRange else { return NSRange(location: 0, length: 0) }

        let beginning = textInput.beginningOfDocument
        
        let selectionStart = selectedRange.start
        let selectionEnd = selectedRange.end
        
        let location = textInput.offset(from: beginning, to: selectionStart)
        let length = textInput.offset(from: selectionStart, to: selectionEnd)
        
        return NSRange(location: location, length: length)
    }
    
}

//// MARK: - UIGestureRecognizerDelegate
//extension SRTKeyboardButton {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        // Only allow simulateous recognition with our internal recognizers
//        return (gestureRecognizer == panGestureRecognizer || gestureRecognizer == optionsViewRecognizer) &&
//        (otherGestureRecognizer == panGestureRecognizer || otherGestureRecognizer == optionsViewRecognizer);
//    }
//}
