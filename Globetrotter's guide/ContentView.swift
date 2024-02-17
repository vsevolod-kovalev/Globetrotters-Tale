//
//  ContentView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var tabs = [
        TabData(name: "Tab 1", cityName: "City 1", countryInfo: "Country 1, Province 1"),
        TabData(name: "Tab 2", cityName: "City 2", countryInfo: "Country 2, Province 2"),
        TabData(name: "Tab 3", cityName: "City 3", countryInfo: "Country 3, Province 3"),
        TabData(name: "Tab 4", cityName: "City 4", countryInfo: "Country 4, Province 4")
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(filteredTabs, id: \.self) { tab in
                            NavigationLink(destination: Text(tab.name)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(tab.cityName)
                                        .font(.title)
                                        .foregroundColor(.blue)

                                    Text(tab.countryInfo)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Tabs")
        }
    }

    var filteredTabs: [TabData] {
        if searchText.isEmpty {
            return tabs
        } else {
            return tabs.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct TabData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cityName: String
    let countryInfo: String
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color.gray)
                .cornerRadius(8)

            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 8)
            .opacity(text.isEmpty ? 0 : 1)
            .disabled(text.isEmpty)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
