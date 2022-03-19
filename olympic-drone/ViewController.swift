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
  let droneCollection = DroneCollectionController(fromJsonFile: "ring") // composition
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    droneCollection.attachToLayer(to: self.view.layer) // attach drone layer
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
  }
  
  // handle long press event
  //
  // ref: [How can i count time on long-pressed button using UILongPressGestureRecognizer](https://stackoverflow.com/a/53146530)
  @objc func longPress(gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case UIGestureRecognizer.State.began:
      touchCountTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] (timer) in
        // MARK: - do animation
        droneCollection.animation()
      })
      touchBeginTime = Date().timeIntervalSince1970
    case .ended, .failed, .cancelled:
      touchCountTimer?.invalidate() // Stops the timer
      DroneCollectionController.isArrived = false
    case .changed: // wipe
      //let point = gesture.location(in: self.view)
      //print("point x:\(point.x), y:\(point.y)")
      break
    default:
      print("unknown")
    }
  }
  
  
}
