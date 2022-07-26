//
//  BookMarkView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct BookMarkView: View {
    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Image.bookLeft
                    .resizable()
                    .scaledToFit()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(0..<10) { i in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("150p")
                                    .font(.theme.footnote)
                                Text("Better to arrive late than not to come at allTo get something over with because it is inevitable")
                                    .font(.theme.regularSerif)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.regularMaterial)
                            )
                        }
                    }
                    .padding(.trailing, 20)
                }
            }
        }
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
