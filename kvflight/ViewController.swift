//
//  ViewController.swift
//  kvflight
//
//  Created by Bartal Clementsen on 10/9/19.
//  Copyright © 2019 bartalclementsen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    var avplayerVC : AVPlayerViewController?
    var avPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializePlayer()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avPlayer!.play()
    }
    
    @objc func appMovedToBackground() {
    }
    
    @objc func appMovedToForeground() {
        reload();
    }
    
    func reload() {
        guard let url = URL(string: "https://w1.kringvarp.fo/kvf/_definst_/smil:kvf.smil/playlist.m3u8") else {
            return
        }
        avPlayer?.replaceCurrentItem(with: AVPlayerItem(url: url))
        avPlayer?.play()
    }
    
    func initializePlayer() {
        
        guard let url = URL(string: "https://w1.kringvarp.fo/kvf/_definst_/smil:kvf.smil/playlist.m3u8") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        avPlayer = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
    }
}

