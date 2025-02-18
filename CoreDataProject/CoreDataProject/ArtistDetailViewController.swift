//
//  ArtistDetailViewController.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 18.02.2025.
//

import Foundation
import UIKit
import CoreData

class ArtistDetailViewController: UIViewController, UITextFieldDelegate{
    var artist: NSManagedObject?
    private let viewModel = ArtistViewModel()
    
    public let firstNameTextField = UITextField()
    public let lastNameTextField = UITextField()
    public let countryTextField = UITextField()
    public let birthDayDatePicker = UITextField()
    public let saveButton = UIButton()
    public var isEditable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public func setupUI() {        
        title = "Исполнители"
        view.backgroundColor = .white
        
        // Поле для имени
        firstNameTextField.placeholder = "Имя"
        firstNameTextField.borderStyle = .roundedRect
        view.addSubview(firstNameTextField)
        
        // Поле для фамилии
        lastNameTextField.placeholder = "Фамилия"
        lastNameTextField.borderStyle = .roundedRect
        view.addSubview(lastNameTextField)
        
        // Поле для страны
        countryTextField.placeholder = "Страна"
        countryTextField.borderStyle = .roundedRect
        view.addSubview(countryTextField)
        
        // DatePicker для даты рождения
        birthDayDatePicker.keyboardType = .numberPad
        birthDayDatePicker.placeholder = "дд.мм.гггг"
        birthDayDatePicker.borderStyle = .roundedRect
        birthDayDatePicker.delegate = self
        view.addSubview(birthDayDatePicker)
        
        // Кнопка сохранения
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveArtist), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Верстка с SnapKit
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        countryTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        birthDayDatePicker.snp.makeConstraints { make in
            make.top.equalTo(countryTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(birthDayDatePicker.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
        }
    }
    
    private func loadData() {
        if let artist = artist {
            firstNameTextField.text = artist.value(forKeyPath: "firstName") as? String
            lastNameTextField.text = artist.value(forKeyPath: "lastName") as? String
            countryTextField.text = artist.value(forKeyPath: "country") as? String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: artist.value(forKeyPath: "birthDay") as! Date)
            birthDayDatePicker.text = dateString
        }
    }
    
    @objc private func saveArtist() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: birthDayDatePicker.text!)
        
        guard
            let lastName = lastNameTextField.text,
            let firstName = firstNameTextField.text,
            let country = countryTextField.text,
            let birthDay = date else { return }
        viewModel.saveArtist(lastName: lastName, firstName: firstName, country: country, birthDay: birthDay, artist: artist)
        navigationController?.popViewController(animated: true)
    }
}
