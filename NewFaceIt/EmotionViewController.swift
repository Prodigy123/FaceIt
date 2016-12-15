//
//  EmotionViewController.swift
//  NewFaceIt
//
//  Created by 吉安 on 26/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {
    private let emotionalFaces: Dictionary<String,FacialExpression> = [
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let nextvc = segue.destination as? UINavigationController{
             destinationvc = nextvc.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    facevc.expresssion = expression
                    if let button = sender as? UIButton{
                       facevc.navigationItem.title = button.currentTitle
                    }
                }
            }
        }
    }
}
