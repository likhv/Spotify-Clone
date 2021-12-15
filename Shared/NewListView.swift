//
//  NewListView.swift
//  Spotify
//
//  Created by Vladislav Likh on 14/12/21.
//

import SwiftUI

struct NewListView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var playlistImageName: String { playerViewModel.currentPlaylist.imageFile }
    var currentSongFile: String { playerViewModel.listOfTracks[playerViewModel.currentTrack].audioFile }
    var playlistMeanColor: Color { UIImage(imageLiteralResourceName: playlistImageName).averageColor! }
    var headerHeight = 370.0
    var navigationBarHeight = 110.0
    var heightOfScreen = UIScreen.main.bounds.height
    var widthOfScreen = UIScreen.main.bounds.width
    var playButtonPosition: Double { headerHeight-335 }
    
    var body: some View {
        ZStack {
            
            VStack {
                playlistMeanColor
                Color.spotifyBlack
            }
            .frame(width: widthOfScreen, height: heightOfScreen, alignment: .center)
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [playlistMeanColor, Color.spotifyBlack]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 0.24))

                    VStack(spacing: 18) {
                        Spacer(minLength: headerHeight-60)
                        TrackListHeader(headerHeight: headerHeight)
                            .padding(.horizontal, 18)
                            .padding(.bottom, 10)
                        
                        ForEach(playerViewModel.listOfTracks, id: \.id) {track in
                            TrackListItem(track: track)
                        }
                        .padding(.horizontal, 18)
                        Spacer(minLength: 160)
                    }
                    

                    
                    GeometryReader{ geo in
                        VStack(alignment: .center) {
                            Spacer()
                            SmallCover()
                                .padding(.top, 10)
                                .padding(.vertical, 40)
                                .padding(.horizontal, 40)
                                .opacity(playerViewModel.coverOpacity(scrollPosition: geo.frame(in: .named("scroll")).minY, headerHeight: headerHeight))
                                .offset(y: -geo.frame(in: .named("scroll")).minY*1.2)
                            Spacer()
                        }
                        .frame(height: playerViewModel.coverSize(scrollPosition: geo.frame(in: .named("scroll")).minY, headerHeight: headerHeight))
                        
              
                        CustomNavigationBar(headerHeight: headerHeight)
                            .ignoresSafeArea()
                            .offset(y: -geo.frame(in: .named("scroll")).minY)
                            .opacity(1-(headerHeight+geo.frame(in: .named("scroll")).minY)/headerHeight)
         
                        
                        PlayButtonScrolled(headerHeight: headerHeight)
                            .position(x: widthOfScreen-48, y: headerHeight+playButtonPosition+30)
                            .offset(y: playerViewModel.playButtonPosition(scrollPosition: geo.frame(in: .named("scroll")).minY, offset: playButtonPosition+50))
                    
                        LinearGradient(gradient: Gradient(colors: [Color.spotifyBlack.opacity(0),Color.spotifyBlack.opacity(0.8),Color.spotifyBlack.opacity(1)]), startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                            .frame(height: 100, alignment: .bottom)
                            .position(x: widthOfScreen/2, y: heightOfScreen-50)
                            .offset(y: -geo.frame(in: .named("scroll")).minY)
                    
                        CustomTabView()
                            .position(x: widthOfScreen/2, y: heightOfScreen-50)
                            .offset(y: playerViewModel.tabViewClosingOffset(scroll: geo.frame(in: .named("scroll")).minY))
                        
                        PlayerSmallView()
                            .position(x: widthOfScreen/2, y: heightOfScreen-130)
                            .offset(y: playerViewModel.playerOffset(scroll: geo.frame(in: .named("scroll")).minY))
                    }
                }
            }.ignoresSafeArea()
            CustomBackbutton()
            
           
            
          
        }.fullScreenCover(isPresented: $playerViewModel.isPlayerVisible) {
            PlayerView()
                .clearModalBackground()
        }
        .onAppear() {
            playerViewModel.prepareSound(songName: currentSongFile)
        }
    }
}




struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewListView()
            .preferredColorScheme(.dark)
            .environmentObject(PlayerViewModel())
    }
}
