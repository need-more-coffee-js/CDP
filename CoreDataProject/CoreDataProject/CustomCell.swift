//
//  CustomCell.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 17.02.2025.
//


import UIKit
import SnapKit

class CustomCell: UITableViewCell {
    
    // MARK: - UI Elements
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25 // Круглая картинка
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Добавляем элементы на ячейку
        contentView.addSubview(profileImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(countryLabel)
        
        // Верстка с помощью SnapKit
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16) // Отступ слева
            make.centerY.equalToSuperview() // Центрирование по вертикали
            make.width.height.equalTo(50) // Размер картинки
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16) // Отступ от картинки
            make.top.equalToSuperview().offset(10) // Отступ сверху
            make.trailing.equalToSuperview().offset(-16) // Отступ справа
        }
        
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainLabel.snp.leading) // Выравнивание по левому краю с nameLabel
            make.top.equalTo(mainLabel.snp.bottom).offset(4) // Отступ от mainLabel
            make.trailing.equalToSuperview().offset(-16) // Отступ справа
        }
    }
    
    // MARK: - Configure Cell
    func configure(with image: UIImage?, name: String, surname: String) {
        profileImageView.image = image
        mainLabel.text = name
        countryLabel.text = surname
    }
}
