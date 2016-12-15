//
//  ViewController.swift
//  NewFaceIt
//
//  Created by 吉安 on 26/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit
class FaceViewController: UIViewController {
    var expresssion = FacialExpression(eyes: .Open,eyeBrows: .Normal, mouth: .Grin){didSet{updateUI()}}
    private var convertMouth = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0,.Smirk:-0.5,.Neutral:0.0]
    private var convertBrow = [FacialExpression.EyeBrows.Relaxed:0.5,.Furrowed:-0.5,.Normal:0.0]
    @IBOutlet weak var faceView: FaceView!{
        didSet
        {
            updateUI()
        }
    }
    @IBAction func changeEyesTap(_ recogizer: UITapGestureRecognizer) {
        if recogizer.state == .ended {
            switch expresssion.eyes {
            case .Open:
                expresssion.eyes = .Closed
            case .Closed:
                expresssion.eyes = .Open
            case .Squinting: break
            }
        }
    }
    @IBAction func swipeUp(_ recognizer: UISwipeGestureRecognizer) {
        expresssion.mouth = expresssion.mouth.sadderMouth()
    }
    
    @IBAction func swipeDown(_ recognizer: UISwipeGestureRecognizer) {
        expresssion.mouth = expresssion.mouth.happierMouth()
    }
    @IBAction func pintchTheFace(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state{
        case .changed,.ended:
            faceView.scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    private func updateUI(){
        if faceView != nil{
            switch expresssion.eyes {
            case .Closed:
                faceView.eyeOpen=false
            case .Open:
                faceView.eyeOpen=true
            case  .Squinting:faceView.eyeOpen=false
            }
            faceView.mouthCurvature=convertMouth[expresssion.mouth] ?? 0.0
            faceView.eyeBrowTile=convertBrow[expresssion.eyeBrows] ?? 0.0
        }
    }
}




