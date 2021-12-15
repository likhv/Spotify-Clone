//
//  NavigationBArs.swift
//  Spotify
//
//  Created by Vladislav Likh on 13/12/21.
//

import Foundation
import SwiftUI

struct CustomBackbutton: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 52)
            Spacer()
        }
    }
}

struct CustomNavigationBar: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var navigationBarHeight: Double = 110.0
    var headerHeight: Double
    var verticalScrollPosition: Double { playerViewModel.scrollPosition }
    var playlistImageName: String { playerViewModel.currentPlaylist.imageFile }
    var playlistMeanColor: Color { UIImage(imageLiteralResourceName: playlistImageName).averageColor! }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(playlistMeanColor)
                    .frame(height: navigationBarHeight)

                HStack(alignment: .center) {
                    Spacer()
                    Text(playerViewModel.currentPlaylist.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 32)
            }
            Spacer()
        }

    }
    func scrollToOpacity(_: Double) -> Double{
        if verticalScrollPosition < navigationBarHeight-headerHeight {
            return 1.0
        } else if verticalScrollPosition < navigationBarHeight-headerHeight+30 {
            return ((navigationBarHeight-headerHeight+30) - verticalScrollPosition) / 30
        } else {
            return 0.0
        }
    }
}

struct NavigationBar: View {
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var playlistName = "Playlist"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.down")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white)
                    .onTapGesture {
                        playerViewModel.switchPlayer()
                    }
                Spacer()
                Text("\(playerViewModel.currentPlaylist.name)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.top, 60)
            Spacer()
        }
    }
}

struct CustomTabView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.spotifyBlack)
                .frame(height: 100)
                .opacity(0.95)
            HStack {
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "house")
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                    Text("Home")
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                    
                }.opacity(0.5)
                Spacer()
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                    Text("Search")
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                    
                }
                Spacer()
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "books.vertical")
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                    Text("Library")
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                    
                }.opacity(0.5)
                Spacer()
            }.padding(.bottom, 20)
        }
    }
}


struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
            .preferredColorScheme(.dark)
            .environmentObject(PlayerViewModel())
    }
}
