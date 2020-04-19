//
//  gameView.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/7/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class gameView: UIViewController {
    //arrowManager is a var because we deallocate it to avoid threading issues - it has its own deinit call which will reset all the counts for the arrows we called
    var arrowManager: ArrowManager?
    let motion = CMMotionManager()
    let JsonPost = ServerRequests()
    
    var schoolId: Int = 0
    var ID: Int = 0
    var StartTime: Double?
    var score = 0
    var isCongruent: Int?
    var isLeft: Int?
    var isCorrect = [Int]()
    var arrowShownArray = [Any]()
    var averageResponse: Double?
    var presentTime: TimeInterval?
    var timer = Timer()
    var seconds = 5
    var MotionLock = true
    var changeInterval = 1.0
    var PostData = [Dictionary<String, Any>]()
    var organizationArray = [Any]()
    
    //the only labe displayed during game play
    @IBOutlet weak var gameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //startgame
        timeTicker()
        //activate motion and score recording
        activateMotion()
    }
    

    
    @objc func counter(){
        //decrement seconds as the ticker calls our function
        seconds -= 1
        
        //switch on cases based on the time ranges
        switch seconds {
            
        case 1...5:
            self.gameLabel.text = "\(seconds)"
            
        case 0:
            StartTime = NSDate().timeIntervalSince1970
            self.gameLabel.text = "Begin!"
            arrowManager = ArrowManager()
            
            
        case -20...(-1):
            changeTime(newTime: 3.0)
            
            let ArrowInfo = (arrowManager!.presentArrow())
            presentTime = NSDate().timeIntervalSince1970
            self.gameLabel.text = ArrowInfo.0
            MotionLock = false
            perform(#selector(dissappearArrow), with: nil, afterDelay: 0.3)
            self.arrowShownArray.append(ArrowInfo.0)
            
            isCongruent = ArrowInfo.1
            isLeft = ArrowInfo.2
            
            self.PostData.append(["isCongruent": isCongruent!, "isLeft": isLeft!, "response_time": 3.0, "isCorrect": 0])
           
        case -22...(-21):
            self.gameLabel.text = "End Game!"
            
        case -24...(-23):
            
            averageResponse = averageResponseTime()
            self.timer.invalidate()
            self.arrowManager = nil
            self.seconds = 5
            print("PostData ->", PostData)
            
            print(self.ID, self.schoolId, self.StartTime!)
            
            JsonPost.createPost(candidate_id: self.ID , school_id: self.schoolId , test_time: self.StartTime!, test_instance_id: 1, test_id: 1, test_entries: PostData) { (err) in
                if let error = err {
                    let alert = UIAlertController(title: "Failed to Send", message: "Check your wifi or cellular signal as you are in a state where the server can not retrieve your important data. \(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    print("WE HAD A SENDOFF ERROR ->", error)
                } else {
                    print("Successful Sendoff!")
                }
            }
            performSegue(withIdentifier: "gameResults", sender: nil)
            
        default: break
            //do nothing
        }
    }
    
//starts the time ticker which runs the
    func timeTicker() {
            timer = Timer.scheduledTimer(timeInterval: changeInterval, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }
    
//change time must invalidate the timer change the timer variable then restart the timer
    func changeTime(newTime: Double) {
        self.timer.invalidate()
        self.changeInterval = newTime
        self.timeTicker()
    }
    
//this is an objc function so it can be called by a selector
    @objc func dissappearArrow() {
        self.gameLabel.text = ""
    }
    
    //determining the average response time by getting the sum of the dictionary values for "response_time"
    func averageResponseTime() -> Double {
        var responseSum = 0.0
        for i in self.PostData {
            responseSum = responseSum + (self.PostData[i.count]["response_time"] as! Double)
        }
        let average = responseSum/20.0
        return average
    }
    
    
    func activateMotion(){
        //looking for device motion
        print("is device motion available? ->", motion.isDeviceMotionAvailable)
        //here we are setting up the device to start motion updates
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.01
            motion.startDeviceMotionUpdates(to: .main) {
                [weak self] (data, error) in
                
                guard let data = data, error == nil else {
                    return
                }
                
                let rotation: Double = data.gravity.y.rounded()

                let isLeftBool = self?.isLeft.map({ $0 == 1 ? true : false })
                
                if abs(rotation) >= 0.8 && self!.seconds < 0 && self!.MotionLock == false{
                    self?.MotionLock = true
                    self?.changeTime(newTime: Double.random(in: 0.5 ..< 1.0))
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    self?.gameLabel.text = ""
                    
                    
                    //recording the response time and adding it to the post data object
                    let DataTime = NSDate().timeIntervalSince1970
                    self?.PostData[(self?.PostData.count)! - 1]["response_time"] = (DataTime - self!.presentTime!)
                    
                    
                    //this switch statement determines score
                    //if the phone rotation is greater than 0.8 and isLeft is true then add score
                    //if phone rotation is less than -0.8 and isLeft is false then add score
                    //if nothing then default is do nothing however we shouldnt need the default case as you are within an if statement that is only triggered if the abs value is greater than 0.8
                    switch (rotation, isLeftBool) {
                        
                    case ((0.8...100), true):
                        self?.changeTime(newTime: Double.random(in: 0.5 ..< 1.0))
                        self?.PostData[(self?.PostData.count)! - 1]["isCorrect"] = 1
                        self?.score += 1
                        
                    case (-100...(-0.8), false):
                        self?.changeTime(newTime: Double.random(in: 0.5 ..< 1.0))
                        self?.PostData[(self?.PostData.count)! - 1]["isCorrect"] = 1
                        self?.score += 1
                        
                    default:
                        self?.changeTime(newTime: Double.random(in: 0.5 ..< 1.0))
                        self?.PostData[(self?.PostData.count)! - 1]["isCorrect"] = 0
                 
                    }
                }
            }
        }
    }
    
    //passing data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! scoreController
        destinationVC.averageResponse = self.averageResponse
        destinationVC.score = self.score
    }
    
    

}
