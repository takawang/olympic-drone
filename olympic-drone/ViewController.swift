//
//  ViewController.swift
//  olympic-drone
//
//  Created by taka on 2022/3/18.
//

import UIKit

class ViewController: UIViewController {
  var touchCountTimer: Timer?
  var touchBeginTime: Double = 0
  let pointController = PointController() // composition
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // load layers
    let result = pointController.attachLayers(to: self.view.layer, fromJsonFile: "ring")

    // TODO: - remove
    let layers = result.layers
    let points = result.points
    print(layers[0].position)
    layers[0].position = CGPoint(x: -100, y: -100)
    print(points[0])
    
    addLongPressGesture() // handle press
  }
  
  // register gesture recognizer
  //
  // ref: [How can i count time on long-pressed button using UILongPressGestureRecognizer](https://stackoverflow.com/a/53146530)
  func addLongPressGesture(){
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
    longPress.minimumPressDuration = 0.1
    longPress.numberOfTouchesRequired = 1
    self.view.addGestureRecognizer(longPress)
    //self.countButton.addGestureRecognizer(longPress)
  }
  
  // handle long press event
  //
  // ref: [How can i count time on long-pressed button using UILongPressGestureRecognizer](https://stackoverflow.com/a/53146530)
  @objc func longPress(gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case UIGestureRecognizer.State.began:
      print("begin")
      touchCountTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [self] (timer) in
        print("User pressing \(Date().timeIntervalSince1970 - self.touchBeginTime) sec.")
        //print(view.layer.position)
        //view.layer.position = CGPoint(x: self.x, y: self.y)
      })
      touchBeginTime = Date().timeIntervalSince1970
    case .ended, .failed, .cancelled:
      touchCountTimer?.invalidate() // Stops the timer
    case .changed: // wipe
      let point = gesture.location(in: self.view)
      print("point x:\(point.x), y:\(point.y)")
    default:
      print("unknown")
    }
  }
  
  
}
