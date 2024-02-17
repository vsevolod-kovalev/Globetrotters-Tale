//
//  ResultView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI

struct ResultView: View {
    @Binding var query: String

    var sampleLocations: [Location] = [
        Location(name: "Location 1", imageName: "location1", description: "Description for Location 1."),
        Location(name: "Location 2", imageName: "location2", description: "Description for Location 2."),
        Location(name: "Location 3", imageName: "location3", description: "Description for Location 3."),
        // Add more sample locations as needed
    ]

    @State private var selectedLocationIndex: Int?

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Text("Result Page")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Query: \(query)")
                        .foregroundColor(.gray)
                        .padding()

                    ForEach(sampleLocations.indices, id: \.self) { index in
                        NavigationLink(destination: LocationDetailView(location: sampleLocations[index]), tag: index, selection: $selectedLocationIndex) {
                            LocationTabView(location: sampleLocations[index])
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationBarTitle("Result")
                .onAppear {
                    // Pre-select the first location when the view appears
                    selectedLocationIndex = sampleLocations.indices.first
                }
            }
        }
    }
}

struct LocationTabView: View {
    var location: Location

    var body: some View {
        VStack {
            Image(location.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .cornerRadius(10)
                .padding()

            Text(location.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            Text(location.description)
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}

struct LocationDetailView: View {
    var location: Location

    var body: some View {
        VStack {
            Image(location.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding()

            Text(location.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            Text(location.description)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationBarTitle(location.name)
    }
}
