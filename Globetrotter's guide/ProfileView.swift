//
//  ProfileView.swift
//  Globetrotter's guide
//
//  Created by Samuel Hickman on 2/17/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Profile Page")
            .font(.largeTitle)
            .padding()
            .navigationBarTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
