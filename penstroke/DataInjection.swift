//
//  DataInjection.swift
//  penstroke
//
//  Created by yano on 2024/06/30.
//

import Foundation

protocol DataManagerProtocol {
    var timeStamps: [String] { get set }
    var events: [String] { get set }
    var x_cordinates: [String] { get set }
    var y_cordinates: [String] { get set }
    var annotations: [String] { get set }
    var sample_tags: [String] { get set }
    var frame_widths: [String] { get set }
    var frame_heights: [String] { get set }
}

class SharedDataManager: DataManagerProtocol {
    var timeStamps: [String] = []
    var events: [String] = [] // start, move, end
    var x_cordinates: [String] = []
    var y_cordinates: [String] = []
    var annotations: [String] = []
    var sample_tags: [String] = []
    var frame_widths: [String] = []
    var frame_heights: [String] = []
}

//output json format
//{
//  "penStrokes": [
//    {
//      "strokeID": 1,
//      "timeStamps": ["2024-06-30T12:00:00.000Z", "2024-06-30T12:00:00.100Z", "2024-06-30T12:00:00.200Z"],
//      "x_coordinates": [100, 102, 105],
//      "y_coordinates": [200, 202, 205],
//      "pressure": [0.5, 0.6, 0.4],
//      "annotations": "Example stroke 1",
//      "sample_tags": ["tag1", "tag2"],
//      "frame_width": 800,
//      "frame_height": 600
//    },
//    {
//      "strokeID": 2,
//      "timeStamps": ["2024-06-30T12:01:00.000Z", "2024-06-30T12:01:00.100Z", "2024-06-30T12:01:00.200Z"],
//      "x_coordinates": [150, 152, 155],
//      "y_coordinates": [250, 252, 255],
//      "pressure": [0.7, 0.5, 0.3],
//      "annotations": "Example stroke 2",
//      "sample_tags": ["tag3"],
//      "frame_width": 800,
//      "frame_height": 600
//    }
//  ]
//}
//
