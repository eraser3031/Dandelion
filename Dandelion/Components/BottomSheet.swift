//
//  BottomSheet.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Binding var isPresented: Bool
    let content: () -> Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(20)
            .padding(.bottom, safeAreaInsets.bottom)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.theme.background)
            }
    }
}

struct BottomSheetViewModifier<InnerContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let innerContent: () -> InnerContent
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> InnerContent) {
        self._isPresented = isPresented
        self.innerContent = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 20 : 0)
            ZStack(alignment: .bottom) {
                if isPresented {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isPresented = false
                            }
                        }
                        .transition(.opacity)
                    
                    BottomSheet(isPresented: $isPresented) {
                        innerContent()
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

extension View {
    func bottomSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(BottomSheetViewModifier(isPresented: isPresented, content: content))
    }
}

struct BottomSheetPreView: View {
    @State private var state = false
    var body: some View {
        ZStack {
            Button {
                withAnimation {
                    state.toggle()
                }
            } label: {
                Text("show")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bottomSheet(isPresented: $state) {
            Text("hello~")
                .frame(maxWidth: .infinity, maxHeight: 300)
        }

    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetPreView()
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
