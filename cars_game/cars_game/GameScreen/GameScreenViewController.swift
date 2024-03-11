//
//  GameScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol GameScreenViewControllerProtocol : UIViewController {
    var gamePresenter: GameScreenPresenterProtocol { get }
}

class GameScreenViewController: UIViewController, GameScreenViewControllerProtocol {
    
    var gamePresenter: GameScreenPresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink // TODO: вынести отдельно
        navigationController?.isNavigationBarHidden = false
    }
    
    init(presenter: GameScreenPresenterProtocol) {
        self.gamePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
