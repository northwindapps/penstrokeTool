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
    var annotation: [String] { get set }
    var sample_tags: [String] { get set }
}

class SharedDataManager: DataManagerProtocol {
    var timeStamps: [String] = []
    var events: [String] = [] // start, move, end
    var x_cordinates: [String] = []
    var y_cordinates: [String] = []
    var annotation: [String] = []
    var sample_tags: [String] = []
}
