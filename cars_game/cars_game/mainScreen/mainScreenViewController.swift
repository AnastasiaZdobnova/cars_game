//
//  mainScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 09.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol MainScreenViewController : UIViewController {
    var mainPresenter: MainPresenter { get }
}

class mainScreenViewController: UIViewController, MainScreenViewController {
    
    var mainPresenter: MainPresenter
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // TODO: вынести отдельно
        setupTableView()
    }
    
    init(presenter: MainPresenter) {
        self.mainPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(mainScreenCustomTableViewCell.self, forCellReuseIdentifier: mainScreenCustomTableViewCell.identifier)
        tableView?.backgroundColor = .clear
        tableView?.separatorStyle = .none
        tableView?.showsVerticalScrollIndicator = false
        tableView?.contentInsetAdjustmentBehavior = .never

        if let tableView = tableView {
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)// TODO: вынести отдельно
                make.height.equalTo(448) // TODO: Вынести отдельно
            }
        }
    }
}

extension mainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPresenter.getMenuItems().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainScreenCustomTableViewCell.identifier, for: indexPath) as! mainScreenCustomTableViewCell
        cell.backgroundColor = .white // Белый цвет фона ячейки // TODO: вынести отдельно
        cell.menuLabel.text = mainPresenter.getMenuItems()[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
