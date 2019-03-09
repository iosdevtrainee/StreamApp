//
//  PlayerView.swift
//  flow
//
//  Created by iosdevrookie on 3/7/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit
import AVFoundation
class PlayerView: UIView {
    private var isPlaying: Bool = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    private func commonInit(){
        setupView()
    }
    
    public var player: AVPlayer? {
        get {
          return playerLayer.player
        } set {
            playerLayer.player = newValue
        }
    }
    
    public var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    
}

extension PlayerView {
    private func setupView(){
        configureTapGesture()
    }
    
    private func setConstraints(){
        
    }
    
    public func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(controlVideo))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func controlVideo(){
        if isPlaying {
            playerLayer.player?.pause()
        } else {
            playerLayer.player?.play()
        }
        isPlaying = !isPlaying
    }
}

