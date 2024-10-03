//
//  botImgTableViewCell.swift
//  Chatbot
//
//  Created by Adam Chen on 2024/10/3.
//

import UIKit

class botImgTableViewCell: UITableViewCell {

    static let identifier: String = "botImgTableViewCell"
    
    let stickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stickerImageView)
        contentView.addSubview(dateTimeLabel)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            stickerImageView.widthAnchor.constraint(equalToConstant: 180),
            stickerImageView.heightAnchor.constraint(equalTo: stickerImageView.widthAnchor, multiplier: 1),
            stickerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stickerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            stickerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateTimeLabel.leadingAnchor.constraint(equalTo: stickerImageView.trailingAnchor, constant: 0),
            dateTimeLabel.bottomAnchor.constraint(equalTo: stickerImageView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
