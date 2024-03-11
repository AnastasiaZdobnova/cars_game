//
//  SettingsScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol SettingsScreenViewControllerProtocol : UIViewController {
    var settingsPresenter: SettingsScreenPresenterProtocol { get }
}

class SettingsScreenViewController: UIViewController, SettingsScreenViewControllerProtocol {
    
    var settingsPresenter: SettingsScreenPresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red // TODO: вынести отдельно
        navigationController?.isNavigationBarHidden = false
    }
    
    init(presenter: SettingsScreenPresenterProtocol) {
        self.settingsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
