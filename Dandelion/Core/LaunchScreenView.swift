//
//  LaunchScreenView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/02.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        GeometryReader { geo in
            Image.splash
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
            
            Image.logo
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 64, height: 64)
                .foregroundColor(.white)
                .position(x: geo.size.width/2, y: geo.size.height/2)
        }
        .ignoresSafeArea()
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
