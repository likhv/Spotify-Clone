//
//  PlayerModelView.swift
//  Spotify
//
//  Created by Vladislav Likh on 10/12/21.
//

import Foundation
import AVFoundation
import SwiftUI

struct Track: Identifiable {
    var id = UUID()
    var artist: String
    var title: String
    var album: String
    var audioFile: String
    var imageFile: String
    var isLiked: Bool = false
}

struct Playlist: Identifiable {
    var id = UUID()
    var name: String
    var text: String
    var hours: String
    var imageFile: String
    var isLiked: Bool = false
}

final class PlayerViewModel: ObservableObject {
    
    @Published var activeSongColor: Color = Color(.systemGray4)
    @Published var playingProgress = 0.2
    @Published var scrollPosition: Double = 0.0
    @Published var isPlaying = false
    @Published var isRepeated = false
    @Published var isShuffled = false
    @Published var isPlayerVisible = false
    @Published var headerHeight = 350.0
    @Published var navigationBarHeight = 110.0
    @Published var currentTime: Double = 0.0
    @Published var part: Double = 0.0
    @Published var audioPlayer = AVAudioPlayer()
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    @Published var currentTrack = 0
    @Published var currentPlaylist = Playlist(name: "Nodding heads", text: "New feature: persons on these tracks' covers are nodding their heads in the rhythm of a song", hours: "2h 20m", imageFile: "NoddingHeads")
    
    @Published var listOfTracks = [
        Track(artist: "Billie Eilish", title: "Getting older", album: "Happier than ever", audioFile: "Billie Eilish - Getting Older.mp3", imageFile: "Billie_Eilish-Happier_than_ever"),
        Track(artist: "Dawn Richard", title: "Nostalgia", album: "Second line", audioFile: "Dawn_Richard_-_Nostalgiacom.mp3", imageFile: "Dawn_Richard-Second_line"),
        Track(artist: "Girl in Red", title: "Body and mind", album: "If I Could Make It Go Quiet", audioFile: "girl_in_red_-_Body_And_Mind.mp3", imageFile: "Girl_in_Red-If_I_Could_Make_It_Go_Quiet"),
        Track(artist: "Janelle Monae", title: "Dirty Computer", album: "Dirty Computer", audioFile: "janelle-monae-dirty-computer.mp3", imageFile: "Janelle_Monae-Dirty_Computer"),
        Track(artist: "Janelle Monae", title: "Suite II Overture", album: "Electric Lad", audioFile: "Janelle Monae - Suite II Overture.mp3", imageFile: "Janelle_Monae-Electric_Lady"),
        Track(artist: "Joy Oladokun", title: "Sunday", album: "In Defense of My Own Happiness", audioFile: "Joy_Oladokun_-_sunday_(rum.muzikavsem.org).mp3", imageFile: "Joy_Oladokun-In_Defense_of_My_Own_Happiness"),
        
        Track(artist: "Billie Eilish", title: "Getting older", album: "Happier than ever", audioFile: "Billie Eilish - Getting Older.mp3", imageFile: "Billie_Eilish-Happier_than_ever"),
        Track(artist: "Dawn Richard", title: "Nostalgia", album: "Second line", audioFile: "Dawn_Richard_-_Nostalgiacom.mp3", imageFile: "Dawn_Richard-Second_line"),
        Track(artist: "Girl in Red", title: "Body and mind", album: "If I Could Make It Go Quiet", audioFile: "girl_in_red_-_Body_And_Mind.mp3", imageFile: "Girl_in_Red-If_I_Could_Make_It_Go_Quiet"),
        Track(artist: "Janelle Monae", title: "Dirty Computer", album: "Dirty Computer", audioFile: "janelle-monae-dirty-computer.mp3", imageFile: "Janelle_Monae-Dirty_Computer"),
        Track(artist: "Janelle Monae", title: "Suite II Overture", album: "Electric Lad", audioFile: "Janelle Monae - Suite II Overture.mp3", imageFile: "Janelle_Monae-Electric_Lady"),
        Track(artist: "Joy Oladokun", title: "Sunday", album: "In Defense of My Own Happiness", audioFile: "Joy_Oladokun_-_sunday_(rum.muzikavsem.org).mp3", imageFile: "Joy_Oladokun-In_Defense_of_My_Own_Happiness"),
        
        Track(artist: "Billie Eilish", title: "Getting older", album: "Happier than ever", audioFile: "Billie Eilish - Getting Older.mp3", imageFile: "Billie_Eilish-Happier_than_ever"),
        Track(artist: "Dawn Richard", title: "Nostalgia", album: "Second line", audioFile: "Dawn_Richard_-_Nostalgiacom.mp3", imageFile: "Dawn_Richard-Second_line"),
        Track(artist: "Girl in Red", title: "Body and mind", album: "If I Could Make It Go Quiet", audioFile: "girl_in_red_-_Body_And_Mind.mp3", imageFile: "Girl_in_Red-If_I_Could_Make_It_Go_Quiet"),
        Track(artist: "Janelle Monae", title: "Dirty Computer", album: "Dirty Computer", audioFile: "janelle-monae-dirty-computer.mp3", imageFile: "Janelle_Monae-Dirty_Computer"),
        Track(artist: "Janelle Monae", title: "Suite II Overture", album: "Electric Lad", audioFile: "Janelle Monae - Suite II Overture.mp3", imageFile: "Janelle_Monae-Electric_Lady"),
        Track(artist: "Joy Oladokun", title: "Sunday", album: "In Defense of My Own Happiness", audioFile: "Joy_Oladokun_-_sunday_(rum.muzikavsem.org).mp3", imageFile: "Joy_Oladokun-In_Defense_of_My_Own_Happiness"),]
    
    
    func nextTrack() {
        if isShuffled {
            currentTrack = Int.random(in: 0...listOfTracks.count-1)
        } else {
            currentTrack += 1
            if currentTrack > listOfTracks.count-1 {
                if isRepeated {
                    currentTrack = 0
                } else {
                    currentTrack = listOfTracks.count-1
                }
            }
        }
        prepareSound(soundfile: listOfTracks[currentTrack].audioFile)
        audioPlayer.play()
        isPlaying = true
    }
    
    func previousTrack() {
        if isShuffled {
            currentTrack = Int.random(in: 0...listOfTracks.count-1)
        } else {
            currentTrack -= 1
            if currentTrack < 0 {
                if isRepeated {
                    currentTrack = listOfTracks.count-1
                } else {
                    currentTrack = 0
                }
            }
        }
        prepareSound(soundfile: listOfTracks[currentTrack].audioFile)
        audioPlayer.play()
        isPlaying = true
    }
    
    func likeUnlikeTrack(id: UUID) {
        guard let index = listOfTracks.firstIndex(where: { $0.id == id }) else { return }
        listOfTracks[index].isLiked.toggle()
    }
    
    func likeUnlikePlaylist() {
        currentPlaylist.isLiked.toggle()
    }
    
    func switchPlayer() {
        isPlayerVisible.toggle()
    }
    
    func shuffleSwitcher() {
        isShuffled.toggle()
    }
    
    func repeatSwitcher() {
        isRepeated.toggle()
    }
        
    func scrollPosition(scrollPositionY: Double) {
        scrollPosition = scrollPositionY
    }
    
    func trackByIndex(id: UUID) {
        guard let index = listOfTracks.firstIndex(where: { $0.id == id }) else { return }
        currentTrack = index
        prepareSound(soundfile: listOfTracks[currentTrack].audioFile)
        audioPlayer.play()
        isPlaying = true
    }
    
    func playButtonPosition(scrollPosition: Double, offset: Double) -> Double {
        if scrollPosition < navigationBarHeight-headerHeight-offset {
            return navigationBarHeight-headerHeight-scrollPosition-offset
        } else {
            return 0.0
        }
    }
    
    func coverSize(scrollPosition: Double, headerHeight: Double) -> Double {
        let size = headerHeight + scrollPosition
        if size < 0 {
            return 0
        } else {
            return size
        }
    }
    func coverOpacity(scrollPosition: Double, headerHeight: Double) -> Double {
        let opacity = headerHeight / scrollPosition / -20
        if opacity < 0 {
            return 1.0
        }else if opacity < 0.1 {
            return 0.0
        } else if opacity > 1{
            return 1.0
        } else {
            return opacity
        }
    }
    
    func prepareSound(songName: String) {
        prepareSound(soundfile: listOfTracks[currentTrack].audioFile)
    }

    func playPause() {
        if isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
        isPlaying.toggle()

    }

    func prepareSound(soundfile: String) {

        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){

            do{

                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer.prepareToPlay()

            } catch {
                print("Error")
            }
        }
    }
    

    func tabViewClosingOffset(scroll: Double) -> Double {
        if scroll >= 0 {
            return -scroll
        } else if scroll < -110 {
            return 110-scroll
        } else {
            return -scroll*2
        }
    }
    
    func playerOffset(scroll: Double) -> Double {
        if scroll >= 0 {
            return -scroll
        } else if scroll < -60 {
            return 60-scroll
        } else {
            return -scroll*2
        }
    }
    
    func checkCurrentTime() {
        currentTime = Double(Int(audioPlayer.currentTime))
        part = currentTime / (Double(Int(audioPlayer.duration)) + 0.01)
    }
    
}
