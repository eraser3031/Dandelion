//
//  Color.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    
    let dandelion = Color("dandelion")
    
    let primary = Color("primary")
    let secondary = Color("secondary")
    let tertiary = Color("tertiary")
    let quaternary = Color("quaternary")
    
    let background = Color("background")
    let labelBackground = Color("labelBackground")
    let groupedBackground = Color("groupedBackground")
    let subGroupedBackground = Color("subGroupedBackground")
    
    let shadow = Color("shadow")
}

struct ColorTheme_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Group {
                Color.theme.dandelion.clipShape(Circle())
                Divider()
                Color.theme.primary.clipShape(Circle())
                Color.theme.secondary.clipShape(Circle())
                Color.theme.tertiary.clipShape(Circle())
                Color.theme.quaternary.clipShape(Circle())
            }
            Divider()
            Group {
                Color.theme.background.clipShape(Circle())
                    .overlay(Circle().strokeBorder())
                Color.theme.labelBackground.clipShape(Circle())
                Color.theme.groupedBackground.clipShape(Circle())
                Color.theme.subGroupedBackground.clipShape(Circle())
            }
        }
        .padding(20)
        .previewLayout(.fixed(width: 200, height: 800))
    }
}
