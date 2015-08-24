//
//  ViewController.swift
//  TapTap
//
//  Created by Michael Corrigan on 8/20/15.
//  Copyright (c) 2015 M.G. Corrigan. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var doubleTapLabel: UILabel!
    
    let manager = CMMotionManager()
    var doubleTap : Bool = false
    let motionUpdateInterval : Double = 1.0 / 100.0 // 100Hz is the max according to Apple
    
    var accelerations:[Double] = []
    var firstSet: Bool = false
    
    
    var max = 0.0
    var average = 0.0
    var cutOff = 0.0
    var aveAndMax:[Double] = []
    var timeDifference = 0.0
    
    //    var jerk:[Double] = []
    //    var snap:[Double] = []
    //    var crackle:[Double] = []
    //    var pop:[Double] = []
    
    // This function returns the derivative of an array of values
    func derivative(motion: [Double],deltaT: Double)-> [Double] {
        var newMotion:[Double] = []
        for var i = 0; i < motion.endIndex - 1; i++ {
            let newValue = (motion[i + 1] - motion[i]) / deltaT
            newMotion.append(newValue)
        }
        return newMotion
    }
    
    func averageABS(data: [Double])-> Double {
        var sum = 0.0
        for i in data {
            sum += abs(i)
        }
        let ave = sum / Double(data.count)
        return ave
    }
    
    func peak(data: [Double])-> Double {
        var max = 0.0
        for i in data {
            if max < abs(i) {
                max = abs(i)
            }
        }
        return max
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doubleTapLabel.text = ""
        
        
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = motionUpdateInterval // seconds
            
//            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
//                [weak self] (data: CMDeviceMotion!, error: NSError!) in
            self.manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
                data, error in
            
                
                if self.accelerations.count < 100 {
                    self.accelerations.append(data!.userAcceleration.z)
                } else {
                    // check if this is the first 100 values
                    if (!self.firstSet) {
                        for var i = 0; i < self.accelerations.endIndex; i++ {
                            self.accelerations[i] = 100 * self.accelerations[i]
                        }
                        self.firstSet = true
                    } else {
                        for var i = 50; i < self.accelerations.endIndex; i++ {
                            self.accelerations[i] = 100 * self.accelerations[i]
                        }
                        
                    }
                    self.max = self.peak(self.accelerations)
                    self.average = self.averageABS(self.accelerations)
                    self.aveAndMax = [self.max,self.average]
                    self.cutOff = self.averageABS(self.aveAndMax)
                    for i in self.accelerations {
                        if i > self.cutOff {
                            
                            if let firstIndex = self.accelerations.indexOf(i) {
                                if let maxIndex = self.accelerations.indexOf(self.max) {
                                    
                                }
                            }
                            
                            
                            self.timeDifference = Double(abs(self.accelerations.indexOf(i)! - self.accelerations.indexOf(self.max)!))
                            if self.timeDifference > 10.0 && self.timeDifference < 40.0 {
                                self.doubleTap = true
                                self.doubleTapLabel.text = "TAP TAP!"
                            }
                        }
                    }
                    self.accelerations[0...50] = []

                }
            }
            
        }
    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
}

