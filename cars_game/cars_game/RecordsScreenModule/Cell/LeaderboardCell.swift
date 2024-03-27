//
//  LeaderboardCell.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 14.03.2024.
//

import Foundation
import UIKit
import SnapKit

class LeaderboardCell: UITableViewCell {
    
    let playerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = LayoutConstants.Records.imageCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(playerImageView)
        addSubview(nameLabel)
        addSubview(scoreLabel)
        addSubview(dateLabel)
        
        playerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(LayoutConstants.standardMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(LayoutConstants.Records.avatarImageViewWidth)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(LayoutConstants.standardMargin)
            make.top.equalToSuperview().offset(LayoutConstants.standardMargin)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(LayoutConstants.standardMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutConstants.standardMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with player: Player) {
        if let imageData = player.avatarImageData {
            playerImageView.image = UIImage(data: imageData)
        } else {
            playerImageView.image = UIImage(named: "avatar")
        }


        nameLabel.text = player.name
        scoreLabel.text = "Score: \(player.score)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: player.date)
    }
}

