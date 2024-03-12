//
//  GameScreenPresenter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol GameScreenPresenterProtocol: AnyObject {
    var gameScreenModel : GameScreenModelProtocol { get set }
    var gameScreenRouter: GameScreenRouter { get set }
    func gameOver(score: Int)
}

final class GameScreenPresenter: GameScreenPresenterProtocol {
   
    var gameScreenModel: GameScreenModelProtocol
    var gameScreenRouter: GameScreenRouter
    
    weak var gameViewController: GameScreenViewController?

    init(model: GameScreenModelProtocol, router: GameScreenRouter) {
        self.gameScreenModel = model
        self.gameScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameOver(score: Int){
        gameScreenRouter.gameOver(score: score)
    }
}
