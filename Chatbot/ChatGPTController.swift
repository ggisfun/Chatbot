//
//  Untitled.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/10/1.
//
import Foundation
import UIKit

class ChatGPTController {
    
    static let shared = ChatGPTController()
    
    private init() {
    }
    
    private let apiKey = "API_KEY"
        
    enum APIError: Error, LocalizedError {
        case invalidURL
        case requestFailed
        case statusCodeError
        case invalidResponse
        case decodeDataError
        case encodeDataError
    }
    
    func callChatGPTAPI(completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        var messages = [GPTMessage]()
        for item in chatHistory {
            if item.content != nil {
                let chatMessage = GPTMessage(role: item.role, content: item.content!)
                messages.append(chatMessage)
            }
        }
        
        let requestBody = GPTRequestBody(
            model: "gpt-3.5-turbo",
            messages: messages,
            max_tokens: 200,
            temperature: 0.7
        )
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.encodeDataError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                completion(.failure(.requestFailed))
                return
            }
            guard let responseCode = response as? HTTPURLResponse,
                  responseCode.statusCode == 200 else {
                completion(.failure(.statusCodeError))
                return
            }
            guard let data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GPTResponse.self, from: data)
                completion(.success(response.choices.first!.message.content))
            }catch {
                completion(.failure(.decodeDataError))
            }
        }.resume()
    }
    
    
}
