//
//  RatingIndicator.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/04.
//

import SwiftUI

struct RatingIndicator: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("rating")
                .font(.theme.subHeadline)
                .foregroundColor(.theme.tertiary)
            Text("3 / 5")
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }

    }
}

struct RatingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        RatingIndicator()
    }
}
