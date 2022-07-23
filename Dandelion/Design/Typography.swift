//
//  Typography.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

extension Font {
    static let theme = TypoTheme()
}

struct TypoTheme {
    @Environment(\.sizeCategory) var sizeCategory
    let title = Font.custom(CustomFont.playfairDisplayBold.name, size: 22)
    let koreanTitle = Font.custom(CustomFont.nanumMyeongjoExtraBold.name, size: 20)
    let sheetTitle = Font.custom(CustomFont.sfProExpandedHeavy.name, size: 20)
    let headlineLabel = Font.system(size: 20, weight: .bold, design: .rounded)
    let title2 = Font.system(size: 20, weight: .regular, design: .default)
    let filledButton = Font.system(size: 17, weight: .semibold, design: .default)
    let regular = Font.system(size: 17, weight: .regular, design: .default)
    let plainButton = Font.system(size: 15, weight: .bold, design: .default)
    let regularSerif = Font.custom(CustomFont.playfairDisplayRegular.name, size: 15)
    let regularSerifItalic = Font.custom(CustomFont.playfairDisplayItalic.name, size: 15)
    let subHeadline = Font.system(size: 15, weight: .regular, design: .default)
    let subHeadlineLabel = Font.system(size: 13, weight: .regular, design: .rounded)
    let footnote = Font.system(size: 13, weight: .regular, design: .default)
    let footnoteSerif = Font.custom(CustomFont.playfairDisplayRegular.name, size: 13)
    let koreanFootnoteSerif = Font.custom(CustomFont.nanumMyeongjo.name, size: 13)
    let caption = Font.system(size: 12, weight: .regular, design: .rounded)
}

enum CustomFont: String {
    case sfProRounded
    case sfProExpandedHeavy
    case playfairDisplayRegular
    case playfairDisplayBold
    case playfairDisplayItalic
    case nanumMyeongjo
    case nanumMyeongjoExtraBold
    
    var name: String {
        switch self {
        case .sfProRounded:
            return "SF"
        case .sfProExpandedHeavy:
            return "SFPro-ExpandedHeavy"
        case .playfairDisplayRegular:
            return "PlayfairDisplay-Regular"
        case .playfairDisplayBold:
            return "PlayfairDisplay-Bold"
        case .playfairDisplayItalic:
            return "PlayfairDisplay-Italic"
        case .nanumMyeongjo:
            return "NanumMyeongjoOTF"
        case .nanumMyeongjoExtraBold:
            return "NanumMyeongjoOTFExtraBold"
        }
    }
}

struct TypoTheme_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text("title")
                    .font(.theme.title)
                Text("한글타이틀")
                    .font(Font.theme.koreanTitle)
                Text("sheetTitle")
                    .font(Font.theme.sheetTitle)
                Text("headLineLabel")
                    .font(Font.theme.headlineLabel)
                Text("title2")
                    .font(.theme.title2)
                Text("filledButton")
                    .font(.theme.filledButton)
                Text("regular")
                    .font(.theme.regular)
                Text("plainButton")
                    .font(.theme.plainButton)
            }
            Group {
                Text("regularSerif")
                    .font(.theme.regularSerif)
                Text("regularSerifItalic")
                    .font(.theme.regularSerifItalic)
                Text("subHeadline")
                    .font(.theme.subHeadline)
                Text("subHeadlineLabel")
                    .font(.theme.subHeadlineLabel)
                Text("footnote")
                    .font(.theme.footnote)
                Text("footnoteSerif")
                    .font(.theme.footnoteSerif)
                Text("plainButton")
                    .font(.theme.plainButton)
                Text("한글풋노트")
                    .font(Font.theme.koreanFootnoteSerif)
                Text("caption")
                    .font(.theme.caption)
            }
        }
        .padding(20)
        .previewLayout(.sizeThatFits)
    }
}
