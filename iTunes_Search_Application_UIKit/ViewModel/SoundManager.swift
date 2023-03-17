//
//  SoundManager.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/15.
//

import Foundation
import AVFAudio
import AVFoundation

class SoundManager : ObservableObject {
    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            let playerItem = AVPlayerItem(url: url)
            queuePlayer = AVQueuePlayer(playerItem: playerItem)
            playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        }
    }
}
