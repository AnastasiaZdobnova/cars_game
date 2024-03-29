//
//  MainScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol MainScreenRouterProtocol {
    var navigationController: UINavigationController? { get set }
    static func  createModule(navigationController: UINavigationController) -> UIViewController
    func showGameScreen()
    func showSettingScreen()
    func showRecordsScreen()
}

public class MainScreenRouter: MainScreenRouterProtocol {
    
    var navigationController: UINavigationController?
    
    public static func createModule(navigationController: UINavigationController) -> UIViewController {
        let router = MainScreenRouter()
        router.navigationController = navigationController // Устанавливаем navigationController
        let model = MainScreenModel()
        let presenter = MainScreenPresenter(model: model, router: router)
        let view = MainScreenViewController(presenter: presenter)
        
        model.mainScreenPresenter = presenter
        presenter.mainViewController = view
        
        return view
    }
    
    func showGameScreen(){
        let viewController = GameScreenRouter.createModule(navigationController: self.navigationController!)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSettingScreen(){
        let viewController = SettingsScreenRouter.createModule()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showRecordsScreen(){
        let viewController = RecordsScreenRouter.createModule()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
