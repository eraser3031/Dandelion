//
//  ManageBookmarkView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct ManageBookmarkView: View {
    
    @State private var text = "true"
    @State private var page = 0
    @State private var test = 3.0
    
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 30) {
                HStack {
                    Button {
                        print("hi")
                    } label: {
                        Image(systemName: "xmark")
                            .font(.theme.title2)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                
                PageStepper(page: $page, minValue: 0, maxValue: 199)
                
                CustomSlider(value: $test, in: 0...100)
                 
                Capsule()
                    .fill(Color.theme.groupedBackground)
                    .frame(height: 1)
                TextEditor(text: $text)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.theme.groupedBackground)
                    )
                    .font(.theme.regularSerif)
            }
            
            Button {
                print("hi")
            } label: {
                Label("Add Bookmark", systemImage: "plus")
                    .frame(maxWidth: 300)
            }
            .buttonStyle(FilledButtonStyle())
        }
        .padding(20)
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct ManageBookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        ManageBookmarkView()
    }
}
