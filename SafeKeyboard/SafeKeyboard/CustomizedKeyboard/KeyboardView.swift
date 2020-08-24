//
//  KeyboardView.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/4/23.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit
import SnapKit
import CYRKeyboardButton

enum SRTKeyItemType {
    case numeric
    case alpha
    case function
}

enum SRTKeyItem: String {
    case alpha1 = "1"
    case alpha2 = "2"
    case alpha3 = "3"
    case alpha4 = "4"
    case alpha5 = "5"
    case alpha6 = "6"
    case alpha7 = "7"
    case alpha8 = "8"
    case alpha9 = "9"
    case alpha0 = "0"
    case alphaQ = "q"
    case alphaW = "w"
    case alphaE = "e"
    case alphaR = "r"
    case alphaT = "t"
    case alphaY = "y"
    case alphaU = "u"
    case alphaI = "i"
    case alphaO = "o"
    case alphaP = "p"
    case alphaA = "a"
    case alphaS = "s"
    case alphaD = "d"
    case alphaF = "f"
    case alphaG = "g"
    case alphaH = "h"
    case alphaJ = "j"
    case alphaK = "k"
    case alphaL = "l"
    case alphaZ = "z"
    case alphaX = "x"
    case alphaC = "c"
    case alphaV = "v"
    case alphaB = "b"
    case alphaN = "n"
    case alphaM = "m"
    case funcShift = "shift"
    case funcSpace = "space"
    case funcBackspace = "backspace"
    
    var itemType: SRTKeyItemType {
        switch self {
        case .alpha1,
             .alpha2,
             .alpha3,
             .alpha4,
             .alpha5,
             .alpha6,
             .alpha7,
             .alpha8,
             .alpha9,
             .alpha0:
            return .numeric
        case .alphaQ,
             .alphaW,
             .alphaE,
             .alphaR,
             .alphaT,
             .alphaY,
             .alphaU,
             .alphaI,
             .alphaO,
             .alphaP,
             .alphaA,
             .alphaS,
             .alphaD,
             .alphaF,
             .alphaG,
             .alphaH,
             .alphaJ,
             .alphaK,
             .alphaL,
             .alphaZ,
             .alphaX,
             .alphaC,
             .alphaV,
             .alphaB,
             .alphaN,
             .alphaM:
            return .alpha
        case .funcShift,
             .funcSpace,
             .funcBackspace:
             return .function
        }
    }
    
    var isFunctionItem: Bool {
        return self.itemType == .function
    }
}

enum SRTFunctionKeyType: Int {
    case capsLock = 500
    case space = 501
    case backspace = 502
}

class KeyboardView: UIView {
    weak var textInput: UIView? {
        didSet {
            updateTextInput()
        }
    }
    
    @IBOutlet weak var accessoryView: UIView!
    @IBOutlet weak var inputContainer: UIView!
    
//    private var buttons: [SRTKeyboardButton] = []
    private var buttons: [CYRKeyboardButton] = []
    private var functionButtons: [UIButton] = []
    private var buttonSize = CGSize(width: 30, height: 45)
    private var fatButtonSize = CGSize(width: 50, height: 45)
    private var marginLeading: Double = 0.0
    private let marginTop: Double = 4.0
    private let buttonCountPerRow = 10
    private let buttonCountInLastRow = 8
    private let spaceBarImageSize = CGSize(width: 21, height: 12)
    
    private var spaceBarImage: UIImage {
        var ret: UIImage?
        UIGraphicsBeginImageContext(spaceBarImageSize)
        let context = UIGraphicsGetCurrentContext()
        let bezier = UIBezierPath()
        bezier.move(to: .zero)
        context?.setStrokeColor(UIColor.blue.cgColor)
        bezier.lineWidth = 3.0
        bezier.addLine(to: CGPoint(x: 0, y: spaceBarImageSize.height))
        bezier.addLine(to: CGPoint(x: spaceBarImageSize.width, y: spaceBarImageSize.height))
        bezier.addLine(to: CGPoint(x: spaceBarImageSize.width, y: 0))
        bezier.lineCapStyle = .round
        bezier.stroke()
        ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret ?? UIImage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButtons()
    }
    
    private func setupButtons() {
        reset()
        setUIParameters()
        
        createButton(for: 0)
        createButton(for: 1)
        createButton(for: 2)
        creatBottomRow()
        createFunctionButtons()
    }
    
    private func setUIParameters() {
        let screenSize = UIScreen.main.bounds.size
        marginLeading = Double(Int(screenSize.width) - Int(buttonSize.width) * buttonCountPerRow) / Double(buttonCountPerRow + 1)
    }
    
    private func reset() {
        for button in buttons {
            button.removeFromSuperview()
        }
        for functionButton in functionButtons {
            functionButton.removeFromSuperview()
        }
        
        buttons.removeAll()
        functionButtons.removeAll()
    }
    
    /*
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
            if let textInput = textInput as? UITextInput {
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
            if let textInput = textInput as? UITextInput {
                button.textInput = textInput
            }
            
            leading += Double(buttonSize.width) + marginLeading
        }
    }
 */
    
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
            
            let button: CYRKeyboardButton = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                inputContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.size.equalTo(buttonSize)
                    make.leading.equalToSuperview().offset(leading)
                    make.top.equalToSuperview().offset(startPoint.y)
                }
                buttons.append($0)
                $0.style = .tablet
                return $0
            }(CYRKeyboardButton())
            button.input = keyItems[index].rawValue
            if let textInput = textInput as? UITextInput {
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
            let button: CYRKeyboardButton = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                inputContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.size.equalTo(buttonSize)
                    make.leading.equalToSuperview().offset(leading)
                    make.top.equalToSuperview().offset(startPoint.y)
                }
                buttons.append($0)
                return $0
            }(CYRKeyboardButton())
            button.input = keyItems[index].rawValue
            if let textInput = textInput as? UITextInput {
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
        switch row {
        case 0:
            return [.alpha1, .alpha2, .alpha3, .alpha4, .alpha5, .alpha6, .alpha7, .alpha8, .alpha9, .alpha0]
        case 1:
            return [.alphaQ, .alphaW, .alphaE, .alphaR, .alphaT, .alphaY, .alphaU, .alphaI, .alphaO, .alphaP]
        case 2:
            return [.funcShift, .alphaA, .alphaS, .alphaD, .alphaF, .alphaG, .alphaH, .alphaJ, .alphaK, .alphaL]
        case 3:
            return [.funcSpace, .alphaZ, .alphaX, .alphaC, .alphaV, .alphaB, .alphaN, .alphaM, .funcBackspace]
        default:
            return []
        }
    }
    
    private func createFunctionButtons() {
        var startPoint = leftTop(for: 2)
        var leading = Double(startPoint.x)
        
        // create capslock button
        var image = #imageLiteral(resourceName: "newcapsLock")
        var button: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
            $0.setImage(image, for: .normal)
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = .lightGray
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
        image = spaceBarImage
        button = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
            $0.setImage(image, for: .normal)
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = .lightGray
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
        image = #imageLiteral(resourceName: "newdelete")
        button = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
            $0.setImage(image, for: .normal)
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = .lightGray
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
        guard let textInput = textInput as? UITextInput else { return }
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
            capsLockButton.backgroundColor = lowcase ? .darkGray : .lightGray
        }
    }
    
    private func insertSpace() {
        var shouldInsertText = false
        if let textView = textInput as? UITextView {
            let selectedRange = textView.selectedRange

            shouldInsertText = textView.delegate?.textView?(textView, shouldChangeTextIn: selectedRange, replacementText: " ") ?? true
        } else if let textField  = textInput as? UITextField {
            let selectedRange = textField.nsRangeValue

            shouldInsertText = textField.delegate?.textField?(textField, shouldChangeCharactersIn: selectedRange, replacementString: " ") ?? true
        }
        
        if shouldInsertText {
            (textInput as? UITextInput)?.insertText(" ")
        }
    }
}

extension UITextField {
    var nsRangeValue: NSRange {
        if let selectedRange: UITextRange = selectedTextRange {
            let beginning: UITextPosition = beginningOfDocument
            let selectionStart:UITextPosition = selectedRange.start
            let selectionEnd:UITextPosition = selectedRange.end
            
            let location = offset(from: beginning, to: selectionStart)
            let length = offset(from: selectionStart, to: selectionEnd)
            
            return NSMakeRange(location, length)
        } else {
            return NSRange(location: 0, length: 0)
        }
    }
}
