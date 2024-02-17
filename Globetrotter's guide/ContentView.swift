//
//  ContentView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var query: String = ""
    @State private var isNavigationActive: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                NavigationLink(destination: ResultView(query: $query), isActive: $isNavigationActive) {
                    EmptyView()
                }
                
                Button(action: {
                    // Save the entered text to the query variable
                    self.query = self.searchText
                    // Activate navigation link to switch to ResultView
                    self.isNavigationActive = true
                }) {
                    Text("Generate")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("Search Page")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Enter text", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button(action: {
                // Clear the text field
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
    }
}
