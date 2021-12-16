//
//  Animation.swift
//  Spotify
//
//  Created by Vlad Likh on 16.12.2021.
//
import SwiftUI

struct AnimatedSequence: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State var currentFrame: Int = 0
    var endedFrame: Int = 45
    var name: String { playerViewModel.listOfTracks[playerViewModel.currentTrack].animationFile }
//    var name = "girl"
    var timerAnimation = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Image("\(name)\(currentFrame)")
            .resizable()
            .scaledToFit()
            .onReceive(timerAnimation){
                _ in
                if playerViewModel.isPlaying {
                    if currentFrame < endedFrame-1 {
                        currentFrame += 1
                    } else {
                        currentFrame = 0
                    }
                }
            }
    }
}


struct AnimatedSequence_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedSequence()
            .preferredColorScheme(.dark)
            .environmentObject(PlayerViewModel())
    }
}
