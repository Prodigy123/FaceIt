//
//  FaceView.swift
//  NewFaceIt
//
//  Created by 吉安 on 26/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit
@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale:CGFloat = 0.9{didSet{setNeedsDisplay()}}
    @IBInspectable
    var lineWidth:CGFloat = 5.0{didSet{setNeedsDisplay()}}
    @IBInspectable
    var color:UIColor = UIColor.blue{didSet{setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature:Double = 1.0{didSet{setNeedsDisplay()}}
    @IBInspectable
    var eyeOpen: Bool = true{didSet{setNeedsDisplay()}}
    @IBInspectable
    var eyeBrowTile: Double = 0.5{didSet{setNeedsDisplay()}}
    var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height)/2*scale
    }
    var skullCenter: CGPoint{
        return CGPoint(x:bounds.midX, y:bounds.midY)
    }
    enum Eye{
        case Left
        case Right
    }
    private struct Ratios{
        static let SkullRatiusToEyeOffset: CGFloat = 3
        static let SkullRatiusToEyeRadius: CGFloat = 10
        static let SkullRatiusToMouthWidth: CGFloat = 1
        static let SkullRatiusToMouthHeight: CGFloat = 3
        static let SkullRatiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    private func getEyeCenter(eye: Eye)->CGPoint{
        let eyeOffset = skullRadius/Ratios.SkullRatiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye{
        case.Left: eyeCenter.x -= eyeOffset
        case.Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    private func pathForEyes(eye: Eye)->UIBezierPath{
        let eyeRatius = skullRadius/Ratios.SkullRatiusToEyeRadius
        let eyeCenter = getEyeCenter(eye:eye)
        if eyeOpen{
            return pathForTheCircle(radius: eyeRatius, center: eyeCenter)
        }else{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x-eyeRatius,y:eyeCenter.y))
            path.addLine(to: CGPoint(x:eyeCenter.x+eyeRatius,y:eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    private func pathForTheCircle(radius: CGFloat, center:CGPoint)->UIBezierPath{
        let  path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    private func pathForMouth()->UIBezierPath{
        let mouthWidth = skullRadius/Ratios.SkullRatiusToMouthWidth
        let mouthHeight = skullRadius/Ratios.SkullRatiusToMouthHeight
        let mouthOffset = skullRadius/Ratios.SkullRatiusToEyeOffset
        let mouthRect = CGRect(x: skullCenter.x-mouthWidth/2, y: skullCenter.y+mouthOffset, width: mouthWidth, height: mouthHeight)
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1)))*mouthRect.height
        let start = CGPoint(x:mouthRect.minX, y:mouthRect.minY)
        let end = CGPoint(x:mouthRect.maxX, y:mouthRect.minY)
        let cp1 = CGPoint(x:mouthRect.minX+mouthRect.width/3, y:mouthRect.minY+smileOffset)
        let cp2 = CGPoint(x:mouthRect.maxX-mouthRect.width/3, y:mouthRect.minY+smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    private func pathForBrow(eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTile
        switch eye  {
        case .Left: tilt *= -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRatiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    override func draw(_ rect: CGRect) {
        color.set()
        pathForTheCircle(radius: skullRadius, center: skullCenter).stroke()
        pathForEyes(eye: .Left).stroke()
        pathForEyes(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
}
