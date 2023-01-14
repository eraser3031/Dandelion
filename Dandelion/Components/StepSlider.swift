//
//  StepSlider.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/06.
//

import SwiftUI

struct StepSlider: View {
    
    @Binding var value: Int
    var bounds: ClosedRange<Int>
    let onEditingChanged: (Bool) -> Void
    let step: Int
    init(value: Binding<Int>, in bounds: ClosedRange<Int> = 0...10, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in}) {
        self._value = value
        self.bounds = bounds
        self.step = step
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.theme.groupedBackground)
                    .frame(height: 50)
                
                Capsule()
                    .fill(Color.blue)
                    .frame(width: geo.size.width * CGFloat(value) / CGFloat(bounds.count), height: 50)
            }
            .gesture(
                DragGesture()
                    .onChanged{ transition in
                        onEditingChanged(true)
                        value = Int(round(transition.location.x / geo.size.width * CGFloat(bounds.count)))
                    }
                    .onEnded{ _ in
                        onEditingChanged(false)
                    }
            )
        }
        .frame(height: 50)
    }
}

struct Test: View {
    @State private var int = 0
    var body: some View {
        StepSlider(value: $int, step: 1)
    }
}

struct StepSlider_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
