//
//  GameScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation

protocol GameScreenModelProtocol: AnyObject {
}

final class GameScreenModel: GameScreenModelProtocol {
    
    weak var gameScreenPresenter: GameScreenPresenterProtocol?
    
}
