//
//  RatingIndicator.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/04.
//

import SwiftUI

struct RatingIndicator: View {
    
    var score: Int
    var ratingString: String {
        if score % 2 == 0 {
            return String(score/2)
        } else {
            return String(format: "%.1f", Double(score)/2)
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text("rating")
                .font(.theme.subHeadline)
                .foregroundColor(.theme.tertiary)
            Text("\(ratingString) / 5")
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
    }
}
