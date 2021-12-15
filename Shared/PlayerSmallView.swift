//
//  SmallPlayerView.swift
//  Spotify
//
//  Created by Vladislav Likh on 13/12/21.
//

import SwiftUI

struct PlayerSmallView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var widthOfScreen = UIScreen.main.bounds.width
    var track: Track { playerViewModel.listOfTracks[playerViewModel.currentTrack] }
    var imageName: String {track.imageFile}
    var coverMeanColor: Color { UIImage(imageLiteralResourceName: imageName).averageColor! }
    var currrentTime: Double {playerViewModel.currentTime}
    var duration: Double {Double(Int(playerViewModel.audioPlayer.duration))}
    var part: Double {playerViewModel.part}
    
    var body: some View{
        ZStack {
            
            Rectangle()
                .foregroundColor(coverMeanColor)
                .cornerRadius(6)
            
            HStack(spacing: 10) {
                Image(imageName)
                    .resizable()
                    .frame(width: 42, height: 42)
                    .cornerRadius(3)
                VStack(alignment: .leading, spacing: 1) {
                    Text("\(track.title)")
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                    Text("\(track.artist)")
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.6)
                }
                Spacer()
                
                Image(systemName: "hifispeaker")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(.white)
                    .padding(.trailing, playerViewModel.isPlaying ? 3 : 0)
                    .opacity(0.6)
                    .padding(.trailing)
                
                Image(systemName: playerViewModel.isPlaying ?  "pause.fill" : "play.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .padding(.leading, playerViewModel.isPlaying ? 0 : 2)
                    .padding(.trailing, 12)
                    .onTapGesture {
                        playerViewModel.playPause()
                    }
            }.padding(.horizontal, 10)
            
            
            HStack(spacing:0) {
                
                Rectangle()
                    .frame(width: (widthOfScreen-37) * part, height: 2)
                    .foregroundColor(.white)
                    .opacity(0.8)
                
                Rectangle()
                    .frame(width: (widthOfScreen-37) * (1-part), height: 2)
                    .foregroundColor(.white)
                    .opacity(0.4)
                    .onReceive(playerViewModel.timer) { input in
                            if playerViewModel.isPlaying {
                                playerViewModel.checkCurrentTime()
                            }
                            if currrentTime == duration {
                                playerViewModel.nextTrack()
                            }
                        }
            }.offset(y: 29)
            
        }.frame(width:  widthOfScreen-16, height: 60)
        
            .onTapGesture {
                playerViewModel.switchPlayer()
            }
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                if value.translation.width > 50{
                    playerViewModel.previousTrack()
                } else if value.translation.width < -50 {
                    playerViewModel.nextTrack()
                } else if value.translation.height < -50 {
                    playerViewModel.switchPlayer()
                }
            })
        
    }
}

struct PlayerSmallView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerSmallView()
            .preferredColorScheme(.dark)
            .environmentObject(PlayerViewModel())
    }
}
