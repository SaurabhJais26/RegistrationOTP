//
//  WelcomeView.swift
//  RegistrationOTP
//
//  Created by Saurabh Jaiswal on 11/03/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Your account has been successfully verified.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                // Navigate to the new screen
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
#Preview {
    WelcomeView()
}
