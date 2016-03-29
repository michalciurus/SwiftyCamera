//
//  SwiftyCamera.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import UIKit

public class SwiftyCamera : UIViewController {
    
    //MARK: --- Internal ---
    
    var captureSession : VideoCaptureSession?
    
    override public func viewDidLoad() {
        
        captureSession = VideoCaptureSession()
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        
        self.view.layer.insertSublayer(captureSession!.getPreviewLayerWithFrame(CGRect(x: 0, y: 0, width: 200, height: 200))!
            , atIndex: 0)
        
    }
    
}