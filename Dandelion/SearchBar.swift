//
//  SearchBar.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
 
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.theme.secondary)
 
                TextField("Search", text: $text)
                    .font(.theme.regular)
                    .foregroundColor(.theme.primary)
 
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.theme.primary)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .background(Color.theme.groupedBackground)
            .cornerRadius(10)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
