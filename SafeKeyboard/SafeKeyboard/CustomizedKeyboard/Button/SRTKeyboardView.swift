//
//  SRTKeyboardView.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/4/23.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let keysPool: [SRTKeyItem] = [
    .alpha1, .alpha2, .alpha3, .alpha4, .alpha5, .alpha6, .alpha7, .alpha8, .alpha9, .alpha0,
    .alphaQ, .alphaW, .alphaE, .alphaR, .alphaT, .alphaY, .alphaU, .alphaI, .alphaO, .alphaP,
    .alphaA, .alphaS, .alphaD, .alphaF, .alphaG, .alphaH, .alphaJ, .alphaK, .alphaL,
    .alphaZ, .alphaX, .alphaC, .alphaV, .alphaB, .alphaN, .alphaM
    ]

class SRTKeyboardView: UIView {
    // MARK: - Properties
    weak var textInput: UITextField? {
        didSet {
            updateTextInput()
        }
    }
    var textLimited: Int = 6
    var title: String? {
        get {
            return accessoryTitleLabel.text
        }
        set {
            accessoryTitleLabel.text = newValue
        }
    }
    var titleColor: UIColor? {
        get {
            return accessoryTitleLabel.textColor
        }
        set {
            accessoryTitleLabel.textColor = newValue
        }
    }
    var titleBackgroundColor: UIColor? {
        get {
            return accessoryView.backgroundColor
        }
        set {
            accessoryView.backgroundColor = newValue
        }
    }

    @IBOutlet private(set) weak var accessoryView: UIView!
    @IBOutlet private(set) weak var inputContainer: UIView!
    @IBOutlet private weak var accessoryTitleLabel: UILabel!
    
    private var buttons: [SRTKeyboardButton] = []
    private var functionButtons: [UIButton] = []
    private var buttonSize = CGSize(width: 30, height: 45)
    private var fatButtonSize = CGSize(width: 50, height: 45)
    private var marginLeading: Double = 0.0
    private let marginTop: Double = 4.0
    private let buttonCountPerRow = 10
    private let buttonCountLine1 = 10
    private let buttonCountLine2 = 10
    private let buttonCountLine3 = 9
    private let buttonCountLine4 = 7
    private let buttonCountInLastRow = 8
    private var keyScheme: [[SRTKeyItem]] = []
    
    private var textStore: String = ""
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButtons()
    }

    // MARK: - Public methods
    func reset() {
        for button in buttons {
            button.removeFromSuperview()
        }
        for functionButton in functionButtons {
            functionButton.removeFromSuperview()
        }
        
        buttons.removeAll()
        functionButtons.removeAll()
        resetKeyScheme()
        createButton(for: 0)
        createButton(for: 1)
        createButton(for: 2)
        creatBottomRow()
        createFunctionButtons()
    }

    // MARK: - Private methods
    private func setupButtons() {
        setUIParameters()
        reset()
    }
    
    private func setUIParameters() {
        let screenSize = UIScreen.main.bounds.size
        marginLeading = Double(Int(screenSize.width) - Int(buttonSize.width) * buttonCountPerRow) / Double(buttonCountPerRow + 1)
    }
    
    private func resetKeyScheme() {
        let pool = keysPool.sorted { (_, _) -> Bool in
            arc4random() < arc4random()
        }
        let line1 = Array(pool[..<buttonCountLine1])
        let line2 = Array(pool[buttonCountLine1..<(buttonCountLine1 + buttonCountLine2)])
        var line3 = Array(pool[(buttonCountLine1 + buttonCountLine2)..<(buttonCountLine1 + buttonCountLine2 + buttonCountLine3)])
        line3.insert(.funcShift, at: 0)
        var line4 = Array(pool[(buttonCountLine1 + buttonCountLine2 + buttonCountLine3)...])
        line4.insert(.funcSpace, at: 0)
        line4.append(.funcBackspace)
        keyScheme = [line1, line2, line3, line4]
    }
    
    private func createButton(for row: Int) {
        guard row < 3 else { return }
        
        let startPoint = leftTop(for: row)
        var leading = Double(startPoint.x)
        let keyItems = keys(for: row)
        for index in 0..<buttonCountPerRow {
            if index == 0, row == 2 {
                leading += Double(buttonSize.width) + marginLeading
                continue
            }
            
            let button: SRTKeyboardButton = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                inputContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.size.equalTo(buttonSize)
                    make.leading.equalToSuperview().offset(leading)
                    make.top.equalToSuperview().offset(startPoint.y)
                }
                buttons.append($0)
                return $0
            }(SRTKeyboardButton())
            button.input = keyItems[index].rawValue
            button.securityType = .security(textBox: self)
            if let textInput = textInput {
                button.textInput = textInput
            }
            
            leading += Double(buttonSize.width) + marginLeading
        }
    }
 
    private func creatBottomRow() {
        let startPoint = leftTop(for: 3)
        var leading = Double(startPoint.x) + marginLeading + Double(fatButtonSize.width)
        let keyItems = keys(for: 3)
        // First is space, last is backspace
        for index in 1..<buttonCountInLastRow {
            let button: SRTKeyboardButton = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                inputContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.size.equalTo(buttonSize)
                    make.leading.equalToSuperview().offset(leading)
                    make.top.equalToSuperview().offset(startPoint.y)
                }
                buttons.append($0)
                return $0
            }(SRTKeyboardButton())
            button.input = keyItems[index].rawValue
            button.securityType = .security(textBox: self)
            if let textInput = textInput {
                button.textInput = textInput
            }
            
            leading += Double(buttonSize.width) + marginLeading
        }
    }
 
    private func leftTop(for row: Int) -> CGPoint {
        let left = marginLeading
        let top = marginTop * Double(row + 1) + Double(buttonSize.height) * Double(row)
        return CGPoint(x: left, y: top)
    }
    
    private func keys(for row: Int) -> [SRTKeyItem] {
        guard row < keyScheme.count else { return [] }
        
        return keyScheme[row]
    }
    
    private func createFunctionButtons() {
        var startPoint = leftTop(for: 2)
        var leading = Double(startPoint.x)
        
        // create capslock button
        var image: UIImage = FunctionIcons.shift(color: .red) ?? UIImage()
        var button: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
            $0.setImage(image, for: .normal)
            $0.layer.cornerRadius = 5.0
            $0.layer.shadowColor = #colorLiteral(red: 0.5333333333, green: 0.5411764706, blue: 0.5568627451, alpha: 1).cgColor
            $0.layer.shadowOffset = CGSize(width: 0.1, height: 1.1)
            $0.layer.shadowRadius = 0
            $0.layer.shadowOpacity = 1.0
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.size.equalTo(buttonSize)
                make.leading.equalToSuperview().offset(leading)
                make.top.equalToSuperview().offset(startPoint.y)
            }
            $0.tag = SRTFunctionKeyType.capsLock.rawValue
            functionButtons.append($0)
            return $0
        }(UIButton())
        button.addTarget(self, action: #selector(tapFunctionButton(_:)), for: .touchUpInside)
        
        // create space button
        startPoint = leftTop(for: 3)
        image = FunctionIcons.spaceBar(color: .red) ?? UIImage()
        button = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
            $0.setImage(image, for: .normal)
            $0.layer.cornerRadius = 5.0
            $0.layer.shadowOffset = CGSize(width: 0.1, height: 1.1)
            $0.layer.shadowColor = #colorLiteral(red: 0.5333333333, green: 0.5411764706, blue: 0.5568627451, alpha: 1).cgColor
            $0.layer.shadowRadius = 0
            $0.layer.shadowOpacity = 1.0
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.size.equalTo(fatButtonSize)
                make.leading.equalToSuperview().offset(leading)
                make.top.equalToSuperview().offset(startPoint.y)
            }
            $0.tag = SRTFunctionKeyType.space.rawValue
            functionButtons.append($0)
            return $0
        }(UIButton())
        button.addTarget(self, action: #selector(tapFunctionButton(_:)), for: .touchUpInside)

        leading = Double(startPoint.x) + (Double(fatButtonSize.width) + marginLeading) + (Double(buttonSize.width) + marginLeading) * Double(7)
        
        // create backspace button
        image = FunctionIcons.backspace(color: .red) ?? UIImage()
        button = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
            $0.setImage(image, for: .normal)
            $0.layer.cornerRadius = 5.0
            $0.layer.shadowOffset = CGSize(width: 0.1, height: 1.1)
            $0.layer.shadowColor = #colorLiteral(red: 0.5333333333, green: 0.5411764706, blue: 0.5568627451, alpha: 1).cgColor
            $0.layer.shadowRadius = 0
            $0.layer.shadowOpacity = 1.0
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.size.equalTo(fatButtonSize)
                make.leading.equalToSuperview().offset(leading)
                make.top.equalToSuperview().offset(startPoint.y)
            }
            $0.tag = SRTFunctionKeyType.backspace.rawValue
            functionButtons.append($0)
            return $0
        }(UIButton())
        button.addTarget(self, action: #selector(tapFunctionButton(_:)), for: .touchUpInside)
    }
    
    private func updateTextInput() {
        guard let textInput = textInput else { return }
        for button in buttons {
            button.textInput = textInput
        }
    }
    
    @objc private func tapFunctionButton(_ sender: UIButton) {
        switch sender.tag {
        case SRTFunctionKeyType.capsLock.rawValue:
            overturnKeys()
        case SRTFunctionKeyType.backspace.rawValue:
            print("ZZZ, tap backspace")
            insertBackspace()
        case SRTFunctionKeyType.space.rawValue:
            insertSpace()
        default:
            break
        }
    }
    
    private func overturnKeys() {
        var lowcase = true
        for button in buttons {
            if let keyItem = SRTKeyItem(rawValue: button.input.lowercased()) {
                if case SRTKeyItemType.alpha = keyItem.itemType {
                    if button.input.uppercased() == button.input {
                        lowcase = false
                        button.input = button.input.lowercased()
                    } else {
                        button.input = button.input.uppercased()
                    }
                }
            }
        }
        
        if let capsLockButton = functionButtons.first(where: { $0.tag == SRTFunctionKeyType.capsLock.rawValue }) {
            capsLockButton.backgroundColor = lowcase ? .lightGray : .white
        }
    }
    
    private func insertSpace() {
        guard let textField  = textInput else { return }

        let currentText: String = textField.text ?? ""
        let shouldInsertText = currentText.count < textLimited

        if shouldInsertText {
            let textBox: SRTSecurityTextBox = self
            // in security mode, only support append, insert and replace is denied
            textField.text = "\(textField.text ?? "")*"
            textBox.append(" ")
        }
    }
    
    private func insertBackspace() {
        guard let textField  = textInput, let text = textField.text, !text.isEmpty else { return }
        
        let newString = String(text[..<text.index(before: text.endIndex)])
        textField.text = newString
        removeLast()
    }
}

extension UITextField {
    var nsRangeValue: NSRange {
        let location = text?.count ?? 0
        return NSRange(location: location, length: 0)
    }
}

extension SRTKeyboardView: SRTSecurityTextBox {
    func append(_ text: String) {
        textStore += text
        print("ZZZZZ: \(textStore)")
    }
    
    var plainText: String {
        return textStore
    }
    
    private func removeLast() {
        let newString = String(textStore[..<textStore.index(before: textStore.endIndex)])
        textStore = newString
        print("ZZZZZ: \(textStore)")
    }
}
