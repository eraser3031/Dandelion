//
//  ReviewTextField.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/04.
//

import SwiftUI

struct ReviewTextField: View {
    
    @Binding var text: String
    var id: Namespace.ID
    
    var body: some View {
        TextField("review is empty..", text: $text)
            .font(.theme.regularSerifItalic)
            .matchedGeometryEffect(id: "review", in: id)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .multilineTextAlignment(.center)
    }
}
