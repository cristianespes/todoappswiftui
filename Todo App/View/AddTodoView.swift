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
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Name
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    // MARK: - Priority
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
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
                        todo.priority = priority.rawValue
                        
                        do {
                            try managedObjectContext.save()
                            // TODO: Change .name to NO OPTIONAL
                            print("New todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                        } catch {
                            print(error)
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
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
                
                Spacer()
            }
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
}

#if DEBUG
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .environmentObject(ThemeSettings())
    }
}
#endif
