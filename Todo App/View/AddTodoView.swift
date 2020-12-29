//
//  AddTodoView.swift
//  Todo App
//
//  Created by Cristian Espes on 27/12/2020.
//

import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var theme: ThemeSettings
    private var themeColor: Color {
        themeData[theme.themeSettings].themeColor
    }
    
    @State private var name: String = ""
    @State private var priority: Priority = .normal
    
    @State private var errorShowing = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    let priorities: [Priority] = [.high, .normal, .low]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Name
                TextEditor(text: $name)
                    .background(Color(UIColor.tertiarySystemFill))
                    .disableAutocorrection(true)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .background(Color(UIColor.tertiarySystemFill))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke()
                            .foregroundColor(themeColor)
                    )
                
                // MARK: - Priority
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) {
                        Text(status(priority: $0))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                // MARK: - Save
                Button(action: {
                    guard !name.isEmpty else {
                        errorShowing = true
                        errorTitle = "Invalid name"
                        errorMessage = "Make sure to enter something for\nthe new todo item."
                        return
                    }
                    
                    let todo = Todo(context: managedObjectContext)
                    todo.name = name
                    todo.priority = Int16(priority.rawValue)
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding(.horizontal)
                        .frame(height: 40)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(themeColor)
                        .cornerRadius(9)
                        .foregroundColor(Color.white)
                })
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
            )
            .alert(isPresented: $errorShowing, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
        }
        .accentColor(themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func status(priority: Priority?) -> String {
        guard let priority = priority else { return "Unkown" }
        switch priority {
        case .high:
            return "High"
        case .normal:
            return "Normal"
        case .low:
            return "Low"
        }
    }
}

#if DEBUG
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .environmentObject(ThemeSettings())
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
    }
}
#endif
