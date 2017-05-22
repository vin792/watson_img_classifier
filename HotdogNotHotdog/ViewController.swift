//
//  ViewController.swift
//  HotdogNotHotdog
//
//  Created by Nicole Zurita on 5/18/17.
//  Copyright © 2017 Nicole Zurita. All rights reserved.
//
// comment

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    //Controller variables
    var imageData: Data?
    
    //IB Outlets
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    //IB Actions
    @IBAction func captureButtonPressed(_ sender: UIButton) {
        didPressTakePhoto()
    }
    
    //Variables
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCapturePhotoOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var image : UIImage?
    
    //View load function
    override func viewDidLoad() {
        super.viewDidLoad()
        captureButton.layer.cornerRadius = 30
        captureButton.clipsToBounds = true
    }
    
    //Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //View appear functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
        
        let camera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        var cameraError : Error?
        var input : AVCaptureDeviceInput?
       
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch {
            cameraError = error
        }
    
        if cameraError == nil && (captureSession?.canAddInput(input))! {
            captureSession?.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()

            if (captureSession?.canAddOutput(stillImageOutput))! {
                captureSession?.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
            }
        }
    }
    
    //Generate photo and set photo settings
    func didPressTakePhoto() {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            stillImageOutput?.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    //AVPhotoCapture Delegate function
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        //Generate photo from video stream
        if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil){
            image = UIImage(data: dataImage)
            imageData = dataImage
            performSegue(withIdentifier: "imageCapturedSegue", sender: nil)
        } else {
            print("Image processing failed")
        }
    }
    
    //Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageCapturedSegue" {
            let controller = segue.destination as! ImageCapturedViewController
            controller.capturedImage = image
            controller.dataImage = imageData
        }
    }
}

