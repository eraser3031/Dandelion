//
//  PageStepper.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct PageStepper: View {
    
    @Binding var page: Int
    var minValue: Int
    var maxValue: Int
    
    var body: some View {
        HStack(spacing: 10) {
            
            Button {
                page = max(page - 1, minValue)
            } label: {
                Text("-")
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.theme.groupedBackground)
                    )
            }
            .buttonStyle(.plain)
            
            Text("\(page)p")
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.theme.groupedBackground)
            )
            
            Button {
                page = min(page + 1, maxValue)
            } label: {
                Text("+")
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.theme.groupedBackground)
                    )
            }
            .buttonStyle(.plain)
        }
        .font(.theme.filledButton)
    }
}

struct PageStepper_Previews: PreviewProvider {
    static var previews: some View {
        PageStepper(page: .constant(0), minValue: 0, maxValue: 100)
            .frame(width: 200)
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
