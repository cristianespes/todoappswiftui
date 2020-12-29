//
//  SettingsView.swift
//  Todo App
//
//  Created by Cristian Espes on 28/12/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var iconSettings: IconNames
    @EnvironmentObject var theme: ThemeSettings
    private let themes: [Theme] = themeData
    private var themeColor: Color {
        themeData[theme.themeSettings].themeColor
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                Form {
                    // MARK: - SECTION 1
                    Section(header: Text("Choose the app icon")) {
                        Picker(selection: $iconSettings.currentIndex, label:
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder(Color.primary, lineWidth: 2)

                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28, weight: .regular, design: .default))
                                        .foregroundColor(Color.primary)
                                }
                                .frame(width: 44, height: 44)

                                Text("App Icons".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                            }
                        ) {
                            ForEach(0..<iconSettings.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer()
                                        .frame(width: 8)
                                    
                                    Text(iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }
                                .padding(4)
                            }
                        }
                        .onReceive([iconSettings.currentIndex].publisher.first()) { value in
                            let index = iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Success! You have changed the app icon.")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // MARK: - SECTION 2
                    Section(header:
                        HStack {
                            Text("Choose the app theme")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(themeColor)
                        }
                    ) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button(action: {
                                    theme.themeSettings = item.id
                                    UserDefaults.standard.set(theme.themeSettings, forKey: "Theme")
                                }, label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        
                                        Text(item.themeName)
                                    }
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // MARK: - SECTION 3
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://www.google.es")
                        FormRowLinkView(icon: "link", color: .blue, text: "Twitter", link: "https://www.google.es")
                        FormRowLinkView(icon: "play.rectangle", color: .green, text: "Courses", link: "https://www.google.es")
                    }
                    .padding(.vertical, 4)
                    
                    // MARK: - SECTION 4
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Cristian Espés")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Cristian Espés")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - FOOTER
                Text("Copyright © All rights reserved.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            }
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
            )
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(Color("ColorBackground").ignoresSafeArea())
        }
        .accentColor(themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNames())
            .environmentObject(ThemeSettings())
    }
}
#endif
