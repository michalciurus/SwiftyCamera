//
//  SwiftyCaptureSession.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

class SwiftyCaptureSession {
    
    var captureSession : AVCaptureSession?
    
    //MARK: --- Init ---
    
    init() {
        
           self.requestVideoAuthorizationWithResultCallback { (result) -> Void in
            if (result == true) {
                self.captureSession = AVCaptureSession()
            }
        }
    }
    
    //MARK: --- Private ---
    
    private func requestVideoAuthorizationWithResultCallback( callback : (Bool) -> Void ) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: callback)
    }
    
}
