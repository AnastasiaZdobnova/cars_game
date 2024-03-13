//
//  MainScreenCustomTableViewCell.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

final class MainScreenCustomTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    var menuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)// TODO: вынести отдельно
        label.textColor = .white
        return label
    }()
    
    let contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray// TODO: вынести отдельно
        view.clipsToBounds = true
        view.layer.cornerRadius = 20// TODO: вынести отдельно
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBrown
        [contentWhiteView, menuLabel].forEach {
            contentView.addSubview($0)
        }
        
        
        contentWhiteView.snp.makeConstraints { make in
            
            make.top.leading.equalTo(contentView).offset(20) // TODO: вынести отдельно
            make.bottom.right.equalTo(contentView).inset(20)// TODO: вынести отдельно
            make.height.equalTo(72)// TODO: вынести отдельно
        }
        
        menuLabel.snp.makeConstraints { make in
            make.center.equalTo(contentWhiteView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
