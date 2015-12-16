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
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let positions = Array(0..<16).map { Position(x: $0 % 4, y: Int(floor(Double($0) / 4.0)) ) }
        
        images = [image1, image2, image3, image4]
        
        for image in images {
            image.userInteractionEnabled = true
            
            let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
            image.addGestureRecognizer(recognizer)
        }

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

