//
//  ParticleControllerViewController.swift
//  olympic-drone
//
//  Created by taka on 2022/3/19.
//

import UIKit

class DroneCollectionController: NSObject {
  static let totalFrame: Int = 20
  static var isArrived: Bool = false
  
  var drones: [Drone]
  var points: [Point]
  var currentFrame: Int = 0
  
  // constructor
  init(fromJsonFile fileName: String) {
    points = Point.loadFromJson(fileName: fileName) // count: 782
    drones = [Drone]()
    drones.reserveCapacity(points.count)
    
    for idx in 0..<points.count {
      let drone = Drone(idx: idx, x: points[idx].x, y: points[idx].y, color: UIColor(hex: points[idx].color)!.cgColor)
      drones.append(drone)
    }
  }
  
  // attach drone layers to target layer
  func attachToLayer(to targetLayer: CALayer) {
    for drone in drones {
      targetLayer.addSublayer(drone.layer)
    }
  }
  
  // animation
  func animation() {
    switch currentFrame {
    case 0..<DroneCollectionController.totalFrame:
      currentFrame += 1
      for drone in drones {
        drone.forward(frame: DroneCollectionController.totalFrame)
      }
    case DroneCollectionController.totalFrame:
      if !DroneCollectionController.isArrived {
        for drone in drones {
          drone.arrive()
        }
      }
      DroneCollectionController.isArrived = true
    default:
      print("do nothing")
    }
  }

}

// MARK: - Convert a hex color to a UIColor
//
// ref: https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
extension UIColor {
  public convenience init?(hex: String) {
    let r, g, b, a: CGFloat
    
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      var hexColor = String(hex[start...])
      
      // set alpha for rgb only hex code
      if hexColor.count == 6 {
        hexColor += "ff"
      }
      
      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255
          
          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }
    return nil
  }
}
