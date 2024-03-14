//
//  SceneDelegate.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 16.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    public var currentUser: Player?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        initializeSettingsIfNeeded() // Инициализация настроек при первом запуске
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true

        let rootController = MainScreenRouter.createModule(navigationController: navigationController)
        navigationController.viewControllers = [rootController]

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func initializeSettingsIfNeeded() {
        if isFirstLaunch() {
            let initialSettings = Settings(
                userName: "SuperUser",
                carColorIndex: 1,
                obstacleTypeIndex: 1,
                difficultyIndex: 1
            )
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(initialSettings)
                UserDefaults.standard.set(data, forKey: "settings")
                initializeLeaderboardIfNeeded()
            } catch {
                print("Error initializing settings: \(error)")
            }
        }
    }
    
    func isFirstLaunch() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return true
        }
        return false
    }
    
    func initializeLeaderboardIfNeeded() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
       // if !launchedBefore {
            // Создаем список лидеров с тремя игроками
            currentUser = Player(id: 79, name: "SuperUser", score: 0, date: Date())
            let defaultPlayers = [
                Player(id: 1, name: "Player1", score: 20, date: Date()),
                Player(id: 2, name: "Player2", score: 10, date: Date()),
                currentUser
            ]
            print(defaultPlayers)
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(defaultPlayers)
                UserDefaults.standard.set(data, forKey: "leaderboard")
            } catch {
                print("Error initializing leaderboard: \(error)")
            }
        //}
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

