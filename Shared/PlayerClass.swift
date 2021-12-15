//
//  PlayerClass.swift
//  Spotify
//
//  Created by Vladislav Likh on 15/12/21.
//

import Combine
import AVFoundation

class PlayerTimeObserver {
  let publisher = PassthroughSubject<TimeInterval, Never>()
  private var timeObservation: Any?
  
  init(player: AVPlayer) {
    // Periodically observe the player's current time, whilst playing
    timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
      guard let self = self else { return }
      // Publish the new player time
      self.publisher.send(time.seconds)
    }
  }
}
//import AVFoundation
//
//class Sounds {
//    
//    static var audioPlayer: AVAudioPlayer? = PlayerViewModel.audioPlayer
//    
//    static func prepareSound(soundfile: String) {
//        
//        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
//            
//            do{
//                
//                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//                audioPlayer?.prepareToPlay()
//                
//            } catch {
//                print("Error")
//            }
//        }
//    }
//    
//    static func pause() {
//        audioPlayer?.pause()
//    }
//    
//    static func play() {
//        audioPlayer?.play()
//    }
//    
//    static func currentTime() -> Double {
//        return audioPlayer?.currentTime ?? 0
//    }
//    static func duration() -> Double {
//        return audioPlayer?.duration ?? 0
//    }
//}
