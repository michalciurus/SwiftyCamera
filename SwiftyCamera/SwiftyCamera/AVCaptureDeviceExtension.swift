//
//  AVCaptureDeviceExtension.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 08/04/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

public extension AVCaptureDevice {
    
    public func changeTorchMode( torchModeStatus : AVCaptureTorchMode ) -> Bool {
        
        var didSetTorchMode = false
        
            if let _ = try? self.lockForConfiguration() {
                if self.isTorchModeSupported(torchModeStatus) {
                    self.torchMode = torchModeStatus
                    didSetTorchMode = true
                }
                self.unlockForConfiguration()
            }
    
        return didSetTorchMode
    }

}