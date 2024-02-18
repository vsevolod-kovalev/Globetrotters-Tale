import SwiftUI

func getLocations(placesTV: [String] ) -> [Location] {
    var result: [Location] = []
    
    for place in placesTV {
        let location = Location(
            name: place,
            imageName: "\(place.lowercased())_image",
            description: "Description for {\(place)}."
        )
        result.append(location)
    }
    return result
}

func truncateString(_ string: String, toLength length: Int) -> String {
    let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedString.count > length {
        let index = trimmedString.index(trimmedString.startIndex, offsetBy: length)
        return String(trimmedString[..<index]) + "..."
    } else {
        return trimmedString
    }
}

struct ResultView: View {
    @Binding var query: String
    var cityDescriptionArg: String
    var combinedPlaces: [(name: String, description: String)]
    var imageUrls: [String]

    var body: some View {
        NavigationView {
            List(Array(combinedPlaces.enumerated()), id: \.offset) { index, place in
                NavigationLink(destination: LocationDetailView(location: Location(name: place.name, imageName: index < imageUrls.count ? imageUrls[index] : "placeholder", description: place.description))) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(place.name.trimmingCharacters(in: .whitespacesAndNewlines))
                                .fontWeight(.bold)

                            Text(truncateString(place.description, toLength: 50))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if index < imageUrls.count, let url = URL(string: imageUrls[index]) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Places to visit")
            
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
                if let imageUrl = URL(string: location.imageName) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .cornerRadius(10)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .padding(.horizontal, 0)
                    .clipped()
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .padding(.horizontal, 0)
                        .clipped()
                }

                Text(location.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                Text(location.description)
                    .foregroundColor(.gray)
                    .padding()
            }
            .navigationBarTitle(location.name, displayMode: .inline)
        }
    }
}


