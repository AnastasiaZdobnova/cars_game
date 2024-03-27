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
        scoreLabel.numberOfLines = 0
        scoreLabel.lineBreakMode = .byWordWrapping
    }
    
    var gameOverPresenter: GameOverScreenPresenterProtocol

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = FontConstants.titleFont
        label.textAlignment = .center
        return label
    }()

    private let mainMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Main Menu", for: .normal)
        button.titleLabel?.font = FontConstants.buttonFont
        button.setTitleColor(AppColors.buttonTextAppColor, for: .normal)
        button.backgroundColor = AppColors.buttonAppColor
        button.layer.cornerRadius = LayoutConstants.standartCornerRadius
        return button
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = FontConstants.buttonFont
        button.setTitleColor(AppColors.buttonTextAppColor, for: .normal)
        button.backgroundColor = AppColors.buttonAppColor
        button.layer.cornerRadius = LayoutConstants.standartCornerRadius
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.backgroundAppColor
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(LayoutConstants.GameOverScreen.scoreLabelTop)
        }

        mainMenuButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreLabel.snp.bottom).offset(LayoutConstants.GameOverScreen.offsetScoreButton)
            make.width.equalTo(LayoutConstants.GameOverScreen.buttonWidth)
            make.height.equalTo(LayoutConstants.GameOverScreen.buttonHeight)
        }

        retryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainMenuButton.snp.bottom).offset(LayoutConstants.standardMargin)
            make.width.equalTo(LayoutConstants.GameOverScreen.buttonWidth)
            make.height.equalTo(LayoutConstants.GameOverScreen.buttonHeight)
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
    }
}
