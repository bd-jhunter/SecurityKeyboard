//
//  FunctionIcons.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/9/1.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import Foundation

struct FunctionIcons {
    static let iconWidth = 30.0
    static let iconHeight = 45.0
    
    static func shift(color: UIColor) -> UIImage? {
        var ret: UIImage?
        let iconMarginX = 6.0
        let iconMarginY = 14.0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: iconWidth, height: iconHeight), false, 3.0)
        let path = UIBezierPath()
        let lineColor: UIColor = color
        lineColor.setStroke()
        path.lineWidth = 1.4
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: iconWidth / 2, y: iconMarginY))
        path.addLine(to: CGPoint(x: iconMarginX, y: iconMarginY + (iconWidth / 2 - iconMarginX)))
        path.move(to: CGPoint(x: iconWidth / 2, y: iconMarginY))
        path.addLine(to: CGPoint(x: iconWidth - iconMarginX, y: iconMarginY + (iconWidth / 2 - iconMarginX)))
        path.addLine(to: CGPoint(x: iconWidth - iconMarginX - 5, y: iconMarginY + (iconWidth / 2 - iconMarginX)))
        path.addLine(to: CGPoint(x: iconWidth - iconMarginX - 5, y: iconHeight - iconMarginY))
        path.addLine(to: CGPoint(x: iconMarginX + 5, y: iconHeight - iconMarginY))
        path.addLine(to: CGPoint(x: iconMarginX + 5, y: iconMarginY + (iconWidth / 2 - iconMarginX)))
        path.addLine(to: CGPoint(x: iconMarginX, y: iconMarginY + (iconWidth / 2 - iconMarginX)))
        path.stroke()
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    static func spaceBar(color: UIColor) -> UIImage? {
        let spaceBarImageSize = CGSize(width: 21, height: 12)
        var ret: UIImage?
        UIGraphicsBeginImageContext(spaceBarImageSize)
        let context = UIGraphicsGetCurrentContext()
        let bezier = UIBezierPath()
        bezier.move(to: .zero)
        context?.setStrokeColor(color.cgColor)
        bezier.lineWidth = 2.7
        bezier.addLine(to: CGPoint(x: 0, y: spaceBarImageSize.height))
        bezier.addLine(to: CGPoint(x: spaceBarImageSize.width, y: spaceBarImageSize.height))
        bezier.addLine(to: CGPoint(x: spaceBarImageSize.width, y: 0))
        bezier.lineCapStyle = .round
        bezier.stroke()
        ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    static func backspace(color: UIColor) -> UIImage? {
        var ret: UIImage?
        let iconMarginX = 4.0
        let shapeHeight = iconHeight / 3.5
        let pointStart = CGPoint(x: iconMarginX, y: iconHeight / 2)
        let boundPoints = [
            CGPoint(x: iconMarginX + shapeHeight / 2, y: (iconHeight - shapeHeight) / 2),
            CGPoint(x: iconWidth - iconMarginX, y: (iconHeight - shapeHeight) / 2),
            CGPoint(x: iconWidth - iconMarginX, y: (iconHeight + shapeHeight) / 2),
            CGPoint(x: iconMarginX + shapeHeight / 2, y: (iconHeight + shapeHeight) / 2),
            pointStart
        ]
        let crossPoints = [
            CGPoint(x: iconWidth / 2 + 2.1 - 2.5, y: iconHeight / 2 - 2.5),
            CGPoint(x: iconWidth / 2 + 2.1 + 2.5, y: iconHeight / 2 + 2.5),
            CGPoint(x: iconWidth / 2 + 2.1 - 2.5, y: iconHeight / 2 + 2.5),
            CGPoint(x: iconWidth / 2 + 2.1 + 2.5, y: iconHeight / 2 - 2.5),
        ]
        UIGraphicsBeginImageContextWithOptions(CGSize(width: iconWidth, height: iconHeight), false, 3.0)
        let path = UIBezierPath()
        let lineColor: UIColor = color
        lineColor.setStroke()
        path.lineWidth = 1.4
        path.lineCapStyle = .round
        path.move(to: pointStart)
        for point in boundPoints {
            path.addLine(to: point)
        }
        path.move(to: crossPoints[0])
        path.addLine(to: crossPoints[1])
        path.move(to: crossPoints[2])
        path.addLine(to: crossPoints[3])
        path.stroke()
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
}
