//
//  ChatGPTItem.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/10/1.
//
import Foundation

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


struct DalleImageRequest: Codable {
    let prompt: String    // 圖片描述
    let n: Int            // 生成的圖片數量
    let size: String      // 圖片尺寸 (例如 "1024x1024")
}

struct DalleImageResponseData: Codable {
    let url: String    // 生成圖片的 URL
}

// 定義 DALL·E API 的整體回應
struct DalleImageResponse: Codable {
    let created: Int        // Unix 時間戳，表示生成圖片的時間
    let data: [DalleImageResponseData]  // 包含圖片信息的數組
}

