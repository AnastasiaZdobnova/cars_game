//
//  GameOverScreenPresenter .swift
//  cars_game
//
//  Created by Анастасия Здобнова on 12.03.2024.
//

import Foundation
import UIKit

protocol GameOverScreenPresenterProtocol: AnyObject {
    var gameOverScreenModel : GameOverScreenModelProtocol { get set }
    var gameOverScreenRouter: GameOverScreenRouterProtocol { get set }
    func goToMainMenu()
    func retryGame()
}

final class GameOverScreenPresenter: GameOverScreenPresenterProtocol {
   
    var gameOverScreenModel: GameOverScreenModelProtocol
    var gameOverScreenRouter: GameOverScreenRouterProtocol
    
    weak var gameOverViewController: GameOverScreenViewController?

    init(model: GameOverScreenModelProtocol, router: GameOverScreenRouterProtocol) {
        self.gameOverScreenModel = model
        self.gameOverScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goToMainMenu(){
        gameOverScreenRouter.goToMainMenu()
    }
    
    func retryGame(){
        gameOverScreenRouter.retryGame()
    }
}
