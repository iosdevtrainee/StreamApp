//
//  StreamViewController.swift
//  flow
//
//  Created by iosdevrookie on 3/4/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit
import AVFoundation

class StreamViewController: UIViewController {
    @IBOutlet weak var previewView: PreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.session = session
        bufferedOutput.setSampleBufferDelegate(self, queue: bufferQueue)
    }
    
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
                                                                               mediaType: .video, position: .unspecified)
    private var isSessionRunning = false
    public let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue") // Communicate with the session and other session objects on this queue.
//    private var setupResult: SessionSetupResult = .success
    private let bufferQueue = DispatchQueue(label: "buffer queue")
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private let movieFileOutput = AVCaptureMovieFileOutput()
    private let bufferedOutput = AVCaptureVideoDataOutput()
//    private var movieFileOutput: AVCaptureMovieFileOutput?
    
    private var backgroundRecordingID: UIBackgroundTaskIdentifier?

    // Call this on the session queue.
    /// - Tag: ConfigureSession
    private func configureSession() {
//        if setupResult != .success {
//            return
//        }
        
        session.beginConfiguration()
        
        /*
         We do not create an AVCaptureMovieFileOutput when setting up the session because
         Live Photo is not supported when AVCaptureMovieFileOutput is added to the session.
         */
        session.sessionPreset = .high
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the back dual camera if available, otherwise default to a wide angle camera.
            
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                // If a rear dual camera is not available, default to the rear wide angle camera.
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // In the event that the rear wide angle camera isn't available, default to the front wide angle camera.
                defaultVideoDevice = frontCameraDevice
            }
            guard let videoDevice = defaultVideoDevice else {
                print("Default video device is unavailable.")
//                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                DispatchQueue.main.async {
                    /*
                     Dispatch video streaming to the main queue because AVCaptureVideoPreviewLayer is the backing layer for PreviewView.
                     You can manipulate UIView only on the main thread.
                     Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
                     on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                     
                     Use the status bar orientation as the initial video orientation. Subsequent orientation changes are
                     handled by CameraViewController.viewWillTransition(to:with:).
                     */
                    let statusBarOrientation = UIApplication.shared.statusBarOrientation
                    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                    if statusBarOrientation != .unknown {
                        if let videoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue) {
                            initialVideoOrientation = videoOrientation
                        }
                    }
                    
                    self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
                }
            } else {
                print("Couldn't add video device input to the session.")
//                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Couldn't create video device input: \(error)")
//            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        // Add audio input.
        do {
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if session.canAddInput(audioDeviceInput) {
                session.addInput(audioDeviceInput)
            } else {
                print("Could not add audio device input to the session")
            }
        } catch {
            print("Could not create audio device input: \(error)")
        }
        
        // Add photo output.
//        if session.canAddOutput(photoOutput) {
//            session.addOutput(photoOutput)
//
//            photoOutput.isHighResolutionCaptureEnabled = true
//            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
//            photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
//            photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
//            livePhotoMode = photoOutput.isLivePhotoCaptureSupported ? .on : .off
//            depthDataDeliveryMode = photoOutput.isDepthDataDeliverySupported ? .on : .off
//            portraitEffectsMatteDeliveryMode = photoOutput.isPortraitEffectsMatteDeliverySupported ? .on : .off
//
//        } else {
//            print("Could not add photo output to the session")
//            setupResult = .configurationFailed
//            session.commitConfiguration()
//            return
//        }
        
        session.commitConfiguration()
    }
    
    

//    if session.canAddOutput(movieFileOutput) {
//    self.session.beginConfiguration()
//    self.session.addOutput(movieFileOutput)
//    self.session.sessionPreset = .high
//    if let connection = movieFileOutput.connection(with: .video) {
//    if connection.isVideoStabilizationSupported {
//    connection.preferredVideoStabilizationMode = .auto
//        }
//    }
//    self.session.commitConfiguration()
//
//    DispatchQueue.main.async {
//        captureModeControl.isEnabled = true
//    }
//
//    self.movieFileOutput = movieFileOutput
//
//    DispatchQueue.main.async {
//        self.recordButton.isEnabled = true
//    }
//    }
//sessionQueue.async {
//    let currentVideoDevice = self.videoDeviceInput.device
//    let currentPosition = currentVideoDevice.position
//
//    let preferredPosition: AVCaptureDevice.Position
//    let preferredDeviceType: AVCaptureDevice.DeviceType
//
//    switch currentPosition {
//    case .unspecified, .front:
//        preferredPosition = .back
//        preferredDeviceType = .builtInDualCamera
//
//    case .back:
//        preferredPosition = .front
//        preferredDeviceType = .builtInTrueDepthCamera
//    }
//    let devices = self.videoDeviceDiscoverySession.devices
//    var newVideoDevice: AVCaptureDevice? = nil
    
    // First, seek a device with both the preferred position and device type. Otherwise, seek a device with only the preferred position.
//    if let device = devices.first(where: { $0.position == preferredPosition && $0.deviceType == preferredDeviceType }) {
//        newVideoDevice = device
//    } else if let device = devices.first(where: { $0.position == preferredPosition }) {
//        newVideoDevice = device
//    }
//
//    if let videoDevice = newVideoDevice {
//        do {
//            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
//
//            self.session.beginConfiguration()
    
            // Remove the existing device input first, since the system doesn't support simultaneous use of the rear and front cameras.
//            self.session.removeInput(self.videoDeviceInput)
//
//            if self.session.canAddInput(videoDeviceInput) {
//                NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: currentVideoDevice)
//                NotificationCenter.default.addObserver(self, selector: #selector(self.subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: videoDeviceInput.device)
//
//                self.session.addInput(videoDeviceInput)
//                self.videoDeviceInput = videoDeviceInput
//            } else {
//                self.session.addInput(self.videoDeviceInput)
//            }
//            if let connection = self.movieFileOutput?.connection(with: .video) {
//                if connection.isVideoStabilizationSupported {
//                    connection.preferredVideoStabilizationMode = .auto
//                }
//            }
    
            /*
             Set Live Photo capture and depth data delivery if it is supported. When changing cameras, the
             `livePhotoCaptureEnabled and depthDataDeliveryEnabled` properties of the AVCapturePhotoOutput gets set to NO when
             a video device is disconnected from the session. After the new video device is
             added to the session, re-enable them on the AVCapturePhotoOutput if it is supported.
             */
//            self.photoOutput.isLivePhotoCaptureEnabled = self.photoOutput.isLivePhotoCaptureSupported
//            self.photoOutput.isDepthDataDeliveryEnabled = self.photoOutput.isDepthDataDeliverySupported
//            self.photoOutput.isPortraitEffectsMatteDeliveryEnabled = self.photoOutput.isPortraitEffectsMatteDeliverySupported
//
//            self.session.commitConfiguration()
//        } catch {
//            print("Error occurred while creating video device input: \(error)")
//        }
//    }
//
//    DispatchQueue.main.async {
//        self.cameraButton.isEnabled = true
//        self.recordButton.isEnabled = self.movieFileOutput != nil
//        self.photoButton.isEnabled = true
//        self.livePhotoModeButton.isEnabled = true
//        self.captureModeControl.isEnabled = true
//        self.depthDataDeliveryButton.isEnabled = self.photoOutput.isDepthDataDeliveryEnabled
//        self.depthDataDeliveryButton.isHidden = !self.photoOutput.isDepthDataDeliverySupported
//        self.portraitEffectsMatteDeliveryButton.isEnabled = self.photoOutput.isPortraitEffectsMatteDeliveryEnabled
//        self.portraitEffectsMatteDeliveryButton.isHidden = !self.photoOutput.isPortraitEffectsMatteDeliverySupported
//    }
//}
//}
    @objc
    private func focusAndExposeTap(_ gestureRecognizer: UITapGestureRecognizer) {
    let devicePoint = previewView.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: gestureRecognizer.location(in: gestureRecognizer.view))
    focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
}

private func focus(with focusMode: AVCaptureDevice.FocusMode,
                   exposureMode: AVCaptureDevice.ExposureMode,
                   at devicePoint: CGPoint,
                   monitorSubjectAreaChange: Bool) {

    sessionQueue.async {
        let device = self.videoDeviceInput.device
        do {
            try device.lockForConfiguration()

            /*
             Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
             Call set(Focus/Exposure)Mode() to apply the new point of interest.
             */
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                device.focusPointOfInterest = devicePoint
                device.focusMode = focusMode
            }

            if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                device.exposurePointOfInterest = devicePoint
                device.exposureMode = exposureMode
            }

            device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
            device.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
        }
    }
}


//
private func toggleMovieRecording(_ recordButton: UIButton) {
//    guard let movieFileOutput = self.movieFileOutput else {
//        return
//}
//}
    /*
     Disable the Camera button until recording finishes, and disable
     the Record button until recording starts or finishes.
     
     See the AVCaptureFileOutputRecordingDelegate methods.
     */
//    cameraButton.isEnabled = false
//    recordButton.isEnabled = false
//    captureModeControl.isEnabled = false

    let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation

    sessionQueue.async {
        if !self.movieFileOutput.isRecording {
            if UIDevice.current.isMultitaskingSupported {
                self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            }
    
//             Update the orientation on the movie file output video connection before recording.
            let movieFileOutputConnection = self.movieFileOutput.connection(with: .video)
            movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation!

            let availableVideoCodecTypes = self.movieFileOutput.availableVideoCodecTypes

            if availableVideoCodecTypes.contains(.hevc) {
                self.movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
            }

//             Start recording video to a temporary file.
            let outputFileName = UUID().uuidString
            let filePath = NSTemporaryDirectory()
            guard let fileURL = URL(string: filePath)?
                .appendingPathComponent(outputFileName)
                .appendingPathExtension("mov") else { return }
//            let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
//            movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
//        } else {
//            movieFileOutput.stopRecording()
//        }
            self.movieFileOutput.startRecording(to: fileURL, recordingDelegate: self)
        } else {
            self.movieFileOutput.stopRecording()
        }

    }
}

/// - Tag: DidStartRecording
//func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    // Enable the Record button to let the user stop recording.
//    DispatchQueue.main.async {
//        self.recordButton.isEnabled = true
//        self.recordButton.setImage(#imageLiteral(resourceName: "CaptureStop"), for: [])
//    }
//}

/// - Tag: DidFinishRecording
//func fileOutput(_ output: AVCaptureFileOutput,
//                didFinishRecordingTo outputFileURL: URL,
//                from connections: [AVCaptureConnection],
//                error: Error?) {
    // Note: Since we use a unique file path for each recording, a new recording won't overwrite a recording mid-save.
//    func cleanup() {
//        let path = outputFileURL.path
//        if FileManager.default.fileExists(atPath: path) {
//            do {
//                try FileManager.default.removeItem(atPath: path)
//            } catch {
//                print("Could not remove file at url: \(outputFileURL)")
//            }
//        }
//
//        if let currentBackgroundRecordingID = backgroundRecordingID {
//            backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
//
//            if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
//                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
//            }
//        }
//    }
    
//    var success = true
//
//    if error != nil {
//        print("Movie file finishing error: \(String(describing: error))")
//        success = (((error! as NSError).userInfo[AVErrorRecordingSuccessfullyFinishedKey] as AnyObject).boolValue)!
//    }
//
//    if success {
        // Check authorization status.
//        PHPhotoLibrary.requestAuthorization { status in
//            if status == .authorized {
//                // Save the movie file to the photo library and cleanup.
//                PHPhotoLibrary.shared().performChanges({
//                    let options = PHAssetResourceCreationOptions()
//                    options.shouldMoveFile = true
//                    let creationRequest = PHAssetCreationRequest.forAsset()
//                    creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
//                }, completionHandler: { success, error in
//                    if !success {
//                        print("AVCam couldn't save the movie to your photo library: \(String(describing: error))")
//                    }
//                    cleanup()
//                }
//                )
//            } else {
//                cleanup()
//            }
//        }
//    } else {
//        cleanup()
//    }
    
    // Enable the Camera and Record buttons to let the user switch camera and start another recording.
//    DispatchQueue.main.async {
        // Only enable the ability to change camera if the device has more than one camera.
//        self.cameraButton.isEnabled = self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1
//        self.recordButton.isEnabled = true
//        self.captureModeControl.isEnabled = true
//        self.recordButton.setImage(#imageLiteral(resourceName: "CaptureVideo"), for: [])
//    }
}

extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
    
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
}

extension AVCaptureDevice.DiscoverySession {
    var uniqueDevicePositionsCount: Int {
        var uniqueDevicePositions: [AVCaptureDevice.Position] = []
        
        for device in devices {
            if !uniqueDevicePositions.contains(device.position) {
                uniqueDevicePositions.append(device.position)
            }
        }
        
        return uniqueDevicePositions.count
    }
}

extension StreamViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
}

extension StreamViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(imageBuffer, [])
            let numOfBytes = CVPixelBufferGetBytesPerRow(imageBuffer)
            let buffer = CVPixelBufferGetBaseAddress(imageBuffer)
        }
        
    }
}
