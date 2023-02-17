//
//  PoseTortueMessage.swift
//  iOS2RosBridge_turtleDemo
//
//  Created by Alexandre PO on 09/01/2023.
//

import UIKit
import ObjectMapper

public class PoseTortueMessage: RBSMessage {
    public var x: Float64 = 0
    public var y: Float64 = 0
    public var theta: Float64 = 0
    public var linear_velocity: Float64 = 0
    public var angular_velocity: Float64 = 0
    
    
    public override func mapping(map: Map) {
        x <- map["x"]
        y <- map["y"]
        theta <- map["theta"]
        linear_velocity <- map["linear_velocity"]
        angular_velocity <- map["angular_velocity"]
    }
}
