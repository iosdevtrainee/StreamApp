//
//  VideoAPIClient.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

protocol VideoAPIClientDelegate {
    func didReceiveData()
    
}

final class VideoAPIClient {
    public func fetchVideo(video:Video){
        NetworkManager.shared.fetch(url:video.url)
    }
}
