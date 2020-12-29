//
//  FormRowStaticView.swift
//  Todo App
//
//  Created by Cristian Espes on 28/12/2020.
//

import SwiftUI

struct FormRowStaticView: View {
    
    let icon: String
    let firstText: String
    let secondText: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.gray)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(firstText)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(secondText)
        }
    }
}

#if DEBUG
struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
#endif
