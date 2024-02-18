import SwiftUI
import AVFoundation

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
    
    @State var synthesizer = AVSpeechSynthesizer()

        func speakText(_ text: String) {
        
            let speechSynthesizer = synthesizer

            // Create an utterance with the text you want to speak
            let utterance = AVSpeechUtterance(string: text)

            // Optionally, adjust the utterance properties for a more natural sounding voice
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.pitchMultiplier = 1.0
            utterance.rate = 0.5
            // Use the speech synthesizer to speak the utterance
            speechSynthesizer.speak(utterance)
        }
        func stopSpeaking() {
            synthesizer.stopSpeaking(at: .immediate)
        }

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

                Text(location.name.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 10)

                Text(location.description)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)
                    .padding(.horizontal, 20)
            }
            .navigationBarTitle(location.name, displayMode: .inline)
        }
        .overlay {
            VStack {
                Spacer()
                Button(action: {
                    speakText(location.description)
                }) {
                    Text("Text-to-Speech")
                        .padding()
                        .frame(maxWidth: 400) // Stretch the button horizontally
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onDisappear {
            stopSpeaking()
        }
    }
}


