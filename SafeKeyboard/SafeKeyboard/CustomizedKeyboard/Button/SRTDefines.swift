//
//  SRTDefines.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/8/24.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import Foundation

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

protocol SRTSecurityTextBox {
    func append(_ text: String)
    var plainText: String { get }
}

enum SRTButtonType {
    case normal
    case security(textBox: SRTSecurityTextBox)
}
