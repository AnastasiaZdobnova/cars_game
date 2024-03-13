//
//  GameOverScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 12.03.2024.
//

import Foundation

protocol GameOverScreenModelProtocol: AnyObject {
}

final class GameOverScreenModel: GameOverScreenModelProtocol {
    
    weak var gameOverScreenPresenter: GameOverScreenPresenterProtocol?
    
}
