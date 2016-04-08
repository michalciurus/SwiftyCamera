//
//  SwiftyCaptureSession.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

public protocol VideoCaptureSessionDelegate : class {
    func capturedPicture( pictureData : NSData )
    func deviceAuthorized( isAuthorized : Bool )
}

// Optional methods in Swift 😅
extension VideoCaptureSessionDelegate {
    public func capturedPicture( pictureData : NSData ) {
    }
    
    public func deviceAuthorized( isAuthorized : Bool ) {
    }
}

public enum VideoCaptureSessionError : ErrorType {
    case NotAuthorized
}

public class VideoCaptureSession {
    
    var captureSession : AVCaptureSession?
    var videoOutput :  AVCaptureMovieFileOutput?
    var stillImageOutput : AVCaptureStillImageOutput?
    
    var isAuthorized : Bool
    weak var delegate : VideoCaptureSessionDelegate?
    
    //MARK: --- Init ---
    
    public init() {
        
        isAuthorized = false
        self.captureSession = AVCaptureSession()
        
           self.requestVideoAuthorizationWithResultCallback { [weak self] (result) -> Void in
            if (result == true) {
                self?.delegate?.deviceAuthorized(result)
                self?.isAuthorized = true
                let videoInput = VideoDeviceInput(withDeviceInputType: VideoDeviceInputType.FrontDevice)
                self?.captureSession?.addInput(videoInput.deviceInput)
                self?.createAndAddVideoOutput()
                self?.createAndAddStillImageOutput()
                self?.captureSession?.startRunning()
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
    
    private func createAndAddStillImageOutput() {
        stillImageOutput = AVCaptureStillImageOutput()
        
        if let session = captureSession {
            
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
            }
            
        }
        
    }
}
