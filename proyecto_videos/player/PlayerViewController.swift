//
//  PlayerViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 7/05/24.
//

import UIKit
import YouTubePlayer_Swift
import youtube_ios_player_helper

class PlayerViewController: UIViewController, YTPlayerViewDelegate {
        
    var bean:Clase!
    @IBOutlet weak var player: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        player.load(withVideoId:bean.enlace)
    }
    

}
extension ViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
