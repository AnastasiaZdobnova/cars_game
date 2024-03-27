//
//  StructPlayer.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 14.03.2024.
//

import Foundation

struct Player: Codable {
    var id: Int
    var avatarImageData: String?
    var name: String
    var score: Int
    var date: Date
}
