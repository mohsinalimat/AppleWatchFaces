//
//  InterfaceController.swift
//  Face Extension
//
//  Created by Michael Hill on 10/17/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    let session = WCSession.default
    
    var currentClockSetting: ClockSetting = ClockSetting.defaults()
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, String>()
        
        if let curClockSettingString = message["curClockSettingString"] as? String {
            
            let jsonData = JSON.init(parseJSON: curClockSettingString)
            let newClockSetting = ClockSetting.init(jsonObj: jsonData)

            currentClockSetting = newClockSetting
            if let skWatchScene = self.skInterface.scene as? SKWatchScene {
                skWatchScene.redraw(clockSetting: currentClockSetting)
            }
            replyValues["status"] = "success"
        } else {
            replyValues["status"] = "error"
        }
        
        replyHandler(replyValues)
    }
    
    func processApplicationContext() {
        if let iPhoneContext = session.receivedApplicationContext as? [String : JSON] {
            debugPrint("newSetting")
            if let clockSettingJSON = iPhoneContext["newSetting"] {
                let newClockSetting = ClockSetting.init(jsonObj: clockSettingJSON)
                
            }
        }
        if let iPhoneContext = session.receivedApplicationContext as? [String : String] {
            debugPrint("FaceChosen" + iPhoneContext["FaceChosen"]!)
            
            if let chosenFace = iPhoneContext["FaceChosen"] {
                
                UserDefaults.standard.set(chosenFace, forKey: "FaceChosen")
                
                if let skWatchScene = self.skInterface.scene as? SKWatchScene {
                    skWatchScene.redraw(clockSetting: currentClockSetting)
                }
            }
            
            
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async() {
            self.processApplicationContext()
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //processApplicationContext()
        
        setTitle(" ")
        
        // Configure interface objects here.
        session.delegate = self
        session.activate()
        
        
        // Load the SKScene
        if let scene = SKWatchScene(fileNamed: "SKWatchScene") {
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skInterface.presentScene(scene)
            
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 30
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
