//
//  GameOverScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 12.03.2024.
//

import Foundation
import UIKit

protocol GameOverScreenRouterProtocol {
    static func createModule(navigationController: UINavigationController, score: Int) -> UIViewController
    func goToMainMenu()
    func retryGame()
}

public class GameOverScreenRouter: GameOverScreenRouterProtocol {
    
    var navigationController: UINavigationController?
    
    public static func createModule(navigationController: UINavigationController, score: Int) -> UIViewController {
        let router = GameOverScreenRouter()
        router.navigationController = navigationController // Устанавливаем navigationController
        let model = GameOverScreenModel()
        let presenter = GameOverScreenPresenter(model: model, router: router)
        let view = GameOverScreenViewController(presenter: presenter)
        view.setScore(score: score)
        
        model.gameOverScreenPresenter = presenter
        presenter.gameOverViewController = view
        
        return view
    }
    
    func goToMainMenu(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func retryGame(){
        navigationController?.popViewController(animated: true)
    }
}
