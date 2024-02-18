import AVFoundation

class ImageFetcher {
    static let shared = ImageFetcher()

    func fetchImageURLs(for place: String, completion: @escaping ([String]) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "2a13eac855mshb815b1b93d02f36p1b1f2bjsn7e082a991965",
            "X-RapidAPI-Host": "duckduckgo-image-search.p.rapidapi.com"
        ]

        guard let urlEncodedPlace = place.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://duckduckgo-image-search.p.rapidapi.com/search/image?q=\(urlEncodedPlace)") else {
            print("Invalid URL")
            completion(["default_placeholder"])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching image URLs: \(error.localizedDescription)")
                completion(["default_placeholder"])
                return
            }

            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: data!) as? [String: Any],
                      let results = jsonResponse["results"] as? [[String: Any]] else {
                    completion(["default_placeholder"])
                    return
                }

                let imageUrls = results.compactMap { $0["image"] as? String }
                completion(imageUrls.isEmpty ? ["default_placeholder"] : imageUrls)
            } catch {
                print("JSON parsing error: \(error)")
                completion(["default_placeholder"]) // Use placeholder on parsing error
            }
        }.resume()
    }
}



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

let initialRequestStr: String = "Your task is to generate a city description for a tour guide feature within a mobile application, organized into two main parts as detailed below:* General Description: * Language: Utilize clear, simple language accessible to all app users. * Content: Offer a brief, one-paragraph description capturing the city's essence, including its atmosphere, cultural heritage, and distinctive qualities. * Format: Enclose this description within <city_description> and </city_description> tags.* Places to Visit: * List: Enumerate five essential places within the city. * Format: List these locations using specific tags, from <one> to <five>. Each tag should contain only the name of the place, without any additional descriptions or details.Instructions:* The general description should be concise yet informative, providing a snapshot of what makes the city unique.* For the places to visit, include only the names of the places, ensuring each name is concise (ideally two words or very brief).Example request format:<city_description> Your engaging description here, focusing on the city's unique atmosphere, cultural heritage, and attractions. </city_description> <places_to_visit> <one>Eiffel Tower</one> <two>Central Park</two> <three>Louvre Museum</three> <four>Golden Gate Bridge</four> <five>Colosseum</five> </places_to_visit>Please ensure the city description offers a compelling overview, and the places listed are presented succinctly by name only."
let secondaryRequestStr: String = "Create a detailed, narrative-driven description of a specific place for our tour guide app feature. The content should span two paragraphs within <place_description></place_description> tags, focusing on:* Introduction to the place's atmosphere and cultural significance.* Historical context and unique features.Aim to captivate and inform app users, enriching their understanding and enticing them to visit.Example format:<place_description> Engaging, detailed two-paragraph description covering the mentioned aspects. </place_description>Ensure the narrative is immersive, offering a comprehensive view of the place's heritage and visitor experiences."

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var query: String = ""
    @State private var isNavigationActive: Bool = false
    
    @State private var places: [String] = []
    @State private var placesFull: [String] = []
    
    @State private var cd: String = ""
    @State private var ptv: [String] = []
    @State private var ImagePaths: [String] = []
    @State private var combinedPlaces: [(name: String, description: String)] = []
    
    @State var synthesizer = AVSpeechSynthesizer()
    
    func speakText(_ text: String) {
        // Initialize a speech synthesizer
        let speechSynthesizer = synthesizer

        // Create an utterance with the text you want to speak
        let utterance = AVSpeechUtterance(string: text)

        // Optionally, adjust the utterance properties for a more natural sounding voice
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        // Use the speech synthesizer to speak the utterance
        speechSynthesizer.speak(utterance)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                NavigationLink(destination: ResultView(query: $query, cityDescriptionArg: cd, combinedPlaces: combinedPlaces, imageUrls: ImagePaths), isActive: $isNavigationActive) {
                    EmptyView()
                }
                
                Button("Speak") {
                    // Call the function to start TTS
                    speakText("Hello, world! This is a simple demonstration of text-to-speech capabilities in Swift.")
                }
                
                Button("Test Navigation") {
                    self.isNavigationActive = true
                }
                Button(action: {
                    

                    // Initialize a speech synthesizer
                    let speechSynthesizer = AVSpeechSynthesizer()

                    // Create an utterance with the text you want to speak
                    let utterance = AVSpeechUtterance(string: "Hello, world! This is a simple demonstration of text-to-speech capabilities in Swift.")

                    // Optionally, adjust the utterance properties for a more natural sounding voice
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utterance.rate = 0.5

                    // Use the speech synthesizer to speak the utterance
                    speechSynthesizer.speak(utterance)

                    

                    print("Generate button tapped")
                    self.query = self.searchText
                    Task {
                        print("Starting fetch operation")
                        let response = await chat(
                            profileText: "City name: " + self.query + initialRequestStr, model_s: .gpt4_0125_preview
                        )
                        let (description, places) = await parseResponse(response)
                        print("Fetch operation completed: \(places), \(description)")
                        
                        var localCombinedPlaces: [(name: String, description: String)] = []
                        var localImagePaths: [String] = []
                        
                        for place in places {
                            let placeDescription = await chat(
                                profileText: "City name: " + self.query + ". Place name: " + place + secondaryRequestStr, model_s: .gpt3_5Turbo_0125
                            )
                            DispatchQueue.main.async {
                                localCombinedPlaces.append((name: place, description: placeDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)))
                            }
                            
                            await ImageFetcher.shared.fetchImageURLs(for: place) { imageUrls in
                                DispatchQueue.main.async {
                                    if let firstImageUrl = imageUrls.first {
                                        localImagePaths.append(firstImageUrl)
                                    }
                                }
                            }
                        }
                        print(localImagePaths)
                        
                        DispatchQueue.main.async {
                            print("All tasks completed, updating UI to navigate")
                            self.cd = description
                            self.ptv = places
                            self.combinedPlaces = localCombinedPlaces
                            self.ImagePaths = localImagePaths
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
