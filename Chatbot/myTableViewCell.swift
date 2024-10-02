//
//  myTableViewCell.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/9/29.
//

import UIKit

class myTableViewCell: UITableViewCell {
    
    static let identifier: String = "myTableViewCell"
    
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
        imageView.image = UIImage(named: "bubble_right")
        imageView.contentMode = .scaleToFill
        
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let imageWithInsets = imageView.image!.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        imageView.image = imageWithInsets.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGreen
        imageView.tintColor = UIColor(red: 120/255, green: 227/255, blue: 112/255, alpha: 1)
        return imageView
    }()

    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellStackView.addArrangedSubview(messageTextView)
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(cellStackView)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            dateTimeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 90),
            dateTimeLabel.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: -5),
            
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellStackView.leadingAnchor.constraint(equalTo: dateTimeLabel.trailingAnchor, constant: 0),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
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
