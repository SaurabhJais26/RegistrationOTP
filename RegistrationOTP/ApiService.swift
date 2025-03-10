//
//  ApiService.swift
//  RegistrationOTP
//
//  Created by Saurabh Jaiswal on 10/03/25.
//

import Foundation

struct APIService {
    
    static let baseURL = "https://admin-cp.rimashaar.com/api/v1"
    
    static func registerUser(firstName: String, lastName: String, email: String, phone: String, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register-new?lang=en") else { return }
        
        let parameters: [String: Any] = [
            "app_version": "1.0",
            "device_model": "iPhone",
            "device_token": "",
            "device_type": "A",
            "dob": "",
            "email": email,
            "first_name": firstName,
            "gender": "",
            "last_name": lastName,
            "newsletter_subscribed": 0,
            "os_version": "16",
            "password": "",
            "phone": "",
            "phone_code": "965"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No Data Received")
                completion(.failure(NSError(domain: "No data received", code: 400, userInfo: nil)))
                return
            }
            
            if let jsonResponse = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonResponse)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataDict = json["data"] as? [String: Any],  
                   let userId = dataDict["id"] as? Int {
                    completion(.success(userId))
                } else {
                    completion(.failure(NSError(domain: "Invalid response format", code: 400, userInfo: nil)))
                }
            } catch {
                print("JSON Parsing Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    static func verifyOTP(userId: Int, otp: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/verify-code?lang=en") else { return }
        
        let parameters: [String: Any] = [
            "otp": otp,
            "user_id": userId
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 400, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("OTP Response JSON: \(json)")
                    
                    // Extract success, status, and message
                    let status = json["status"] as? Int ?? 400
                    let message = json["message"] as? String ?? "Invalid OTP"
                    
                    if status == 200 {
                        completion(.success(true))
                    } else {
                        completion(.failure(NSError(domain: message, code: status, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response format", code: 400, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    
}
