//
//  ViewController.swift
//  SlidePuzzle
//
//  Created by Jaap Mengers on 14/12/15.
//  Copyright © 2015 Jaap Mengers. All rights reserved.
//

import UIKit

struct Position {
    let x: Int
    let y: Int
}

class ViewController: UIViewController {
    
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var view_2: UIView!
    @IBOutlet weak var view_3: UIView!
    @IBOutlet weak var view_4: UIView!
    @IBOutlet weak var view_5: UIView!
    @IBOutlet weak var view_6: UIView!
    @IBOutlet weak var view_7: UIView!
    @IBOutlet weak var view_8: UIView!
    @IBOutlet weak var view_9: UIView!
    @IBOutlet weak var view_10: UIView!
    @IBOutlet weak var view_11: UIView!
    @IBOutlet weak var view_12: UIView!
    @IBOutlet weak var view_13: UIView!
    @IBOutlet weak var view_14: UIView!
    @IBOutlet weak var view_15: UIView!
    @IBOutlet weak var view_16: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let positions = Array(0..<16).map { Position(x: $0 % 4, y: Int(floor(Double($0) / 4.0)) ) }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view{
            view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }


}

