//
//  botTableViewCell.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/9/28.
//

import UIKit

class botTableViewCell: UITableViewCell {

    static let identifier: String = "botTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bot")
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
        
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bubble_left")
        imageView.contentMode = .scaleToFill
        
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let imageWithInsets = imageView.image!.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        imageView.image = imageWithInsets.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellStackView.addArrangedSubview(messageTextView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(cellStackView)
        contentView.addSubview(dateTimeLabel)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 0),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: dateTimeLabel.leadingAnchor, constant: 0),
            
            dateTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            dateTimeLabel.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: -5),
            
            bubbleImageView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 0),
            bubbleImageView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor, constant: 0),
            bubbleImageView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor, constant: 0),
            bubbleImageView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
