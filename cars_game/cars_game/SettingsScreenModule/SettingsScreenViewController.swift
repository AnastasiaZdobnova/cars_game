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
        view.backgroundColor = AppColors.backgroundAppColor
        navigationController?.isNavigationBarHidden = false
        setupAvatarImageView()
        setupNameLabel()
        setupNameTextField()
        setupCarsColorLabel()
        setupColorSelectionCollectionView()
    }
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColors.defaultAvatarImageAppColor
        imageView.layer.cornerRadius = 50 // Half of the width and height
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let imagePicker = UIImagePickerController() // ??
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "SuperUser"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textField.textColor = .white
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let carsColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Cars color"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var colorSelectionCollectionView: UICollectionView!
    private var selectedColorIndex = 1
    private let colorsArray = [AppColors.redCar, AppColors.blueCar, AppColors.greenCar]
    
    func setupAvatarImageView(){
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.width.height.equalTo(100)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    @objc private func presentImagePicker() {
        present(imagePicker, animated: true)
    }
    
    private func setupNameLabel(){
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(26)
        }
    }
    
    private func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.equalTo(175)
            make.height.equalTo(40)
        }
        nameTextField.delegate = self
    }
    
    
    
    private func setupCarsColorLabel(){
        view.addSubview(carsColorLabel)
        carsColorLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(35)
            make.leading.equalTo(avatarImageView)
        }
    }
    
    func setupColorSelectionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        colorSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorSelectionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorSelectionCollectionView.dataSource = self
        colorSelectionCollectionView.delegate = self
        colorSelectionCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        view.addSubview(colorSelectionCollectionView)
        colorSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(carsColorLabel.snp.bottom).offset(10)
            make.leading.equalTo(carsColorLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    init(presenter: SettingsScreenPresenterProtocol) {
        self.settingsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            avatarImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            avatarImageView.image = originalImage
        }
        dismiss(animated: true)
    }
}

extension SettingsScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SettingsScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colorsArray[indexPath.item] // Замените на настройку фона каждой ячейки своим цветом
        cell.layer.borderWidth = selectedColorIndex == indexPath.item ? 3 : 0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 20
        return cell
    }
}

extension SettingsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColorIndex = indexPath.item // Сохраните выбранный индекс
        print("Выбрали \(selectedColorIndex)")
        collectionView.reloadData() // Перезагрузите коллекцию, чтобы обновить внешний вид ячеек
    }
}

extension SettingsScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
