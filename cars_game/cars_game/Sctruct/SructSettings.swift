//
//  SructSettings.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 14.03.2024.
//

import Foundation

public struct Settings: Codable {
    var userName: String
    var carColorIndex: Int
    var obstacleTypeIndex: Int
    var difficultyIndex: Int
    var avatarImageData: String?
}
