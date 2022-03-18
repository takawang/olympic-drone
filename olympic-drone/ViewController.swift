//
//  ViewController.swift
//  olympic-drone
//
//  Created by taka on 2022/3/18.
//

import UIKit

struct Point: Decodable {
    let x, y: Int
    let color: String
}

// load all points from json file.
//
// ref: https://stackoverflow.com/a/50042872
// ref: https://praveenkommuri.medium.com/how-to-read-parse-local-json-file-in-swift-28f6cec747cf
func loadPoints(fileName name: String) -> [Point] {
  do {
    guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else { return [] }
    let fileUrl = URL(fileURLWithPath: filePath)
    let data = try Data(contentsOf: fileUrl)
    let points = try JSONDecoder().decode([Point].self, from: data)
    return points
    
  } catch {
    // should not happen!
    print("Something went wrong: \(error)")
    return []
  }
}

// setup CALayers with points
func setupLayers(fileName name: String, to targetLayer: CALayer) -> [CAShapeLayer] {
  let points = loadPoints(fileName: "ring") // count: 782
  
  // setup layers
  let layerCount = points.count
  var layers = [CAShapeLayer]()
  layers.reserveCapacity(layerCount)

  for idx in 1..<layerCount {
    let layer = CAShapeLayer()
    
    // MARK: - Ugly short version
    //layer.path = UIBezierPath(ovalIn: CGRect(x: points[idx].x, y: points[idx].y, width: 1, height: 1)).cgPath
    
    // path setup
    let path = UIBezierPath()
    let center = CGPoint(x: points[idx].x, y: points[idx].y)
    path.move(to: CGPoint(x: points[idx].x, y: points[idx].y))
    path.addArc(withCenter: center, radius: 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

    // set layer path
    layer.path = path.cgPath
    layer.strokeColor = UIColor(hex: points[idx].color+"ff")?.cgColor
    layer.fillColor = UIColor(hex: points[idx].color+"ff")?.cgColor
    
    // add layer to parent layer
    targetLayer.addSublayer(layer)
    
    // append to return array
    layers.append(layer)
  }
  return layers
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // load layers
    var layers = setupLayers(fileName: "ring", to: self.view.layer)
    print(layers[0])
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
            let hexColor = String(hex[start...])

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

