//
//  ContentView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//


let initialRequestStr: String = "Your task is to generate a city description for a tour guide feature within a mobile application, organized into two main parts as detailed below:* General Description: * Language: Utilize clear, simple language accessible to all app users. * Content: Offer a brief, one-paragraph description capturing the city's essence, including its atmosphere, cultural heritage, and distinctive qualities. * Format: Enclose this description within <city_description> and </city_description> tags.* Places to Visit: * List: Enumerate ten essential places within the city. * Format: List these locations using specific tags, from <one> to <ten>. Each tag should contain only the name of the place, without any additional descriptions or details.Instructions:* The general description should be concise yet informative, providing a snapshot of what makes the city unique.* For the places to visit, include only the names of the places, ensuring each name is concise (ideally two words or very brief).Example request format:<city_description> Your engaging description here, focusing on the city's unique atmosphere, cultural heritage, and attractions. </city_description> <places_to_visit> <one>Eiffel Tower</one> <two>Central Park</two> <three>Louvre Museum</three> <four>Golden Gate Bridge</four> <five>Colosseum</five> <six>Statue of Liberty</six> <seven>British Museum</seven> <eight>Grand Canyon</eight> <nine>Times Square</nine> <ten>Great Wall</ten> </places_to_visit>Please ensure the city description offers a compelling overview, and the places listed are presented succinctly by name only."


import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var query: String = ""
    @State private var isNavigationActive: Bool = false
    
    @State private var placesDetailedDescriptions: [String] = []

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
                    // Run the chat function asynchronously
                    Task {
                        let response = await chat(
                            profileText: "City name: " + self.query + initialRequestStr
                        )
                        // Use the response as needed, e.g., store it in a property to display in the UI
                        self.query = response
                        // Activate navigation link to switch to ResultView
                        self.isNavigationActive = true
                    }
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
