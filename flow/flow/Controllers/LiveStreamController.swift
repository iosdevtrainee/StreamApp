//
//  LiveStreamController.swift
//  flow
//
//  Created by iosdevrookie on 3/8/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit
import LFLiveKit

enum MediaType {
    case video
    case sound
    
    public var avMediaType: AVMediaType {
        switch self {
        case .video: return .video
        case .sound: return .audio
        }
    }
}
class LiveStreamController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMediaAuth(mediaType: .video)
        requestMediaAuth(mediaType: .sound)
        session?.delegate = self
        session?.preView = view
        
    }
    
    //MARK: - Getters and Setters
    lazy var session: LFLiveSession? = {
        let audioConfiguration: LFLiveAudioConfiguration = .default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .high3, outputImageOrientation: .portrait)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session
    }()
    
    //MARK: - Event
    func startStream(session:LFLiveSession?) {
        let stream = LFLiveStreamInfo()
        stream.url = "Enter Live Stream URL HERE"
        session?.startLive(stream)
    }
    
    func stopStream(session:LFLiveSession?) {
        session?.stopLive()
    }
    
    //MARK: - Authorization
    private func requestMediaAuth(mediaType:MediaType){
        let status = AVCaptureDevice.authorizationStatus(for: mediaType.avMediaType)
        switch (mediaType, status) {
        case (_, .notDetermined):
            AVCaptureDevice.requestAccess(for: mediaType.avMediaType) { (success) in
                if success && mediaType == .video {
                    DispatchQueue.main.async {
                        self.session?.running = true
                    }
                }
            }
        case (.video, .authorized):
            DispatchQueue.main.async {
                self.session?.running = true
            }
        case (_, .denied): break
        case (_ ,.restricted): break
        default: break
        }
    }
    
    @IBAction func onRotateCamera(_ sender: UIButton) {
        let devicePositon = session?.captureDevicePosition;
        session?.captureDevicePosition = (devicePositon == .back) ? .front : .back
    }
    
    @IBAction func toggleRecord(_ sender: UIButton) {
        !sender.isSelected ? startStream(session: session) : stopStream(session: session)
        sender.isSelected = !sender.isSelected
    }
    
    
}


extension LiveStreamController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print(debugInfo)
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print(errorCode)
    }
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print(state.rawValue)
        switch state {
//        case .ready: stateLabel.text = "Ready"
//        case .pending: stateLabel.text = "Pending"
//        case .start: stateLabel.text = "Start"
//        case .error: stateLabel.text = "Error"
//        case .stop: stateLabel.text = "Stop"
        default: break
        }
    }
}
