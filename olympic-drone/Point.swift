//
//  Point.swift
//  olympic-drone
//
//  Created by taka on 2022/3/19.
//

import UIKit

// Point definition for json object
class Point: Decodable {
  let x, y: Int
  let color: String
  
  // load all points from json file.
  //
  // ref: https://stackoverflow.com/a/50042872
  // ref: https://praveenkommuri.medium.com/how-to-read-parse-local-json-file-in-swift-28f6cec747cf
  static func loadFromJson(fileName name: String) -> [Point] {
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

}
