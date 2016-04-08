//
//  SwiftyCaptureSession.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

//MARK: --- Delegate Definition ---

public protocol VideoCaptureSessionDelegate : class {
    func capturedPicture( pictureData : NSData )
    func deviceAuthorized( isAuthorized : Bool )
}

// Optional methods in Swift 😅
extension VideoCaptureSessionDelegate {
    public func capturedPicture( pictureData : NSData ) {}
    public func deviceAuthorized( isAuthorized : Bool ) {}
}

//MARK: --- Enums ---

public enum VideoCaptureSessionError : ErrorType {
    case NotAuthorized
}

public enum TorchModeStatus {
    case TorchModeOn
    case TorchModeOff
    case TorchModeAutomatic
}

//MARK: --- Class Implementation ---

public class VideoCaptureSession {
    
    var captureSession : AVCaptureSession?
    var videoInput : VideoDeviceInput?
    var videoOutput :  AVCaptureMovieFileOutput?
    var stillImageOutput : AVCaptureStillImageOutput?
    
    var isAuthorized : Bool
    weak var delegate : VideoCaptureSessionDelegate?
    
    //MARK: --- Init ---
    
    public init() {
        
        isAuthorized = false
        self.captureSession = AVCaptureSession()
        self.requestVideoAuthorizationWithResultCallback { [weak self] (result) -> Void in
            if result == true {
                self?.delegate?.deviceAuthorized(result)
                self?.isAuthorized = true
                self?.setup()
            }
        }
    }
    
    //MARK: --- Public ---
    
    public func getPreviewLayerWithFrame( frame : CGRect ) -> CALayer? {
        var previewLayer : CALayer? = nil
        
        if let session = captureSession {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.frame = frame
        }
        
        return previewLayer
    }
    
    public func takePicture() throws {
        
        if self.isAuthorized == false {
            throw VideoCaptureSessionError.NotAuthorized
        }
        
        if let imageOutput = self.stillImageOutput {
            imageOutput.captureStillImageAsynchronouslyFromConnection(imageOutput.getActiveVideoConnection(), completionHandler: { (buffer, error) in
                
                if buffer == nil || error != nil {
                    return;
                }
                
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                self.delegate?.capturedPicture(data!)
                
            })
        }
    }
    
    public func changeTorchMode( torchMode : TorchModeStatus) {
        
        var avTorchModeStatus = AVCaptureTorchMode.Auto
        
        if torchMode == .TorchModeOn {
            avTorchModeStatus = .On
        } else if torchMode == .TorchModeOff {
            avTorchModeStatus = .Off
        }
        
        self.videoInput?.changeTorchMode(avTorchModeStatus)
    }
    
    //MARK: --- Private ---
    
    private func requestVideoAuthorizationWithResultCallback( callback : (Bool) -> Void ) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: callback)
    }
    
    private func createAndAddVideoOutput() {
        videoOutput = AVCaptureMovieFileOutput()
        
        if let session = captureSession {
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
        }
    }
    
    private func setup() {
        self.videoInput = VideoDeviceInput(withDeviceInputType: VideoDeviceInputType.BackDevice)
        if let input = self.videoInput {
            self.captureSession?.addInput(input.deviceInput)
        }
        self.createAndAddVideoOutput()
        self.createAndAddStillImageOutput()
        self.captureSession?.startRunning()
    }
    
    private func createAndAddStillImageOutput() {
        stillImageOutput = AVCaptureStillImageOutput()
        
        if let session = captureSession {
            
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
            }
            
        }
        
    }
}
