//
//  ListView.swift
//  Spotify
//
//  Created by Vladislav Likh on 10/12/21.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var playlistImageName: String { playerViewModel.currentPlaylist.imageFile }
    var playlistMeanColor: Color { UIImage(imageLiteralResourceName: playlistImageName).averageColor! }
    
    var heightOfScreen = UIScreen.main.bounds.height
    var widthOfScreen = UIScreen.main.bounds.width
    var headerHeight = 350.0
    var navigationBarHeight = 110.0
    var verticalScrollPosition: Double { playerViewModel.scrollPosition }
    var gradientEndpoint: Double {
        let point = (heightOfScreen + playerViewModel.scrollPosition) / (heightOfScreen) - 0.5
        if point < 0.1 { return 0.1 }
        else { return point }
        }
    var coverHeight: Double { let height = headerHeight+verticalScrollPosition
        if height < 1 { return 0 }
        else { return height }
    }
    var playButtonOffset: Double {
        if verticalScrollPosition < navigationBarHeight-headerHeight-87 {
            return navigationBarHeight-headerHeight-87
        } else {
            return verticalScrollPosition
        }
    }
    var coverOpacity: Double { coverHeight/headerHeight }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [playlistMeanColor, Color.spotifyBlack]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: gradientEndpoint-0.09))
                .ignoresSafeArea()
            VStack {
                SmallCover()
                    .ignoresSafeArea()
                    .position(x: widthOfScreen/2, y: 140)
                    .frame(height: coverHeight, alignment: .top)
                    .opacity(coverOpacity*coverOpacity)
                Spacer()
            }
            
            TrackListView(headerHeight: headerHeight)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color.spotifyBlack.opacity(0),Color.spotifyBlack.opacity(0.95),Color.spotifyBlack.opacity(1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .frame(height: 100, alignment: .bottom)
            }
            
            
            VStack {
                Spacer()
                PlayerSmallView()
                    .padding(.bottom, 50)
            }
            
            CustomNavigationBar(navigationBarHeight: navigationBarHeight, headerHeight:headerHeight)
                .ignoresSafeArea()
            
            CustomBackbutton()
                .ignoresSafeArea()
            
            PlayButtonScrolled(headerHeight: headerHeight)
                .position(x: widthOfScreen-50, y: headerHeight+40)
                .offset(y: playButtonOffset)
            
            
        }
        .fullScreenCover(isPresented: $playerViewModel.isPlayerVisible) {
            PlayerView()
                .clearModalBackground()
        }
        .background(Color.spotifyBlack)
    }
}


struct SmallCover: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var playlistImageName: String { playerViewModel.currentPlaylist.imageFile }
    
    var body: some View {
        HStack{
            Spacer()
            Image(playlistImageName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .shadow(color: .black.opacity(0.4), radius: 40, x: 0, y: 20)
            Spacer()
        }
    }
}



struct PlayButtonScrolled: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State var isLiked = false
    var headerHeight: Double
    var verticalScrollPosition: Double = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 62, height: 62, alignment: .center)
                .foregroundColor(.green)
            Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 26))
                .foregroundColor(.black)
                .padding(.leading, playerViewModel.isPlaying ? 0 : 2)
                .onTapGesture {
                    playerViewModel.playPause()
                }
        }
    }
}

struct TrackListView: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var headerHeight: Double
//    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader{ geo in
                    Color.clear
//                        .preference(key: WidthKey.self, value: geo.frame(in: .named("scroll")).minY)
//                        .onPreferenceChange(WidthKey.self) {
//                            let go = Double($0!)
//                            playerViewModel.scrollPosition(scrollPositionY: go)
//
//                        }
//                        .onReceive(timer) {
                        .onChange(of: geo.frame(in: .named("scroll")).minY) {
                            _ in playerViewModel.scrollPosition(scrollPositionY: geo.frame(in: .named("scroll")).minY)
                        }
                    
            }
            VStack(spacing: 18) {
                Spacer(minLength: headerHeight-60)
                TrackListHeader(headerHeight: headerHeight)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 2)
                ForEach(playerViewModel.listOfTracks, id: \.id) {track in
                    TrackListItem(track: track)
                }
                .padding(.horizontal, 18)
                Spacer(minLength: 160)
            }
        }
    }
}


struct TrackListHeader: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State var isLiked = false
    var headerHeight: Double
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(playerViewModel.currentPlaylist.text)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .fixedSize(horizontal: false, vertical: true)
//                        .frame(width: 270)
                    
                    HStack {
                        Text("Made for")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(0.5)
                        
                        Text("likh_v")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Text(playerViewModel.currentPlaylist.hours)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.5)
                    
                    HStack(spacing: 30) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 26, weight: .light))
                            .foregroundColor(isLiked ? .green : .white)
                            .padding(.trailing, -10)
                            .opacity(isLiked ? 1 : 0.5)
                        
                        Image(systemName: isLiked ? "arrow.down.circle.fill" : "arrow.down.circle")
                            .font(.system(size: 26, weight: .light))
                            .foregroundColor(isLiked ? .green : .white)
                            .padding(.trailing, -10)
                            .opacity(isLiked ? 1 : 0.5)
                        
                        Image(systemName: "ellipsis")
                            .font(.system(size: 26, weight: .ultraLight))
                            .foregroundColor(isLiked ? .green : .white)
                            .padding(.trailing, -10)
                            .opacity(isLiked ? 1 : 0.5)
                    }.padding(.leading, -2)
                }
                
                Spacer()
            }
        }
    }
}

struct TrackListItem: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var widthOfScreen = UIScreen.main.bounds.width
    var track: Track
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.spotifyBlack.opacity(0))
            HStack(spacing: 11) {
                Image(track.imageFile)
                    .resizable()
                    .frame(width: 55, height: 55)
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(track.title)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    Text("\(track.artist)")
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.6)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.white)
                    .opacity(0.3)
            }
        }
        .onTapGesture {
            playerViewModel.trackByIndex(id: track.id)
        }
    }
}

struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .preferredColorScheme(.dark)
            .environmentObject(PlayerViewModel())
    }
}
