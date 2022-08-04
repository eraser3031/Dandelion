//
//  RatingStepper.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/04.
//

import SwiftUI

struct RatingStepper: View {
    
    var showRatingSheet: Bool
    var id: Namespace.ID
    
    var body: some View {
        HStack(spacing: 22) {
            ForEach(-2..<3) { i in
                Image.star
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .matchedGeometryEffect(id: "rating\(i)", in: id)
                    .foregroundColor(.theme.quaternary)
                    .offset(y: !showRatingSheet ? CGFloat(abs(i)) == 1 ? 20 : CGFloat(abs(i)) == 2 ? 66 : 0 : 0)
                    .offset(x: !showRatingSheet ? CGFloat(abs(i)) == 1 ? 12*CGFloat(i) : 0 : 0)
            }
        }
    }
}
