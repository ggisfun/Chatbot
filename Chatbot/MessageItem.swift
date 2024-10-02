//
//  MessageItem.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/10/1.
//
import Foundation

struct Message: Codable {
    let role: String
    let content: String?
    let imgUrl: String?
    let dateTime: String
}

var chatHistory = [Message]()

// 新增聊天記錄
func addMessage(role: String, content: String?, imgUrl: String?) {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ZH_Hant_TW")
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    let dateTime = formatter.string(from: Date())
        
    let message = Message(role: role, content: content, imgUrl: imgUrl, dateTime: dateTime)
    chatHistory.append(message)
}

