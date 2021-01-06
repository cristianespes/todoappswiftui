//
//  EmptyListView.swift
//  Todo App
//
//  Created by Cristian Espes on 27/12/2020.
//

import SwiftUI

struct EmptyListView: View {
    
    @EnvironmentObject var theme: ThemeSettings
    private var themeColor: Color {
        themeData[theme.themeSettings].themeColor
    }
    
    @State private var isAnimated = false
    
    let tips = [
        "Use yout time wisely.",
        "Slow and steady wins the race.",
        "Keep it short and sweet.",
        "Put hard tasks first.",
        "Reward yourself after work.",
        "Collect tasks ahead of time.",
        "Each night schedule for tomorrow"
    ]
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image("illustration-no\(Int.random(in: 1...3))")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360,
                           minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themeColor)
                
                Text("\(tips.randomElement() ?? tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themeColor)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -50)
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(Animation.easeOut(duration: 1.5)) {
                        isAnimated.toggle()
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .ignoresSafeArea()
    }
}

#if DEBUG
struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .environment(\.colorScheme, .dark)
            .environmentObject(ThemeSettings())
    }
}
#endif
