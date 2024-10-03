//
//  ChatbotViewController.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/9/28.
//

import UIKit
import Kingfisher
import Stipop

class ChatbotViewController: UIViewController {

    let chatTableView = UITableView()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sendbutton")!.withTintColor(.blue, renderingMode: .alwaysTemplate), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
        
    let stipopButton: SPUIButton = {
        let button = SPUIButton(type: .system)
        button.tintColor = .systemBlue
        button.setImage(UIImage(named: "sticker")!, for: .normal)
        
        let user = SPUser(userID: "chatUser")
        button.setUser(user, viewType: .picker)
        return button
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.text = "輸入文字..."
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 17)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.link.cgColor
        textView.layer.cornerRadius = 18
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingHead
        return textView
    }()
    
    let typingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        let data = NSDataAsset(name: "Animation_typing")!.data
        let cfData = data as CFData
        CGAnimateImageDataWithBlock(cfData, nil) { _, cgImage, _ in
            imageView.image = UIImage(cgImage: cgImage)
        }
        return imageView
    }()
    
    var keyboardConstraint: NSLayoutConstraint?
    var inputConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.register(myTableViewCell.self, forCellReuseIdentifier: myTableViewCell.identifier)
        chatTableView.register(myImgTableViewCell.self, forCellReuseIdentifier: myImgTableViewCell.identifier)
        chatTableView.register(botTableViewCell.self, forCellReuseIdentifier: botTableViewCell.identifier)
        chatTableView.register(botImgTableViewCell.self, forCellReuseIdentifier: botImgTableViewCell.identifier)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        stipopButton.delegate = self
        messageTextView.delegate = self
        
        backgroundSetting()
        chatTableView.separatorStyle = .none
        chatTableView.decelerationRate = .fast
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
        
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func backgroundSetting() {
        let bgImageView = UIImageView(frame: view.bounds)
        bgImageView.image = UIImage(named: "backgroundImg")
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        
        let effect = UIBlurEffect(style: .light)
        let bottomSFView = UIVisualEffectView(effect: effect)
        let messageInputView = UIVisualEffectView(effect: effect)
        
        let topSFView = UIView()
        let titleView = UIView()
        
        topSFView.backgroundColor = UIColor(red: 199/255, green: 245/255, blue: 255/255, alpha: 0.9)
        titleView.backgroundColor = UIColor(red: 199/255, green: 245/255, blue: 255/255, alpha: 0.9)
        chatTableView.backgroundColor = .clear
        
        let tableViewHeader = UIView()
        tableViewHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        tableViewHeader.backgroundColor = .clear
        chatTableView.tableHeaderView = tableViewHeader
        
        view.addSubview(chatTableView)
        view.addSubview(topSFView)
        view.addSubview(bottomSFView)
        view.addSubview(titleView)
        view.addSubview(messageInputView)
        view.addSubview(typingImageView)
        
        typingImageView.translatesAutoresizingMaskIntoConstraints = false
        typingImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        typingImageView.widthAnchor.constraint(equalToConstant: 68).isActive = true
        typingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        typingImageView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor, constant: -2).isActive = true
        typingImageView.isHidden = true
        
        topSFView.translatesAutoresizingMaskIntoConstraints = false
        topSFView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topSFView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topSFView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topSFView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        bottomSFView.translatesAutoresizingMaskIntoConstraints = false
        bottomSFView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomSFView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomSFView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomSFView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chatTableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor).isActive = true
        
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        keyboardConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        inputConstraint = messageInputView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -52.5)
        keyboardConstraint!.isActive = true
        inputConstraint!.isActive = true
        
        let titleBoderView = UIView()
        titleBoderView.backgroundColor = .darkGray
        titleView.addSubview(titleBoderView)
        
        titleBoderView.translatesAutoresizingMaskIntoConstraints = false
        titleBoderView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        titleBoderView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        titleBoderView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        titleBoderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let messageBoderView = UIView()
        messageBoderView.backgroundColor = .darkGray
        messageInputView.contentView.addSubview(messageBoderView)
        
        messageBoderView.translatesAutoresizingMaskIntoConstraints = false
        messageBoderView.topAnchor.constraint(equalTo: messageInputView.topAnchor).isActive = true
        messageBoderView.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor).isActive = true
        messageBoderView.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor).isActive = true
        messageBoderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "ChatGPT"
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .clear
        titleView.addSubview(titleLabel)
       
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let titleImageView = UIImageView()
        titleImageView.image = UIImage(named: "titleImg")
        titleImageView.contentMode = .scaleAspectFill
        titleView.addSubview(titleImageView)
        
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.heightAnchor.constraint(equalToConstant: 38 ).isActive = true
        titleImageView.widthAnchor.constraint(equalTo: titleImageView.heightAnchor, multiplier: 1).isActive = true
        titleImageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -8).isActive = true
        titleImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
                
        let stackView = UIStackView(arrangedSubviews: [stipopButton, messageTextView, sendButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .bottom
        messageInputView.contentView.addSubview(stackView)
        
        stipopButton.translatesAutoresizingMaskIntoConstraints = false
        stipopButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        stipopButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: messageInputView.topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: messageInputView.bottomAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: 0).isActive = true
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
    }
    
    @objc func sendMessage() {
        guard messageTextView.text?.isEmpty == false else { return }
        
        let prompt = messageTextView.text!
        addMessage(role: "user", content: messageTextView.text!, imgUrl: nil)
        messageTextView.text = ""
        chatTableView.reloadData()
        chatTableView.scrollToRow(at: IndexPath(row: chatHistory.count - 1, section: 0), at: .bottom, animated: true)
        
        typingImageView.isHidden = false
        if prompt.hasPrefix("#") {
            ChatGPTController.shared.imageGenerationAPI() { result in
                switch result {
                case .success(let imgUrl):
                    addMessage(role: "assistant", content: nil, imgUrl: imgUrl)
                    DispatchQueue.main.async {
                        self.chatTableView.reloadData()
                        self.chatTableView.scrollToRow(at: IndexPath(row: chatHistory.count - 1, section: 0), at: .bottom, animated: true)
                        self.typingImageView.isHidden = true
                    }
                case .failure(let error):
                    switch error {
                    case .invalidURL:
                        print("無效的URL")
                    case .invalidResponse:
                        print("無效的響應")
                    case .statusCodeError:
                        print("狀態碼錯誤")
                    case .requestFailed:
                        print("請求失敗")
                    case .decodeDataError:
                        print("解碼失敗")
                    case .encodeDataError:
                        print("編碼失敗")
                    }
                }
            }
        }else {
            ChatGPTController.shared.callChatGPTAPI() { result in
                switch result {
                case .success(let content):
                    addMessage(role: "assistant", content: content, imgUrl: nil)
                    DispatchQueue.main.async {
                        self.chatTableView.reloadData()
                        self.chatTableView.scrollToRow(at: IndexPath(row: chatHistory.count - 1, section: 0), at: .bottom, animated: true)
                        self.typingImageView.isHidden = true
                    }
                case .failure(let error):
                    switch error {
                    case .invalidURL:
                        print("無效的URL")
                    case .invalidResponse:
                        print("無效的響應")
                    case .statusCodeError:
                        print("狀態碼錯誤")
                    case .requestFailed:
                        print("請求失敗")
                    case .decodeDataError:
                        print("解碼失敗")
                    case .encodeDataError:
                        print("編碼失敗")
                    }
                }
            }
        }
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        var growingHeight : CGFloat
        if isKeyboardShowing {
            growingHeight = keyboardFrame!.height - (view.bounds.height - view.safeAreaLayoutGuide.layoutFrame.maxY)
        }else{
            growingHeight = 0
        }

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.keyboardConstraint?.constant = -growingHeight
            self.view.layoutIfNeeded()
        }completion: { _ in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
                if chatHistory.count > 0 {
                    let indexPath = IndexPath(row: chatHistory.count - 1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                self.view.layoutIfNeeded()
            }
        }
        
        inputConstraint?.constant = isKeyboardShowing ? -(120 + keyboardFrame!.height) : -52.5
        
    }

}

extension ChatbotViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatHistory[indexPath.row]
        if message.role == "assistant" {
            if message.content != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: botTableViewCell.identifier, for: indexPath) as! botTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.messageTextView.text = message.content
                cell.dateTimeLabel.text = message.dateTime
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: botImgTableViewCell.identifier, for: indexPath) as! botImgTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.stickerImageView.kf.setImage(with: URL(string:message.imgUrl!))
                cell.dateTimeLabel.text = message.dateTime
                return cell
            }
        }else {
            if message.content != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: myTableViewCell.identifier, for: indexPath) as! myTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.messageTextView.text = message.content
                cell.dateTimeLabel.text = message.dateTime
                
                if message.content!.hasPrefix("#") {
                    let attributedString = NSMutableAttributedString(string: message.content!)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSMakeRange(0, 1))
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, message.content!.count))
                    cell.messageTextView.attributedText = attributedString
                }
                
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: myImgTableViewCell.identifier, for: indexPath) as! myImgTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.stickerImageView.kf.setImage(with: URL(string:message.imgUrl!))
                cell.dateTimeLabel.text = message.dateTime
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension ChatbotViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "輸入文字..."
            textView.textColor = .lightGray
        }
    }
}

extension ChatbotViewController: SPUIDelegate {
    func onStickerSingleTapped(_ view: SPUIView, sticker: SPSticker) {
        addMessage(role: "user", content: nil, imgUrl: sticker.stickerImg)
        chatTableView.reloadData()
        chatTableView.scrollToRow(at: IndexPath(row: chatHistory.count - 1, section: 0), at: .bottom, animated: true)
    }
}
