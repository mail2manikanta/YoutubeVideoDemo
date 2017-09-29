//
//  VideoPlayerViewController.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController {
    
    // Video Player view
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    
    // Identifier of the video
    var videoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the videoplayer with the specified video
        if let videoId = videoId {
            videoPlayerView.load(withVideoId: videoId)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Play Video
        videoPlayerView.playVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop Video
        videoPlayerView.stopVideo()
    }
}
