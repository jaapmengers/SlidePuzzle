//
//  ViewController.swift
//  SlidePuzzle
//
//  Created by Jaap Mengers on 14/12/15.
//  Copyright © 2015 Jaap Mengers. All rights reserved.
//

import UIKit

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
    let view: UIView
    
    var hashValue: Int {
        return Int("\(x)\(y)")!
    }
}

func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct Tile {
    let number: Int
    let view: UIView
}

struct State {
    var moveableTiles = [(Tile, Position, Direction)]()
    var board = Board()
}

enum Direction {
    case Up
    case Down
    case Left
    case Right
}

typealias Board = [(position: Position, tile: Tile?)]

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
    @IBOutlet weak var container: UIView!
    
    let neighbours = [
        [4, 1],
        [5, 0, 2],
        [6, 1, 3],
        [7, 2],
        [0, 8, 5],
        [1, 9, 4, 6],
        [2, 10, 5, 7],
        [3, 11, 6],
        [4, 12, 9],
        [5, 13, 8, 10],
        [6, 14, 9, 11],
        [7, 15, 10],
        [8, 13],
        [9, 12, 14],
        [10, 13, 15],
        [11, 14]
    ]
    
    
    func getPositionFunc(positions: [UIView]) -> Int -> Position {
        return { (nr: Int) in
            return Position(x: nr % 4, y: Int(floor(Double(nr) / 4.0)), view: positions[nr] )
        }
    }
    
    var state = State()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let positions: [UIView] = [view_1, view_2, view_3, view_4, view_5, view_6, view_7, view_8, view_9, view_10, view_11, view_12, view_13, view_14, view_15, view_16]
        
        let tiles: [UIView] = Array(0..<15).map { (i: Int) in
            
            let x = i % 4
            let y = Int(floor(Double(i) / 4.0))
            
            let image = UIImage(named: "\(x)_\(y)")
            let imageview = UIImageView(image: image)
            
            imageview.contentMode = .ScaleAspectFit
            imageview.translatesAutoresizingMaskIntoConstraints = false
            imageview.userInteractionEnabled = true
            let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
            imageview.addGestureRecognizer(recognizer)
            
            return imageview
        }
        
        let f = getPositionFunc(positions)
        
        let emptyTile: [(Position, Tile?)] = [(f(15), nil)]
        let board: Board = Array(0..<15).map { (f($0), Tile(number: $0, view: tiles[$0])) } + emptyTile
        
        state.board = shuffleBoard(board)
            
        for (_, pos) in state.board.enumerate() {
            
            if let t = pos.tile {
                
                let imageview = t.view
                let destView = pos.position.view
                destView.addSubview(imageview)
                
                let widthConstraint = NSLayoutConstraint(item: imageview, attribute: .Width, relatedBy: .Equal, toItem: destView, attribute: .Width, multiplier: 1, constant: 0)
                let heightConstraint = NSLayoutConstraint(item: imageview, attribute: .Height, relatedBy: .Equal, toItem: destView, attribute: .Height, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: imageview, attribute: .Top, relatedBy: .Equal, toItem: destView, attribute: .Top , multiplier: 1, constant: 0)
                let leadingConstraint = NSLayoutConstraint(item: imageview, attribute: .Leading, relatedBy: .Equal, toItem: destView, attribute: .Leading, multiplier: 1, constant: 0)
                
                NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, topConstraint, leadingConstraint])
            }
        }
        
        gameLoop()
    }
    
    func gameLoop() {
        let emptyTileIndex = state.board.indexOf { $0.tile == nil }!
        let neighbouringTiles = neighbours[emptyTileIndex]
        
        state.moveableTiles = neighbouringTiles.map { (i) in
            let tileAndPosition = state.board[i]
            var direction: Direction? = nil
            switch (i - emptyTileIndex) {
            case -1:
                direction = .Right
            case 1 :
                direction = .Left
            case -4:
                direction = .Down
            case 4:
                direction = .Up
            default:
                print("This should throw an error or something")
            }
            
            return (tileAndPosition.tile!, tileAndPosition.position, direction!)
        }
        
    }
    
    
    func shuffleBoard(board: Board) -> Board {
        
        func shuffle(var board: Board, times: Int) -> Board {
            if times == 0 {
                return board
            }
            
            let emptyTileIndex = board.indexOf { $0.tile == nil }!
            
            print("EmptyTileIndex \(emptyTileIndex)")
            
            let tileNeighbours = neighbours[emptyTileIndex]
            let randomNeighbourIndex = tileNeighbours[Int(arc4random_uniform(UInt32(tileNeighbours.count)))]
            
            print("Swapping with \(randomNeighbourIndex)")
            
            let emptyTile = board[emptyTileIndex]
            let tile = board[randomNeighbourIndex]
            
            board[emptyTileIndex] = (emptyTile.position, tile.tile)
            board[randomNeighbourIndex] = (tile.position, emptyTile.tile)
            
            return shuffle(board, times: times - 1)
        }
        
        
        return shuffle(board, times: 100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer)
    {
        if let movingView = recognizer.view, foundView = state.moveableTiles.filter({ $0.0.view == movingView }).first {
            print("Direction for moving is \(foundView.2)")
            
            let direction = foundView.2
            var bounds: (CGPoint, CGPoint)? = nil
            
            print("Position \(foundView.0.view.bounds.width)")
            let v = foundView.1.view
            
            switch direction{
            case .Up:
                bounds =  (v.center, CGPoint(x: v.center.x, y: v.center.y - v.bounds.height))
            case .Down:
                bounds =  (v.center, CGPoint(x: v.center.x, y: v.center.y + v.bounds.height))
            case .Left:
                bounds =  (v.center, CGPoint(x: v.center.x - v.bounds.width, y: v.center.y))
            case .Right:
                bounds =  (v.center, CGPoint(x: v.center.x + v.bounds.width, y: v.center.y))
            }
            
            let translation = recognizer.translationInView(self.view)
            let tileView = foundView.0.view
            
            print(tileView.center)
            let a = container.convertPoint(tileView.center, toView: tileView)
            print(a)
            
            let b = tileView.convertPoint(tileView.center, toView: container)
            print(b)
            
            let intentedPosition = CGPoint(x: tileView.center.x + translation.x, y: tileView.center.y + translation.y)
            
            var newPosition = tileView.center
            
//            print("intendedPosition \(intentedPosition)")
//            print("bounds \(bounds)")
            
            if intentedPosition.x >= bounds!.0.x && intentedPosition.x <= bounds!.1.x {
                newPosition.x = intentedPosition.x
            }
            
            if(intentedPosition.y >= bounds!.0.y && intentedPosition.y <= bounds!.1.y){
                newPosition.y = intentedPosition.y
            }
            
//            print("newPosition \(newPosition)")
            
            
            tileView.center = newPosition
            recognizer.setTranslation(CGPointZero, inView: self.view)
            
            
        } else {
            print("This tile shouldn't move")
        }
        
        if recognizer.state == .Ended{
            gameLoop()
            //                    if let view = recognizer.view {
            //                        UIView.animateWithDuration(0.7, animations: {
            //                            view.center.y -= 300
            //                        })
            //                    }
        }
        
        

//        
//        if let view = recognizer.view{
//            view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
}
