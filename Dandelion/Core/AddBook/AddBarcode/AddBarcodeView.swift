//
//  AddBarcodeView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import SwiftUI

struct AddBarcodeView: View {
    
    @Binding var selectedItems: [Item]
    @StateObject var vm = AddBarcodeViewModel()
    @Binding var isbns: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BarCodeScanner(isbns: $isbns)
                .ignoresSafeArea()
                .overlay {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .mask(
                            TestShape()
                        )
                        .allowsHitTesting(false)
                }
            
            VStack(spacing: 10) {
                
                Text("Scan barcode")
                    .foregroundColor(.white)
                    .font(.theme.footnote)
                    .opacity(0)
                
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(.white, lineWidth: 2)
                    .frame(width: 200, height: 140)
                
                Text("Scan Barcode")
                    .foregroundColor(.white)
                    .font(.theme.footnote)
            }
            
            HStack(spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.theme.title2)
                }
                .buttonStyle(.plain)
                
                Text("Barcode")
                    .font(.theme.sheetTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        print("hi")
                    }
                } label: {
                    Text("Done")
                        .frame(height: 34)
                }
                .buttonStyle(.plain)
            }
            .foregroundColor(.white)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 30)
            .padding(.top, 8)
        }
        .task(id: isbns) {
            if let item = await vm.search(isbn: isbns.last ?? "") {
                selectedItems.append(item)
            }
        }
    }
} 

struct TestShape: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.cyan)
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.black)
                .frame(width: 200, height: 140)
        }
        .compositingGroup()
        .luminanceToAlpha()
    }
}
