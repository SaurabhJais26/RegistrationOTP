//
//  ContentView.swift
//  RegistrationOTP
//
//  Created by Saurabh Jaiswal on 10/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneOrEmail = ""
    
    @State private var userID: Int?
    @State private var showOTPView = false
    @State private var errorMessage: String?
    
    
    var body: some View {
        VStack {
            
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Sign Up")
                    .font(.title)
                    .bold()
                    
                
                Text("Please enter your information")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
            
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("First Name")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                        
                        TextField("", text: $firstName)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .frame(height: 40)
                    }
                    VStack(alignment: .leading) {
                        Text("Last Name")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                        
                        TextField("", text: $lastName)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .frame(height: 40)
                    }
                }
                
                Text("Phone Number or Email Id")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                
                TextField("", text: $phoneOrEmail)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    .frame(height: 40)
                
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            Button {
                print("Get OTP Pressed")
                registerUser()
            } label: {
                Text("GET OTP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                Text("or Register with")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }
            .padding()
            
            HStack(spacing: 40) {
                Button {
                    print("Google Sign In")
                } label: {
                    Image("google_icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Button {
                    print("Facebook Sign In")
                } label: {
                    Image("facebook_icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.bottom)
            
            Text("Have an account? ")
                .foregroundColor(.gray)
            + Text("Sign In")
                .foregroundColor(.black)
                .bold()
                
            
            
            
        }
        .padding(.top, 20)
        .fullScreenCover(isPresented: $showOTPView) {
            if let userID = userID {
                OTPView(userId: userID)
            }
        }
    }
    
    private func registerUser() {
        APIService.registerUser(firstName: firstName, lastName: lastName, email: phoneOrEmail, phone: phoneOrEmail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userID):
                    self.userID = userID
                    self.showOTPView = true
                    
                case.failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
