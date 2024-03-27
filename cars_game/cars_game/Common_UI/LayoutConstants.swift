//
//  LayoutConstants.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 27.03.2024.
//

import Foundation
struct LayoutConstants {
    
    static let standardMargin: CGFloat = 16.0
    static let standartCornerRadius: CGFloat = 20.0

    struct MainScreen {
        static let tableViewHeight: CGFloat = 112*3
        static let tableViewWidth: CGFloat = 300
        static let cellContentHeight: CGFloat = 72
    }
    
    struct GameScreen {
        static let roadWidth: CGFloat = 200
        static let dashedLineLength : CGFloat = 10
        static let dashedLineSpacing : CGFloat = 10
        static let dashedLineWidth : CGFloat = 2
        static let carWidth: CGFloat = 50
        static let carHeight: CGFloat = 100
    }
    
    struct GameOverScreen {
        static let scoreLabelTop: CGFloat = 100
        static let offsetScoreButton: CGFloat = 40
        static let buttonWidth : CGFloat = 300
        static let buttonHeight: CGFloat = 72
    }
    
    struct Settings {
        static let imageCornerRadius: CGFloat = 50
        static let avatarImageViewWidth: CGFloat = 100
        static let nameTextFieldWidth: CGFloat = 175
        static let nameTextFieldHeight: CGFloat = 40
        static let collectionViewHeight : CGFloat = 100
        static let buttonWidth : CGFloat = 300
        static let buttonHeight: CGFloat = 72
        static let borderWidth: CGFloat = 3
        static let minimumLineSpacingForSection: CGFloat = 20
    }
    
    struct Records {
        static let heightForRow : CGFloat = 100
        static let imageCornerRadius: CGFloat = 25
        static let avatarImageViewWidth: CGFloat = 50
    }
}
