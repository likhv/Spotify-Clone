//
//  ContentView.swift
//  Shared
//
//  Created by Vladislav Likh on 09/12/21.
//

import SwiftUI
import Foundation

struct PlayerView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State var offsetMomentum = 0.0
    var heightOfScreen = UIScreen.main.bounds.height
    var widthOfScreen = UIScreen.main.bounds.width
    var imageName: String { playerViewModel.listOfTracks[playerViewModel.currentTrack].imageFile }
    var coverMeanColor: Color { UIImage(imageLiteralResourceName: imageName).averageColor! }
    
    var body: some View {
        
        ZStack {
            coverMeanColor.ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0), .black]), startPoint: .top, endPoint: .bottom)
                .opacity(0.7)
                .frame(width: widthOfScreen, height: heightOfScreen, alignment: .center)
            VStack(spacing: 8) {
                AlbumCoverView(imageName: imageName, offsetMomentum: $offsetMomentum)
                    .padding(.bottom, 45)
                SongArtistNameView()
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                ProgressBar()
                MultimediaButtons()
            }
            .padding(.horizontal, 26)
            NavigationBar()
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                SharingButtons()
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 52)
            
        }
        .offset(y:offsetMomentum)
        .animation(.spring(), value: offsetMomentum)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 0 {
                        offsetMomentum = gesture.translation.height
                    }
                }
            
                .onEnded { _ in
                    if offsetMomentum > 200 {
                        playerViewModel.switchPlayer()
                    } else {
                        offsetMomentum = 0
                    }
                }
        )
    }
}



struct SharingButtons: View {
    var body: some View {
        HStack(spacing: 40) {
            Image(systemName: "hifispeaker")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .opacity(0.6)
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .opacity(0.6)
            
            Image(systemName: "list.triangle")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .opacity(0.6)
        }
    }
}

struct AlbumCoverView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var imageName: String
    @Binding var offsetMomentum: Double
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.white)
        }
        
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { gesture in
                if gesture.translation.height > 0 {
                    offsetMomentum = gesture.translation.height
                }
            }
            .onEnded { value in
            if offsetMomentum > 200 {
                playerViewModel.switchPlayer()
            } else {
                offsetMomentum = 0
            }
            if value.translation.width > 100{
                playerViewModel.previousTrack()
            } else if value.translation.width < -100 {
                playerViewModel.nextTrack()
            }
//            } else if value.translation.height > 200 {
//                playerViewModel.switchPlayer()
//            }
        })
        
    }
}


struct ProgressBar: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var time = "3:00"
    var widthOfScreen = UIScreen.main.bounds.width
    var currrentTime: Double {playerViewModel.currentTime}
    var duration: Double {Double(Int(playerViewModel.audioPlayer.duration))}
    var part: Double {playerViewModel.part}
    
    var body: some View {
        
        VStack{
            ZStack {
                
                Rectangle()
                    .frame(width: widthOfScreen-50, height: 4)
                    .foregroundColor(.white)
                    .opacity(0.2)
                    .cornerRadius(4)
                
                HStack {
                    Rectangle()
                        .frame(width: ((widthOfScreen-50) * part), height: 4)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .animation(.default)
                    Spacer()
                }
                
                HStack {
                    Circle()
                        .frame(width: 15, height: 15, alignment: .leading)
                        .foregroundColor(.white)
                        .offset(x: ((widthOfScreen-65) * part))
                    Spacer()
                }
            }
            
            HStack {
                Text("\(timeToString(time: currrentTime))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .opacity(0.7)
//                    .onReceive(playerViewModel.timer) { input in
//                            if playerViewModel.isPlaying {
//                                playerViewModel.checkCurrentTime()
//                            }
//                            if currrentTime == duration {
//                                playerViewModel.nextTrack()
//                            }
//                        }
                Spacer()
                Text("-\(timeToString(time: duration-currrentTime))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .opacity(0.7)
                
            }
        }
    }
    func timeToString(time: Double) -> String {
        let currentTime1 = Int(time)
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        return NSString(format: "%02d:%02d", minutes,seconds) as String
    }
}

struct SongArtistNameView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var track: Track { playerViewModel.listOfTracks[playerViewModel.currentTrack] }
    var imageName: String {track.imageFile}
    var songTitle: String {track.title}
    var artistName: String {track.artist}
    var isLiked: Bool {track.isLiked}
    
    var body: some View {
        
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(songTitle)")
                    .lineLimit(1)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                Text("\(artistName)")
                    .lineLimit(1)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .opacity(0.6)
            }
            Spacer()
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 26, weight: .light))
                .foregroundColor(isLiked ? .green : .white)
                .padding(.trailing, -10)
                .opacity(isLiked ? 1 : 0.7)
                .onTapGesture {
                    playerViewModel.likeUnlikeTrack(id: track.id)
                }
        }
    }
}

struct MultimediaButtons: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State var isPlaying = false
    var isShuffle: Bool {playerViewModel.isShuffled}
    var isRepeat: Bool {playerViewModel.isRepeated}
    
    var body: some View {
        
        HStack {
            Image(systemName: "shuffle")
                .font(.system(size: 26, weight: .thin))
                .foregroundColor(isShuffle ? .green : .white)
                .onTapGesture {
                    playerViewModel.shuffleSwitcher()
                }
            Spacer()
            Image(systemName: "backward.end.fill")
                .font(.system(size: 30, weight: .ultraLight))
                .foregroundColor(.white)
                .onTapGesture {
                    playerViewModel.previousTrack()
                }
            Spacer()
            ZStack {
                
                Circle()
                    .frame(width: 70, height: 70, alignment: .center)
                    .foregroundColor(.white)
                
                Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .padding(.leading, playerViewModel.isPlaying ? 0 : 2)
                    .blendMode(.destinationOut)
                    .onTapGesture {
                        playerViewModel.playPause()
                    }
                
            }.compositingGroup()
            Spacer()
            Image(systemName: "forward.end.fill")
                .font(.system(size: 30, weight: .ultraLight))
                .foregroundColor(.white)
                .onTapGesture {
                    playerViewModel.nextTrack()
                }
            
            Spacer()
            Image(systemName: "repeat")
                .font(.system(size: 26, weight: .thin))
                .foregroundColor(isRepeat ? .green : .white)
                .onTapGesture {
                    playerViewModel.repeatSwitcher()
                }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .preferredColorScheme(.dark)
            .environmentObject(PlayerViewModel())
    }
}

