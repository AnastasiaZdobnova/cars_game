//
//  mainScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 09.03.2024.
//

import Foundation
import UIKit

protocol MainScreenViewController : UIViewController {
    var mainPresenter: MainPresenter { get }
}

class mainScreenViewController: UIViewController, MainScreenViewController {
    
    var mainPresenter: MainPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
   
    init(presenter: MainPresenter) {
        self.mainPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
