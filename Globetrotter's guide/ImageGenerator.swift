//
//  ImageGenerator.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI
import Foundation


func freeImageGen() async {
    
    Task {
        let headers = [
            "X-RapidAPI-Key": "b6aca6aa05mshd08a049ee2118ddp13fe23jsn59b20467080c",
            "X-RapidAPI-Host": "duckduckgo10.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://duckduckgo10.p.rapidapi.com/search/images?term=San%20Francisco%20Golden%20Gate%20Bridge&region=wt-wt&safeSearch=off")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })

        dataTask.resume()
    }
}
//End Snippet

//Generates an image for a given location.
func getImage(nameArg: String) -> Image {
    var img: Image?
    let prompt: String = ""
    
    
        
    return img ?? Image("sample_img")
}
