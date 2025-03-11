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
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
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
                                .autocapitalization(.none)
                                .onChange(of: firstName) { _ in
                                    errorMessage = nil
                                }
                        }
                        VStack(alignment: .leading) {
                            Text("Last Name")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                            
                            TextField("", text: $lastName)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .frame(height: 40)
                                .autocapitalization(.none)
                                .onChange(of: lastName) { _ in
                                    errorMessage = nil
                                }
                        }
                    }
                    
                    Text("Phone Number or Email Id")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                    
                    TextField("", text: $phoneOrEmail)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        .frame(height: 40)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: phoneOrEmail) { _ in
                            errorMessage = nil
                        }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                Button {
                    registerUser()
                } label: {
                    Text(isLoading ? "Loading..." : "GET OTP")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isLoading ? Color.gray : Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(isLoading)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding()
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
            .opacity(isLoading ? 0.5 : 1.0)
            
            // Loader View
            if isLoading {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ProgressView("Processing...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { showOTPView && userID != nil },
            set: { _ in showOTPView = false }
        )) {
            OTPView(userId: userID ?? 0)
        }
    }
    
    private func registerUser() {
        isLoading = true
        errorMessage = nil
        
        guard !firstName.isEmpty, !lastName.isEmpty, !phoneOrEmail.isEmpty else {
            errorMessage = "⚠️ All fields are required."
            isLoading = false
            return
        }
        
        guard isValidEmail(phoneOrEmail) else {
            errorMessage = "⚠️ Please enter a valid email address."
            isLoading = false
            return
        }
        
        APIService.registerUser(firstName: firstName, lastName: lastName, email: phoneOrEmail, phone: phoneOrEmail) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let userID):
                    print("✅ Successfully registered. User ID: \(userID)")
                    self.userID = userID
                    self.showOTPView = true
                    
                case .failure(let error):
                    print("❌ Registration failed: \(error.localizedDescription)")
                    self.errorMessage = "⚠️ Registration failed: \(error.localizedDescription). Please try again."
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}


#Preview {
    ContentView()
}
