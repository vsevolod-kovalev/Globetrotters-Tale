//
//  ResultView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI

func getLocations(placesTV: [String] ) -> [Location] {
    var result: [Location] = []
    
    for place in placesTV {
        let location = Location(
            name: place,
            imageName: "\(place.lowercased())_image", // Create imageName from place name
            description: "Description for {\(place)}."
        )
        result.append(location)
    }
    return result
}

struct ResultView: View {
    @Binding var query: String
    var cityDescriptionArg: String
    var combinedPlaces: [(name: String, description: String)]

    var body: some View {
        NavigationView {
            List(Array(combinedPlaces.enumerated()), id: \.offset) { index, place in
                NavigationLink(destination: LocationDetailView(location: Location(name: place.name, imageName: "sample", description: place.description))) {
                    HStack {
                        Text(place.name)
                        
                        Spacer()
                        
                        Image("sample")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50) // Adjust size as needed
                            .clipped()
                            .cornerRadius(5)
                    }
                }
            }
            .navigationBarTitle("Results")
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
        ScrollView {
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

                Text(location.description) // Assuming this is the full description
                    .foregroundColor(.gray)
                    .padding()
            }
            .navigationBarTitle(location.name, displayMode: .inline)
        }
    }
}
