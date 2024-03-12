//
//  GameOverScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 12.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol GameOverScreenViewControllerProtocol: UIViewController {
    var gameOverPresenter: GameOverScreenPresenterProtocol { get }
    func setScore(score: Int)
}

class GameOverScreenViewController: UIViewController, GameOverScreenViewControllerProtocol {
    func setScore(score: Int) {
        scoreLabel.text = "Game Over \n Score: \(score)"
        scoreLabel.numberOfLines = 0 // Разрешаем перенос на неограниченное количество строк
        scoreLabel.lineBreakMode = .byWordWrapping // Перенос по словам
    }
    
    var gameOverPresenter: GameOverScreenPresenterProtocol

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let mainMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Main Menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 20
        return button
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 20
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        navigationController?.isNavigationBarHidden = true
        setupLayout()
        setupButtonActions()
    }

    private func setupLayout() {
        view.addSubview(scoreLabel)
        view.addSubview(mainMenuButton)
        view.addSubview(retryButton)

        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
        }

        mainMenuButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(72)
        }

        retryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainMenuButton.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(72)
        }
    }

    init(presenter: GameOverScreenPresenterProtocol) {
        self.gameOverPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonActions() {
        mainMenuButton.addTarget(self, action: #selector(goToMainMenu), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryGame), for: .touchUpInside)
    }

    @objc private func goToMainMenu() {
        gameOverPresenter.goToMainMenu()
    }

    @objc private func retryGame() {
        gameOverPresenter.retryGame()
        // Add logic to retry the game, such as resetting game state and returning to the game screen
        // This might involve popping to a specific view controller or resetting the game state and starting anew
    }
}
