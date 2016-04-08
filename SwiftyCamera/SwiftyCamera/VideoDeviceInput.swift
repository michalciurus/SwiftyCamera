//
//  SwiftyDeviceInput.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

//MARK: --- Enums ---

public enum VideoDeviceInputType : Int {
    case FrontDevice
    case BackDevice
}

let deviceTypeMapDictionary = [ VideoDeviceInputType.FrontDevice : AVCaptureDevicePosition.Front,
                                VideoDeviceInputType.BackDevice : AVCaptureDevicePosition.Back]

//MARK: --- Class ---

public class VideoDeviceInput {
    
    public var deviceInput : AVCaptureDeviceInput?
    public var captureDevice : AVCaptureDevice?
    
    //MARK: --- Init ---
    
    public init( withDeviceInputType type : VideoDeviceInputType) {
        self.captureDevice = VideoDeviceInput.getCaptureDeviceForType(type)
        try! deviceInput =  AVCaptureDeviceInput(device: captureDevice)
    }
    
    public func changeTorchMode( torchModeStatus : AVCaptureTorchMode) -> Bool {
        if let device = captureDevice {
            return device.changeTorchMode(torchModeStatus)
        } else {
            return false
        }
    }
    
    public func changeFlashMode( flashModeStatus : AVCaptureFlashMode) -> Bool {
        if let device = captureDevice {
            return device.changeFlashMode(flashModeStatus)
        } else {
            return false
        }
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