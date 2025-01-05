//
//  DataInjection.swift
//  penstroke
//
//  Created by yano on 2024/06/30.
//

import Foundation

protocol DataManagerProtocol {
    var timeStamps: [String] { get set }
//    var events: [String] { get set }
    var x_coordinates: [String] { get set }
    var y_coordinates: [String] { get set }
    var annotations: [String] { get set }
    var sample_tags: [String] { get set }
    var frame_widths: [String] { get set }
    var frame_heights: [String] { get set }
    var traveled_distances: [String] { get set }
}

class SharedDataManager: DataManagerProtocol {
    var timeStamps: [String] = []
    //var events: [String] = [] // start, move, end
    var x_coordinates: [String] = []
    var y_coordinates: [String] = []
    var annotations: [String] = []
    var sample_tags: [String] = []
    var frame_widths: [String] = []
    var frame_heights: [String] = []
    var traveled_distances: [String] = []
}

struct DataEntry: Codable {
    var timeStamps: [String]
    //var events: [String]
    var xCoordinates: [String]
    var yCoordinates: [String]
    var annotation: String
    var sampleTag: String
    var frameWidth: String
    var frameHeight: String
    var traveledDistances: [String]
}

class DataManagerRepository {
    static let shared = DataManagerRepository()
    private var dataManagers: [SharedDataManager] = []
    
    private init() {}
    
    func addDataManager(_ manager: SharedDataManager) {
        dataManagers.append(manager)
    }
    
    func sumAllData() -> [DataEntry] {
        var dataArray: [DataEntry] = []
    
        for manager in dataManagers {
            if manager.x_coordinates != [] && manager.y_coordinates != [] && manager.annotations != []{
                let indices = manager.timeStamps.enumerated().compactMap { index, element in
                    element == "0.0" ? index : nil
                }
                
                var mngTime = [String]()
                var mngX = [String]()
                var mngY = [String]()
                var mngS = [String]()
                var cnter = 0
                
                for (i,each) in manager.timeStamps.enumerated(){
                    if indices.contains(i){
                        if mngTime.count>0{
                            var sampleStr = mngS.first ?? ""
                            if indices.count > 1 {
                                sampleStr += "_" + String(cnter)
                            }
                            let entry = DataEntry(
                                timeStamps: mngTime,
                                xCoordinates: mngX,
                                yCoordinates: mngY,
                                annotation: manager.annotations.first ?? "",
                                sampleTag: sampleStr,
                                frameWidth: manager.frame_widths.first ?? "",
                                frameHeight: manager.frame_widths.last ?? "",
                                traveledDistances: manager.traveled_distances
                            )
                            cnter += 1
                            dataArray.append(entry)
                            mngTime = []
                            mngX = []
                            mngY = []
                            mngS = []
                        }
                    }
                    
                    //append item
                    mngTime.append(manager.timeStamps[i])
                    mngX.append(manager.x_coordinates[i])
                    mngY.append(manager.y_coordinates[i])
                    mngS.append(manager.sample_tags[i])
                }//loopend
                if mngTime.count>0{
                    var sampleStr = mngS.first ?? ""
                    if indices.count > 1 {
                        sampleStr += "_" + String(cnter)
                    }
                    let entry = DataEntry(
                        timeStamps: mngTime,
                        xCoordinates: mngX,
                        yCoordinates: mngY,
                        annotation: manager.annotations.first ?? "",
                        sampleTag: sampleStr,
                        frameWidth: manager.frame_widths.first ?? "",
                        frameHeight: manager.frame_widths.last ?? "",
                        traveledDistances: manager.traveled_distances
                    )
                    cnter = 0
                    dataArray.append(entry)
                    mngTime = []
                    mngX = []
                    mngY = []
                    mngS = []
                }
            }//manager loop
        }
        
        return dataArray
    }
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
