//
//  ResultView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI

struct ResultView: View {
    @Binding var query: String

    var body: some View {
        VStack {
            Text("Result Page")
                .font(.largeTitle)
                .padding()
            
            Text("Query: \(query)")
                .foregroundColor(.gray)
                .padding()
        }
        .navigationBarTitle("Result")
    }
}
