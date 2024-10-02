//
//  ChatGPTItem.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/10/1.
//

struct GPTMessage: Codable {
    let role: String
    let content: String
}

struct GPTRequestBody: Codable {
    let model: String
    let messages: [GPTMessage]
    let max_tokens: Int
    let temperature: Double
    //let stop: [String]
}

struct GPTResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: GPTMessage
}
