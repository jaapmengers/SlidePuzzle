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
        
        
        let views: [UIView] = [view_1, view_2, view_3, view_4, view_5, view_6, view_7, view_8, view_9, view_10, view_11, view_12, view_13, view_14, view_15, view_16]
        
        super.viewDidLoad()
        
        let positions = Array(0..<16).map { Position(x: $0 % 4, y: Int(floor(Double($0) / 4.0)) ) }
        
        for (index, pos) in positions.enumerate() {
            print(index, pos)
            
            let destView = views[index]
            
            let image = UIImage(named: "\(pos.x)_\(pos.y)")
            let imageview = UIImageView(image: image)
            
            imageview.contentMode = .ScaleAspectFit
            
            destView.addSubview(imageview)
            
            let widthConstraint = NSLayoutConstraint(item: imageview, attribute: .Width, relatedBy: .Equal, toItem: destView, attribute: .Width, multiplier: 1, constant: 0)
            
            let heightConstraint = NSLayoutConstraint(item: imageview, attribute: .Height, relatedBy: .Equal, toItem: destView, attribute: .Height, multiplier: 1, constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: imageview, attribute: .Top, relatedBy: .Equal, toItem: destView, attribute: .Top , multiplier: 1, constant: 0)
            
            let leadingConstraint = NSLayoutConstraint(item: imageview, attribute: .Leading, relatedBy: .Equal, toItem: destView, attribute: .Leading, multiplier: 1, constant: 0)
            
            imageview.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, topConstraint, leadingConstraint])
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

