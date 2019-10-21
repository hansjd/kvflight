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
    
    var addresses: [String] = [
        "https://w1.kringvarp.fo/kvf/_definst_/smil:kvf.smil/playlist.m3u8",
        "https://w2.kringvarp.fo/uttanlands/_definst_/smil:uttanlands.smil/playlist.m3u8"
    ]
    
    var address1: String = "https://w1.kringvarp.fo/kvf/_definst_/smil:kvf.smil/playlist.m3u8"
    var address2: String = "https://w2.kringvarp.fo/uttanlands/_definst_/smil:uttanlands.smil/playlist.m3u8"
    
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
        
        tryGetAddress()
    }
    
    @objc func appMovedToBackground() {
    }
    
    @objc func appMovedToForeground() {
        reload();
    }
    
    func tryGetAddress() -> String {
        
        
        for addresse in addresses {
            
            print("Trying " + addresse);
            
            let url = URL(string: addresse)!

            let task = URLSession.shared.dataTask(with: url) {(data, response : URLResponse?, error) in
                
                if(data != nil) {
                    print(data!)
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                }
                
                if(response != nil) {
                    print(response!)
                }
                    
                
                if(error != nil) {
                    print(error!)
                }
            }

            task.resume()
        }
        
        
        
        return address1;
    }
    
    func reload() {
        guard let url = URL(string: "https://w2.kringvarp.fo/uttanlands/_definst_/smil:uttanlands.smil/playlist.m3u8") else {
            return
        }
        avPlayer?.replaceCurrentItem(with: AVPlayerItem(url: url))
        avPlayer?.play()
    }
    
    func initializePlayer() {
        
        guard let url = URL(string: "https://w2.kringvarp.fo/uttanlands/_definst_/smil:uttanlands.smil/playlist.m3u8") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        avPlayer = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
    }
}

