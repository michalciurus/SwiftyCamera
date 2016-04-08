//
//  AVCaptureFileOutputExtension.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 08/04/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

extension AVCaptureOutput {
    
    public func getActiveVideoConnection() -> AVCaptureConnection? {
        
        for captureConnection in self.connections {
            for port in captureConnection.inputPorts {
                if port.mediaType == AVMediaTypeVideo {
                    return captureConnection as? AVCaptureConnection
                }
            }
        }
        
        return nil
        
    }
    
}
