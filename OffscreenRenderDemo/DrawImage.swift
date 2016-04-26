//
//  DrawMaskImage.swift
//  OffscreenRenderDemo
//
//  Created by seedante on 16/4/23.
//  Copyright © 2016年 seedante. All rights reserved.
//

import UIKit

func drawImage(image originImage: UIImage, rectSize: CGSize, roundedRadius radius: CGFloat) -> UIImage {
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: rectSize)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
    let currentContext = UIGraphicsGetCurrentContext()
    
    CGContextAddPath(currentContext,
                     UIBezierPath(roundedRect: rect,
                        byRoundingCorners: .AllCorners,
                        cornerRadii: CGSize(width: radius, height: radius)).CGPath)
    CGContextClip(currentContext)
    
    //Don't use CGContextDrawImage, coordinate system origin in UIKit and Core Graphics are vertical oppsite.
    originImage.drawInRect(rect)
    CGContextDrawPath(currentContext, .FillStroke)
    let roundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedCornerImage
}

func UIGraphicsDrawAntiRoundedCornerImageWithRadius(radius: CGFloat, outerSize: CGSize, innerSize: CGSize, fillColor: UIColor) -> UIImage{
    
    UIGraphicsBeginImageContextWithOptions(outerSize, false, UIScreen.mainScreen().scale)
    let currentContext = UIGraphicsGetCurrentContext()
    
    let bezierPath = UIBezierPath()
    
    let xOffset = (outerSize.width - innerSize.width) / 2
    let yOffset = (outerSize.height - innerSize.height) / 2
    
    let hLeftUpPoint = CGPointMake(xOffset + radius, yOffset)
    let hRightUpPoint = CGPointMake(outerSize.width - xOffset - radius, yOffset)
    let hLeftDownPoint = CGPointMake(xOffset + radius, outerSize.height - yOffset)
    
    let vLeftUpPoint = CGPointMake(xOffset, yOffset + radius)
    let vRightDownPoint = CGPointMake(outerSize.width - xOffset, outerSize.height - yOffset - radius)
    
    let centerLeftUp = CGPointMake(xOffset + radius, yOffset + radius)
    let centerRightUp = CGPointMake(outerSize.width - xOffset - radius, yOffset + radius)
    let centerLeftDown = CGPointMake(xOffset + radius, outerSize.height - yOffset - radius)
    let centerRightDown = CGPointMake(outerSize.width - xOffset - radius, outerSize.height - yOffset - radius)
    
    bezierPath.moveToPoint(hLeftUpPoint)
    bezierPath.addLineToPoint(hRightUpPoint)
    bezierPath.addArcWithCenter(centerRightUp, radius: radius, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 2), clockwise: true)
    bezierPath.addLineToPoint(vRightDownPoint)
    bezierPath.addArcWithCenter(centerRightDown, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI / 2), clockwise: true)
    bezierPath.addLineToPoint(hLeftDownPoint)
    bezierPath.addArcWithCenter(centerLeftDown, radius: radius, startAngle: CGFloat(M_PI / 2), endAngle: CGFloat(M_PI), clockwise: true)
    bezierPath.addLineToPoint(vLeftUpPoint)
    bezierPath.addArcWithCenter(centerLeftUp, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
    bezierPath.addLineToPoint(hLeftUpPoint)
    bezierPath.closePath()
    
    //There is a strange bug: if draw drection of outer path is same with inner path, final result is just outer path.
    bezierPath.moveToPoint(CGPointZero)
    bezierPath.addLineToPoint(CGPointMake(0, outerSize.height))
    bezierPath.addLineToPoint(CGPointMake(outerSize.width, outerSize.height))
    bezierPath.addLineToPoint(CGPointMake(outerSize.width, 0))
    bezierPath.addLineToPoint(CGPointZero)
    bezierPath.closePath()
    
    fillColor.setFill()
    bezierPath.fill()
    
    CGContextDrawPath(currentContext, .FillStroke)
    let antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return antiRoundedCornerImage
}

func UIGraphicsDrawAntiRoundedCornerImageWithRadius(radius: CGFloat, rectSize: CGSize, fillColor: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(rectSize, false, UIScreen.mainScreen().scale)
    let currentContext = UIGraphicsGetCurrentContext()
    
    let bezierPath = UIBezierPath()
    
    let hLeftUpPoint = CGPointMake(radius, 0)
    let hRightUpPoint = CGPointMake(rectSize.width - radius, 0)
    let hLeftDownPoint = CGPointMake(radius, rectSize.height)
    
    let vLeftUpPoint = CGPointMake(0, radius)
    let vRightDownPoint = CGPointMake(rectSize.width, rectSize.height - radius)
    
    let centerLeftUp = CGPointMake(radius, radius)
    let centerRightUp = CGPointMake(rectSize.width - radius, radius)
    let centerLeftDown = CGPointMake(radius, rectSize.height - radius)
    let centerRightDown = CGPointMake(rectSize.width - radius, rectSize.height - radius)
    
    bezierPath.moveToPoint(hLeftUpPoint)
    bezierPath.addLineToPoint(hRightUpPoint)
    bezierPath.addArcWithCenter(centerRightUp, radius: radius, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 2), clockwise: true)
    bezierPath.addLineToPoint(vRightDownPoint)
    bezierPath.addArcWithCenter(centerRightDown, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI / 2), clockwise: true)
    bezierPath.addLineToPoint(hLeftDownPoint)
    bezierPath.addArcWithCenter(centerLeftDown, radius: radius, startAngle: CGFloat(M_PI / 2), endAngle: CGFloat(M_PI), clockwise: true)
    bezierPath.addLineToPoint(vLeftUpPoint)
    bezierPath.addArcWithCenter(centerLeftUp, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
    bezierPath.addLineToPoint(hLeftUpPoint)
    bezierPath.closePath()
    
    //If draw drection of outer path is same with inner path, final result is just outer path.
    bezierPath.moveToPoint(CGPointZero)
    bezierPath.addLineToPoint(CGPointMake(0, rectSize.height))
    bezierPath.addLineToPoint(CGPointMake(rectSize.width, rectSize.height))
    bezierPath.addLineToPoint(CGPointMake(rectSize.width, 0))
    bezierPath.addLineToPoint(CGPointZero)
    bezierPath.closePath()
    
    fillColor.setFill()
    bezierPath.fill()
    
    CGContextDrawPath(currentContext, .FillStroke)
    let antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return antiRoundedCornerImage
}

