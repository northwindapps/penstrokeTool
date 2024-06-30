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
