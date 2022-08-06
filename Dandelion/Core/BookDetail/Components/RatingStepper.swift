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
        VStack {
            Text("\(value)")
            StarView.overlay(SliderView).mask(StarView)
        }
    }
    
    private var SliderView: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.theme.groupedBackground.opacity(0.01))
                    .frame(height: 50)

                Rectangle()
                    .fill(Color.theme.dandelion)
                    .frame(width: geo.size.width * CGFloat(value) / CGFloat(bounds.count), height: 50)
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
        }
        .frame(height: 50)
    }
    
    private var StarView: some View {
        HStack(spacing: 22) {
            ForEach(-2..<3) { i in
                Image.star
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .matchedGeometryEffect(id: "rating\(i)", in: id)
                    .foregroundColor(.theme.quaternary)
                    .offset(y: !showingRatingSheet ? CGFloat(abs(i)) == 1 ? 20 : CGFloat(abs(i)) == 2 ? 66 : 0 : 0)
                    .offset(x: !showingRatingSheet ? CGFloat(abs(i)) == 1 ? 12*CGFloat(i) : 0 : 0)
            }
        }
        .padding(.horizontal, 11)
    }
}

