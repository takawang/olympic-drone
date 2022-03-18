//
//  ViewController.swift
//  olympic-drone
//
//  Created by taka on 2022/3/18.
//

import UIKit

// MARK: - Point
struct Point: Decodable {
    let x, y: Int
    let color: String
}

// load all points from json file.
//
// ref: https://stackoverflow.com/a/50042872
// ref: https://praveenkommuri.medium.com/how-to-read-parse-local-json-file-in-swift-28f6cec747cf
func loadPoints(forName name: String) -> [Point] {
  do {
    guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else { return [] }
    let fileUrl = URL(fileURLWithPath: filePath)
    let data = try Data(contentsOf: fileUrl)
    let points = try JSONDecoder().decode([Point].self, from: data)
    return points
    
  } catch {
    print("Something went wrong: \(error)")
    return []
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    var points = loadPoints(forName: "ring")
    print(points[0])
  }


}

