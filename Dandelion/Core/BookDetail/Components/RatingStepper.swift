//
//  RatingStepper.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/04.
//

import SwiftUI

struct RatingSlider: View {
    
    let showingRatingSheet: Bool
    let id: Namespace.ID
    @Binding var value: Int
    var bounds: ClosedRange<Int> = 1...10
    let onEditingChanged: (Bool) -> Void
    let step: Int = 1
    init(value: Binding<Int>, showingRatingSheet: Bool, id: Namespace.ID, onEditingChanged: @escaping (Bool) -> Void = { _ in}) {
        self._value = value
        self.showingRatingSheet = showingRatingSheet
        self.id = id
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color.theme.groupedBackground.opacity(0.01))
                    .frame(height: 50)
                
                HStack(spacing: 18) {
                    ForEach(-2..<3) { i in
                        ZStack {
                            Image.star
                                .foregroundColor(.theme.quaternary)
                                .frame(width: 28, height: 28)
                            HStack(spacing: 0) {
                                ForEach(1..<3) { j in
                                    Color.theme.dandelion
                                        .frame(width: 14, height: 28)
                                        .opacity((i+2)*2+j > value ? 0 : 1)
                                }
                            }
                        }
                        .mask(Image.star)
                        .matchedGeometryEffect(id: "starBackground\(i)", in: id)
                        .offset(x: getOffsetX(i: i), y: getOffsetY(i: i))
                    }
                }
                .padding(.horizontal, 11)
            }
            .gesture(
                DragGesture()
                    .onChanged{ transition in
                        onEditingChanged(true)
                        value = Int(min(max(round(transition.location.x / geo.size.width * CGFloat(bounds.count)), 0), CGFloat(bounds.count)))
                    }
                    .onEnded{ _ in
                        onEditingChanged(false)
                    }
            )
            .disabled(!showingRatingSheet)
        }
        .frame(height: 50)

    }
    
    private func getOffsetX(i: Int) -> CGFloat {
        return !showingRatingSheet ? CGFloat(abs(i)) == 1 ? 12*CGFloat(i) : 0 : 0
    }
    
    private func getOffsetY(i: Int) -> CGFloat {
        return !showingRatingSheet ? CGFloat(abs(i)) == 1 ? 20 : CGFloat(abs(i)) == 2 ? 66 : 0 : 0
    }
}

