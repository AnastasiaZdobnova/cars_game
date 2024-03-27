//
//  GameScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol GameScreenRouterProtocol {
    static func createModule(navigationController: UINavigationController) -> UIViewController
    func gameOver(score: Int)
}

public class GameScreenRouter: GameScreenRouterProtocol {
    
    var navigationController: UINavigationController?
    
    public static func createModule(navigationController: UINavigationController) -> UIViewController {
        let router = GameScreenRouter()
        router.navigationController = navigationController // Устанавливаем navigationController
        let model = GameScreenModel()
        let presenter = GameScreenPresenter(model: model, router: router)
        let view = GameScreenViewController(presenter: presenter)
        
        model.gameScreenPresenter = presenter
        presenter.gameViewController = view
        
        return view
    }
    
    func gameOver(score: Int){
        let viewController = GameOverScreenRouter.createModule(navigationController: self.navigationController!, score: score)
        navigationController?.pushViewController(viewController, animated: false)
    }
}
