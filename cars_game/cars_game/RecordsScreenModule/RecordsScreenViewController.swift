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

class RecordsScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var recordsPresenter: RecordsScreenPresenterProtocol
    var leaderboard: [Player] = []
    var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.backgroundAppColor
        navigationController?.isNavigationBarHidden = false
        setupTableView()
        leaderboard = recordsPresenter.loadLeaderboard()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
            let player = leaderboard[indexPath.row]
            cell.configure(with: player)
        return cell
    }

    init(presenter: RecordsScreenPresenterProtocol) {
        self.recordsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.Records.heightForRow
    }
}
