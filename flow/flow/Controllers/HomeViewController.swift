//
//  PlaylistViewController.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit
import AVKit
class HomeViewController: UIViewController {
    private lazy var playerController = AVPlayerViewController()
    private var videos = [Video]() {
        didSet {
            videosCollection.reloadData()
        }
    }
    @IBOutlet var videosCollection: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        DatabaseManager.shared.fetchAll(collection: .video)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videosCollection.delegate = self
        videosCollection.dataSource = self
        DatabaseManager.shared.delegate = self
    }
    
    
}

extension HomeViewController: DatabaseManagerDelegate {
    func databaseManager(_ databaseManager: DatabaseManager, didReceiveError error: FirebaseError) {
        print(error)
    }
    func databaseManager(_ databaseManager: DatabaseManager, didReceiveDocuments documents: [Document]) {
        videos = documents.map { Video(document: $0) }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let video = videos[indexPath.row]
        let player = AVPlayer(url: video.url)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCell", for: indexPath) as? PlaylistCell else { return UICollectionViewCell() }
        cell.playerView.player = player
        cell.titleLabel.text = video.title
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        let player = AVPlayer(url: video.url)
        playerController.player = player
        present(playerController, animated: true)
    }
}
