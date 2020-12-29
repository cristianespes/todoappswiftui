//
//  ContentView.swift
//  Todo App
//
//  Created by Cristian Espes on 27/12/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var theme: ThemeSettings
    private var themeColor: Color {
        themeData[theme.themeSettings].themeColor
    }
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.priority, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var showingSettingsView = false
    @State private var showingAddTodoView = false
    @State private var animatingButton = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id:\.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(colorize(priority: Priority(rawValue: Int(todo.priority) ?? 2)))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(status(priority: Priority(rawValue: Int(todo.priority))))
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(4)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .listStyle(PlainListStyle())
                
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView()
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themeColor)
                            .opacity(animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                        Circle()
                            .fill(themeColor)
                            .opacity(animatingButton ? 0.15 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    
                    Button(action: {
                        showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    })
                    .accentColor(themeColor)
                    .onAppear {
                        DispatchQueue.main.async {
                            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                animatingButton.toggle()
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                .padding(.trailing, 16)
                , alignment: .bottomTrailing
            )
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton().accentColor(themeColor),
                trailing:
                    Button(action: {
                    showingSettingsView.toggle()
                }, label: {
                    Image(systemName: "paintbrush")
                        .imageScale(.large)
                })
                .sheet(isPresented: $showingSettingsView) {
                    SettingsView()
                }
            )
        }
        .accentColor(themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func colorize(priority: Priority?) -> Color {
        guard let priority = priority else { return .gray }
        switch priority {
        case .high:
            return .pink
        case .normal:
            return .green
        case .low:
            return .blue
        }
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ThemeSettings())
    }
}
#endif
