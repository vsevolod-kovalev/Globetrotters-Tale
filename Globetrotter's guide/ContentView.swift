//
//  ContentView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//


func parseResponse(_ response: String) async -> (cityDescription: String, placesToVisit: [String]) {
    var cityDescription = ""
    var placesToVisit = [String]()
    
    if let range = response.range(of: "<city_description>(.*?)</city_description>", options: .regularExpression) {
        cityDescription = String(response[range]).replacingOccurrences(of: "<city_description>", with: "").replacingOccurrences(of: "</city_description>", with: "")
    }
    
    let regex = try? NSRegularExpression(pattern: "<(?:one|two|three|four|five|six|seven|eight|nine|ten)>(.*?)</(?:one|two|three|four|five|six|seven|eight|nine|ten)>", options: [])
    let results = regex?.matches(in: response, options: [], range: NSRange(response.startIndex..., in: response))
    results?.forEach {
        let nsRange = $0.range(at: 1)
        if nsRange.location != NSNotFound, let range = Range(nsRange, in: response) {
            let match = String(response[range])
            placesToVisit.append(match)
        }
    }
    
    return (cityDescription, placesToVisit)
}

let initialRequestStr: String = "Your task is to generate a city description for a tour guide feature within a mobile application, organized into two main parts as detailed below:* General Description: * Language: Utilize clear, simple language accessible to all app users. * Content: Offer a brief, one-paragraph description capturing the city's essence, including its atmosphere, cultural heritage, and distinctive qualities. * Format: Enclose this description within <city_description> and </city_description> tags.* Places to Visit: * List: Enumerate ten essential places within the city. * Format: List these locations using specific tags, from <one> to <ten>. Each tag should contain only the name of the place, without any additional descriptions or details.Instructions:* The general description should be concise yet informative, providing a snapshot of what makes the city unique.* For the places to visit, include only the names of the places, ensuring each name is concise (ideally two words or very brief).Example request format:<city_description> Your engaging description here, focusing on the city's unique atmosphere, cultural heritage, and attractions. </city_description> <places_to_visit> <one>Eiffel Tower</one> <two>Central Park</two> <three>Louvre Museum</three> <four>Golden Gate Bridge</four> <five>Colosseum</five> <six>Statue of Liberty</six> <seven>British Museum</seven> <eight>Grand Canyon</eight> <nine>Times Square</nine> <ten>Great Wall</ten> </places_to_visit>Please ensure the city description offers a compelling overview, and the places listed are presented succinctly by name only."
let secondaryRequestStr: String = "Create a detailed, narrative-driven description of a specific place for our tour guide app feature. The content should span three paragraphs within <place_description></place_description> tags, focusing on:* Introduction to the place's atmosphere and cultural significance.* Historical context and unique features.Aim to captivate and inform app users, enriching their understanding and enticing them to visit.Example format:<place_description> Engaging, detailed three-paragraph description covering the mentioned aspects. </place_description>Ensure the narrative is immersive, offering a comprehensive view of the place's heritage and visitor experiences."

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var query: String = ""
    @State private var isNavigationActive: Bool = false
    
    @State private var places: [String] = []
    @State private var placesFull: [String] = []

    //Placeholder vars for the NavigationLink
    @State private var cd: String = ""
    @State private var ptv: [String] = []
    @State private var combinedPlaces: [(name: String, description: String)] = []

    
    
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                NavigationLink(destination: ResultView(query: $query, cityDescriptionArg: cd, combinedPlaces: combinedPlaces), isActive: $isNavigationActive) {
                    EmptyView()
                }
                
                Button(action: {
                    // Save the entered text to the query variable
                    self.query = self.searchText
                    // Run the chat function asynchronously
                    Task {
                        let response = await chat(
                            profileText: "City name: " + self.query + initialRequestStr, model_s: .gpt4_0125_preview
                        )
                        let (description, places) = await parseResponse(response)
                        print("City Description: \(description)")
                        print("Places to Visit: \(places)")
                        
                        var localCombinedPlaces: [(name: String, description: String)] = []

                        for place in places {
                            let response = await chat(
                                profileText: "City name: " + self.query + ". Place name: " + place + secondaryRequestStr, model_s: .gpt3_5Turbo_0125
                            )
                            print(place, response)
                            localCombinedPlaces.append((name: place, description: response))
                        }
                        
                        // Now update the state variable to trigger UI update
                        DispatchQueue.main.async {
                            self.combinedPlaces = localCombinedPlaces
                            self.cd = description
                            self.ptv = places
                            // Activate navigation link to switch to ResultView
                            self.isNavigationActive = true
                        }
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
