//
//  Acceleration.swift
//  TapTap
//
//  Created by Michael Corrigan on 8/21/15.
//  Copyright (c) 2015 M.G. Corrigan. All rights reserved.
//

import Foundation
import CoreMotion

class Accelerometer {
    
    let motionManager: CMMotionManager
    let accQueue = NSOperationQueue()
    
    var x: Double
    var y: Double
    var z: Double
    var lastX: Double
    var lastY: Double
    var lastZ: Double
    let kUpdateFrequency: Double
    let cutOffFrequency: Double
    let dt: Double
    let RC: Double
    let alpha: Double
    let kFilteringFactor = 0.6
    
    
    init(manager: CMMotionManager){
        
        motionManager = manager
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates()
        
        x = 0.0
        y = 0.0
        z = 0.0
        lastX = 0.0
        lastY = 0.0
        lastZ = 0.00
        kUpdateFrequency = 60.0
        cutOffFrequency = 5.0
        dt = 1.0 / kUpdateFrequency
        RC = 1.0 / cutOffFrequency
        alpha = RC / (dt+RC) // 0.92307691
        getAccelerometerUpdates()
        
    }
    
    func getAccelerometerUpdates() {
        
        motionManager.startAccelerometerUpdatesToQueue(accQueue, withHandler: { (data, error) -> Void in
            
            // Filter the raw measurments with high pass filter
            print(String(stringInterpolationSegment: self.highPassFilter(data!)), appendNewline: false)
        })
        
    }
    
    
    // High pass filter function for accelerometer measurments
    func highPassFilter(data: CMAccelerometerData)-> Double {
        
        self.x = self.alpha * (self.x + data.acceleration.x - self.lastX)
        self.y = self.alpha * (self.y + data.acceleration.y - self.lastY)
        self.z = self.alpha * (self.z + data.acceleration.z - self.lastZ)
        
        self.lastX = data.acceleration.x
        self.lastY = data.acceleration.y
        self.lastZ = data.acceleration.z
        
        return self.lastZ
    }
    
}
