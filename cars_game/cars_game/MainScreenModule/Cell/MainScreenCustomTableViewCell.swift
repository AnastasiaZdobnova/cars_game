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
        label.font = FontConstants.labelFont
        label.textColor = AppColors.buttonTextAppColor
        return label
    }()
    
    let contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.buttonAppColor
        view.clipsToBounds = true
        view.layer.cornerRadius = LayoutConstants.standartCornerRadius
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = AppColors.backgroundAppColor
        [contentWhiteView, menuLabel].forEach {
            contentView.addSubview($0)
        }
        
        
        contentWhiteView.snp.makeConstraints { make in
            
            make.top.leading.equalTo(contentView).offset(LayoutConstants.standardMargin)
            make.bottom.right.equalTo(contentView).inset(LayoutConstants.standardMargin)
            make.height.equalTo(LayoutConstants.MainScreen.cellContentHeight)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.center.equalTo(contentWhiteView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
