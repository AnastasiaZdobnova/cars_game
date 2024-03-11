//
//  RecordsScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol RecordsScreenViewControllerProtocol : UIViewController {
    var recordsPresenter: RecordsScreenPresenterProtocol { get }
}

class RecordsScreenViewController: UIViewController, RecordsScreenViewControllerProtocol {
    
    var recordsPresenter: RecordsScreenPresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green // TODO: вынести отдельно
        navigationController?.isNavigationBarHidden = false
    }
    
    init(presenter: RecordsScreenPresenterProtocol) {
        self.recordsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
