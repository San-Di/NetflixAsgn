//
//  PlayTrailerViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/10/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class PlayTrailerViewController: UIViewController {

    @IBOutlet weak var playerMovieTrailer: WKYTPlayerView!
    
    var videoKey: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let key = videoKey else{ return }
        playerMovieTrailer.load(withVideoId: key)
        
    }
    
}
