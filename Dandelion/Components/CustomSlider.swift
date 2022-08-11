//
//  CustomSlider.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct CustomSlider<T>: View where T: BinaryFloatingPoint, T.Stride : BinaryFloatingPoint {
    
    @Binding var value: T
    var bounds: ClosedRange<T>
    let onEditingChanged: (Bool) -> Void
    
    init(value: Binding<T>, in bounds: ClosedRange<T> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in}) {
        self._value = value
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        HStack {
            Text("\(Int(bounds.lowerBound))p")
                .font(.theme.caption)
                .foregroundColor(.theme.tertiary)
            
            GeometryReader { geo in
                ZStack(alignment: .trailing) {
                    Capsule()
                        .fill(Color.theme.groupedBackground)
                        .frame(height: 4)
                    
                    ZStack {
                        Image.star
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.theme.dandelion)
                            .offset(x: CGFloat(value) )
                            .gesture(
                                DragGesture()
                                    .onChanged{ transition in
                                        onEditingChanged(true)
                                        value = T(max(min(geo.size.width, transition.location.x), 0))
                                    }
                                    .onEnded{ _ in
                                        onEditingChanged(false)
                                    }
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            
            Text("\(Int(bounds.upperBound))p")
                .font(.theme.caption)
                .foregroundColor(.theme.tertiary)
        }
        .frame(height: 20)
    }
}

struct PageSlider: View {
    
    @Binding var value: Int
    var bounds: ClosedRange<Int>
    let step: Int = 1
    let onEditingChanged: (Bool) -> Void
    
    init(value: Binding<Int>, in bounds: ClosedRange<Int> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in}) {
        self._value = value
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        HStack {
            Text("\(Int(bounds.lowerBound))p")
                .font(.theme.caption)
                .foregroundColor(.theme.tertiary)
            
            GeometryReader { geo in
                ZStack(alignment: .trailing) {
                    Capsule()
                        .fill(Color.theme.groupedBackground)
                        .frame(height: 4)
                    
                    ZStack {
                        Image.star
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.theme.dandelion)
                            .offset(x: CGFloat(value) / CGFloat(bounds.upperBound) * geo.size.width )
                            .gesture(
                                DragGesture()
                                    .onChanged{ transition in
                                        onEditingChanged(true)
                                        let result = max(min(geo.size.width, transition.location.x), 0)
                                        value = Int(result / geo.size.width * CGFloat(bounds.upperBound))
                                    }
                                    .onEnded{ _ in
                                        onEditingChanged(false)
                                    }
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            
            Text("\(Int(bounds.upperBound))p")
                .font(.theme.caption)
                .foregroundColor(.theme.tertiary)
        }
        .frame(height: 20)
    }
}
