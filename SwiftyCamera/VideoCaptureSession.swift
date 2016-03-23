//
//  SwiftyCaptureSession.swift
//  SwiftyCamera
//
//  Created by Michal Ciurus on 23/03/16.
//  Copyright © 2016 MichalCiurus. All rights reserved.
//

import Foundation
import AVFoundation

public class VideoCaptureSession {
    
    var captureSession : AVCaptureSession?
    var videoOutput :  AVCaptureMovieFileOutput?
    
    //MARK: --- Init ---
    
    public init() {
        
           self.requestVideoAuthorizationWithResultCallback { (result) -> Void in
            if (result == true) {
                self.captureSession = AVCaptureSession()
                let videoInput = VideoDeviceInput(withDeviceInputType: VideoDeviceInputType.FrontDevice)
                self.captureSession?.addInput(videoInput)
                self.captureSession?.startRunning()
            }
        }
    }
    
    public func getPreviewLayerWithFrame( frame : CGRect  ) -> CALayer? {
        var previewLayer : CALayer? = nil
        
        if let session = captureSession {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.frame = frame
        }
        
        return previewLayer
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
}
