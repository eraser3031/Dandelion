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


struct IntSlider: View {
    @State var score: Int = 0
    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            //returns the score as a Double
            return Double(score)
        }, set: {
            //rounds the double to an Int
            print($0.description)
            score = Int($0)
        })
    }
    var body: some View {
        VStack{
            Text(score.description)
            Slider(value: intProxy , in: 0.0...10.0, step: 1.0, onEditingChanged: {_ in
                print(score.description)
            })
        }
    }
}

struct IntSlider_Previews: PreviewProvider {
    static var previews: some View {
        IntSlider()
    }
}
