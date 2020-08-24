//
//  SRTKeyboardButtonView.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/8/21.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit

class SRTKeyboardButtonView: UIView {
    private weak var button: SRTKeyboardButton!
    
    init(button: SRTKeyboardButton) {
        self.button = button
        var frame = UIScreen.main.bounds
        let orientation = UIApplication.shared.statusBarOrientation
        let interfaceOrientationIsLandscape = (orientation == .landscapeLeft || orientation == .landscapeRight)
        if interfaceOrientationIsLandscape {
            frame = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.width)
        }
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
