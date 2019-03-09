//
//  VideoViewController.swift
//  flow
//
//  Created by iosdevrookie on 3/2/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit
import AVKit
class VideoViewController: UIViewController {
    private var imagePickerController = UIImagePickerController()
    private let avController = AVPlayerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        StorageManager.shared.delegate = self
    }
    
    

    @IBAction func showPhotoLibrary(_ sender: UIBarButtonItem) {
        present(imagePickerController,animated: true)
    }
    

}

extension VideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("url is \(videoURL)")
            let video = Video(url: videoURL, ownerId: "", title: "")
            let user = User(email: "test@aol.com")
            StorageManager.shared.store(video: video, user: user, contentType: .video)
            dismiss(animated: true)
        }
        
    }
}

extension VideoViewController: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension VideoViewController: StorageManagerDelegate {
    func storageManager(_ storageManager: StorageManager, didReceiveError error: FirebaseError) {
        print(error)
    }
    
    func storageManager(_ storageManager: StorageManager, didReceiveURL url: URL) {
        print(url)
        let player = AVPlayer(url: url)
        avController.player = player
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yy HH:mm:ss"
        let dateString = formatter.string(from: date)
        let user = User(email: "test@aol.com")
        let video = Video(url: url, ownerId: user.id, title: dateString)
        DatabaseManager.shared.create(storable: video)
    }
}

extension VideoViewController: DatabaseManagerDelegate {
    func databaseManager(_ databaseManager: DatabaseManager, didReceiveError error: FirebaseError) {
        print(error)
    }
    func databaseManager(_ databaseManager: DatabaseManager, didCreateDocument id: DocumentID) {
        print(id)
    }
    
    
}
