//
//  Drone.swift
//  olympic-drone
//
//  Created by taka on 2022/3/19.
//

import UIKit

class Drone: NSObject {
  static var layerWidth: Int = 1366
  static var layerHeight: Int = 1024
  static let lightColor: CGColor = UIColor(hex: "#E9ECD6")!.cgColor
  static var radius: Double = 2.0
  
  var layer = CAShapeLayer()
  var index: Int // drone index
  
  var originColor: CGColor
  var originX: Int
  var originY: Int
  
  var color: CGColor // init color
  var randomX: Int
  var randomY: Int

  // constructor
  init(idx: Int, x: Int, y: Int, color: CGColor, width: Int = 1366, height: Int = 1024) {
    
    Drone.layerWidth = width
    Drone.layerHeight = height
    
    self.index = idx
    self.color = UIColor.white.cgColor
    self.randomX = Drone.getRandomPosition(size: Drone.layerWidth)
    self.randomY = Drone.getRandomPosition(size: Drone.layerHeight)
    self.originColor = color // olympic symbol
    self.originX = x // olympic symbol
    self.originY = y // olympic symbol
    
    // layer setup
    let path = UIBezierPath()
    let center = CGPoint(x: self.originX, y: self.originY)
    path.move(to: CGPoint(x: self.originX, y: self.originY))
    path.addArc(withCenter: center, radius: Drone.radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    self.layer.path = path.cgPath
    self.layer.strokeColor = self.color
    self.layer.fillColor = self.color
    self.layer.position = CGPoint(x: self.randomX, y: self.randomY)
  }
  
  // move to olympic symbol
  func forward(frame: Int) {
    let gapX: Double = Double(self.randomX) / Double(frame)
    let gapY: Double = Double(self.randomY) / Double(frame)
    self.layer.position = CGPoint(x: self.layer.position.x - gapX, y: self.layer.position.y - gapY)
  }
  
  // handle arrive event
  func arrive() {
    self.layer.fillColor = self.originColor
    self.layer.strokeColor = self.originColor
  }
  
  // get random position according to layer size
  static func getRandomPosition(size: Int) -> Int {
    return Int.random(in: (-size/2)..<(size/2))
  }
}
