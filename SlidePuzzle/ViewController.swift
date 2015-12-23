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
    
    var hashValue: Int {
        return number
    }
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs.hashValue == rhs.hashValue
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
            
            let tileNeighbours = neighbours[emptyTileIndex]
            let randomNeighbourIndex = tileNeighbours[Int(arc4random_uniform(UInt32(tileNeighbours.count)))]
            
            let emptyTile = board[emptyTileIndex]
            let tile = board[randomNeighbourIndex]
            
            board[emptyTileIndex] = (emptyTile.position, tile.tile)
            board[randomNeighbourIndex] = (tile.position, emptyTile.tile)
            
            return shuffle(board, times: times - 1)
        }
        
        
        return shuffle(board, times: 200)
    }
    
    func switchTiles(tile: Tile) {
        
        let emptyTileIndex = state.board.indexOf { $0.tile == nil }!
        let emptyTile = state.board[emptyTileIndex]

        let tileIndex = state.board.indexOf {$0.tile != nil && $0.tile! == tile}!
        let tilePos = state.board[tileIndex].position
        
        state.board[emptyTileIndex] = (emptyTile.position, tile)
        state.board[tileIndex] = (tilePos, nil)
        
        let destView = emptyTile.position.view
        let imageview = tile.view
        
        tile.view.removeFromSuperview()
        
        imageview.transform = CGAffineTransformIdentity
        
        destView.addSubview(imageview)
        
        let widthConstraint = NSLayoutConstraint(item: imageview, attribute: .Width, relatedBy: .Equal, toItem: destView, attribute: .Width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageview, attribute: .Height, relatedBy: .Equal, toItem: destView, attribute: .Height, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: imageview, attribute: .Top, relatedBy: .Equal, toItem: destView, attribute: .Top , multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: imageview, attribute: .Leading, relatedBy: .Equal, toItem: destView, attribute: .Leading, multiplier: 1, constant: 0)
        
        
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, topConstraint, leadingConstraint])
        
        let nrs = state.board.flatMap { t in t.tile?.number }
        if nrs.sort() == nrs {
            let alert = UIAlertController(title: "w00t!", message: "You done knocked that shit outta the park, son!", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            presentViewController(alert, animated: true) { () -> Void in }
        } else {
            gameLoop()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer)
    {
        if let movingView = recognizer.view, foundView = state.moveableTiles.filter({ $0.0.view == movingView }).first {
            let direction = foundView.2
            let width = movingView.bounds.width
            let height = movingView.bounds.height
            let translation = recognizer.translationInView(self.view)
            
            if(recognizer.state == .Ended) {

                let percentageX = (abs(movingView.transform.tx) / width) * 100
                let percentageY = (abs(movingView.transform.ty) / height) * 100
                
                if(percentageX + percentageY < 50){
                    UIView.animateWithDuration(0.2, animations: {
                        movingView.transform = CGAffineTransformMakeTranslation(0, 0)
                    })
                    
                    gameLoop()
                    return
                }
                
                var animation: (x: CGFloat, y: CGFloat) = (0,0)
                
                switch direction {
                case .Up:
                    animation = (0, -height)
                case .Down:
                    animation = (0, height)
                case .Left:
                    animation = (-width, 0)
                case .Right:
                    animation = (width, 0)
                }
                
                UIView.animateWithDuration(0.1, animations: {
                    movingView.transform = CGAffineTransformMakeTranslation(animation.x, animation.y)
                    }, completion: { _ in
                        self.switchTiles(foundView.0)
                })
                return
            }
            
            var movement: (allowed: Bool, transformation:(x: CGFloat, y: CGFloat))? = nil
            
            switch direction {
            case .Up:
                movement = (translation.y >= -height && translation.y <= 0, (0, translation.y))
            case .Down:
                movement = (translation.y <= height && translation.y >= 0, (0, translation.y))
            case .Left:
                movement = (translation.x >= -width && translation.x <= 0, (translation.x, 0))
            case .Right:
                movement = (translation.x <= width && translation.x >= 0, (translation.x, 0))
            }
            
            if movement!.allowed {
                movingView.transform = CGAffineTransformMakeTranslation(movement!.transformation.x, movement!.transformation.y)
            }
        } else {
            print("This tile shouldn't move")
        }
    }
    
}
