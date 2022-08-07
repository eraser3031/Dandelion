//
//  ManageBookmarkView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct ManageBookmarkView: View {
    
    @ObservedObject var vm: BookDetailViewModel
    var bookmark: Bookmark?
    
    var isEditMode: Bool {
        bookmark != nil
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState var isInputActive: Bool
    
    @State private var note = "true"
    @State private var page = 0
    @State private var test = 3.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                VStack(spacing: 30) {
                    HStack {
                        Button {
                            dismiss()
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
                    
                    TextEditor(text: $note)
                        .focused($isInputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button("Close") {
                                        isInputActive = false
                                    }
                                    .font(.theme.regular)
                                    .padding(.leading, 16)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.theme.groupedBackground)
                        )
                        .font(.theme.regularSerif)
                }
                
                Button {
                    if isEditMode {
                        vm.updateBookmark(bookmark!, page: page, note: note)
                    } else {
                        vm.addBookmark(page: page, note: note)
                    }
                    dismiss()
                } label: {
                    Label("\(isEditMode ? "Edit" : "Add") Bookmark",
                          systemImage: isEditMode ? "pencil" : "plus")
                    .frame(maxWidth: 300)
                }
                .buttonStyle(FilledButtonStyle())
            }
            .padding(20)
        }
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
            if isEditMode {
                note = bookmark?.note ?? ""
                page = Int(bookmark?.page ?? 0)
            }
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}
