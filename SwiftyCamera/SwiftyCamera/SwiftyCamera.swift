//
//  SwiftyCamera.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

public class SwiftyCamera : UIViewController {
    
    //MARK: --- Internal ---
    
    var captureSession : VideoCaptureSession?
    
    override public func viewDidLoad() {
        
        captureSession = VideoCaptureSession()
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        
        self.view.layer.insertSublayer(captureSession!.getPreviewLayerWithFrame(CGRect(x: 0, y: 0, width: 400, height: 400))!
            , atIndex: 0)
        
        
    }
    
    public override func viewDidAppear(animated: Bool) {
        
        delay(3) { 
            try! self.captureSession?.takePicture()
        }
    }
    
}