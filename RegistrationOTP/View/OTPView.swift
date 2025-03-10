//
//  OTPView.swift
//  RegistrationOTP
//
//  Created by Saurabh Jaiswal on 10/03/25.
//

import SwiftUI

struct OTPView: View {
    let userId: Int
    @State private var otpDigits: [String] = Array(repeating: "", count: 5)
    @FocusState private var focusedField: Int?
    @State private var errorMessage: String?
    @State private var showSuccessScreen = false
    
    @State private var timeRemaining = 26
    @State private var timerActive = true
    
    
    
    var body: some View {
        VStack {
            Image(systemName: "envelope.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(20)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Enter OTP")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Text("Please enter the 5-digit code that was sent to your email address or phone number.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
            }
            
            
            // OTP Input Fields
            HStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { index in
                    TextField("", text: $otpDigits[index])
                        .frame(width: 50, height: 50)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: index)
                        .onChange(of: otpDigits[index]) { newValue in
                            if newValue.count > 1 {
                                otpDigits[index] = String(newValue.prefix(1))
                            }
                            moveToNextField(from: index, value: newValue)
                        }
                }
            }
            .padding(.vertical, 20)
            
            if timerActive {
                Text("Renew a new code in **00:\(String(format: "%02d", timeRemaining)) sec**")
                    .font(.body)
            } else {
                Button("Resend Code") {
                    restartTimer()
                }
                .foregroundColor(Color.indigo)
            }
            
            
            Button(action: verifyOTP) {
                Text("Verify OTP")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $showSuccessScreen) {
            // Navigate to success screen here
        }
        .onAppear {
            focusedField = 0
            startTimer()
        }
    }
    
    // Move focus to the next field or previous field
    private func moveToNextField(from index: Int, value: String) {
        if value.count == 1 && index < 4 {
            focusedField = index + 1
        } else if value.isEmpty && index > 0 {
            focusedField = index - 1
        }
    }
    
    private func verifyOTP() {
        let enteredOTP = otpDigits.joined()
        guard enteredOTP.count == 5 else {
            errorMessage = "Please enter a valid 5-digit OTP."
            return
        }
        
        APIService.verifyOTP(userId: userId, otp: enteredOTP) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    showSuccessScreen = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func startTimer() {
        timeRemaining = 26
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                timerActive = false
            }
        }
    }
    
    private func restartTimer() {
        startTimer()
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(userId: 1)
    }
}
