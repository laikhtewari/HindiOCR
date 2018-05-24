//
//  CameraController.swift
//  HindiOCR
//
//  Created by Laikh Tewari on 5/20/18.
//  Copyright © 2018 Laikh Tewari. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    @IBOutlet weak var capturedPhoto: UIImageView!
    @IBOutlet weak var viewFinder: UIView!
    @IBOutlet weak var photoButton: UIButton!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var camera: AVCaptureDevice?
    var picture: AVCaptureOutput?
    

    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case videoPreivewLayerIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = AVCaptureDevice.default(for: .video)
        if let camera = camera {
            do {
                let input = try AVCaptureDeviceInput(device: camera)
                captureSession = AVCaptureSession()
                if let captureSession = captureSession {
                    captureSession.addInput(input)
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                } else {
                    throw CameraControllerError.captureSessionIsMissing
                }
                if let videoPreviewLayer = videoPreviewLayer {
                    videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    videoPreviewLayer.frame = view.layer.bounds
                    viewFinder.layer.addSublayer(videoPreviewLayer)
                } else {
                    throw CameraControllerError.videoPreivewLayerIsMissing
                }
            } catch {
                print(error)
            }
        }
        
        captureSession?.startRunning()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        if let camera = camera {
            if camera.isFlashAvailable {
                photoSettings.flashMode = .auto
            }
        }
        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func
    func photoOutput(_ output: AVCapturePhotoOutput,
                              didFinishProcessingPhoto photo: AVCapturePhoto,
                              error: Error?) {
        guard let data = photo.fileDataRepresentation(),
            let image =  UIImage(data: data)  else {
                return
        }
        
        self.capturedPhoto.image = image
    }
        
}
