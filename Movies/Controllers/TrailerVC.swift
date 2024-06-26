//
//  TrailerVC.swift
//  Movies
//
//  Created by Prystupa Taras on 26.06.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

class TrailerVC: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!

    var video: MovieVideo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withVideoId: video.key)
        playerView.playVideo()
    }
}
