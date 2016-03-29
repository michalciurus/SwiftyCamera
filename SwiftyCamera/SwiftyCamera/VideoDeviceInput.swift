//
//  SwiftyDeviceInput.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

public enum VideoDeviceInputType : Int {
    case FrontDevice
    case BackDevice
}

let deviceTypeMapDictionary = [ VideoDeviceInputType.FrontDevice : AVCaptureDevicePosition.Front,
    VideoDeviceInputType.BackDevice : AVCaptureDevicePosition.Back]

public class VideoDeviceInput {
    
    public var deviceInput : AVCaptureDeviceInput?
    
    //MARK: --- Init ---
    
    public init( withDeviceInputType type : VideoDeviceInputType) {
        
        let captureDevice = VideoDeviceInput.getCaptureDeviceForType(type)
        try! deviceInput =  AVCaptureDeviceInput(device: captureDevice)
    
    }
    
    //MARK: --- Private ---
    
    private class func getCaptureDeviceForType( type : VideoDeviceInputType) -> AVCaptureDevice {
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        for device in devices {
            
            if device.position == deviceTypeMapDictionary[type] {
                return device as! AVCaptureDevice
            }
        }
        
        return AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    }
    
}