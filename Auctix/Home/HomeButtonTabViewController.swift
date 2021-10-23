//
//  ViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 11.10.2021.
//

import UIKit

class HomeButtonTabViewController: UIViewController {
    
    // MARK: - Properties
    private let imageIconSearch = UIImageView()
    private let imageIconDelete = UIImageView()
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let searchTextField = UITextField()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .init(), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false 
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private var datasource: [Exhibition] = []
//    private let sections = Bundle.main.decode([MySections].self, from: "model.json")
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = ExhibitionManager.shared.loadExhibition()
        
        setupNavBar()
        setupLabel()
        setupCollectionView()
        setupTextField()
        
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
    }
}

// MARK: - Setups
extension HomeButtonTabViewController {
    
    func setupLabel(){
        titleLabel.attributedText = getAttrTitle()
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Good day, Иван Петров!"
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.lightCornflowerBlue
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - настройка строки поиска
    func setupTextField() {
        // MARK: - картинка поиска
        imageIconSearch.image = UIImage(named: "Search")
        
        let contentViewSearch = UIView()
        contentViewSearch.addSubview(imageIconSearch)
        contentViewSearch.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        // TODO: Настройку левых, правых картинок и тд можно вынести в расширение UITextField
        // TODO: Placeholder тоже настраивается через Attributed String
        imageIconSearch.frame = CGRect(x: 2, y: 0, width: 30, height: 30)
        searchTextField.leftView = contentViewSearch
        searchTextField.leftViewMode = .always
        
        // MARK: - картнка стереть
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.font = .systemFont(ofSize: 20)
        searchTextField.placeholder = "Search..."
        searchTextField.layer.cornerRadius = 15
        // TODO: В константу цвет
        searchTextField.layer.backgroundColor = UIColor(red: 0.871, green: 0.937, blue: 0.973, alpha: 0.5).cgColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.reuseID)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 41),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -41),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            searchTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            searchTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: 40),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 120)
        ])
    }
}

// MARK: - Get Methods
extension HomeButtonTabViewController {
    
    private func getAttrTitle() -> NSAttributedString {
        let aWord = NSAttributedString(string: "A", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .regular),
            .foregroundColor: UIColor.orange
        ])
        
        let ctixWords = NSAttributedString(string: "UCTIX", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .regular),
            .foregroundColor: UIColor.blue
        ])
        
        let mutable = NSMutableAttributedString(attributedString: aWord)
        mutable.append(ctixWords)
        return mutable
    }
}

// MARK: - UICollectionViewDelegate
extension HomeButtonTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.reuseID, for: indexPath) as? ExhibitionCell {
            let data = datasource[indexPath.row]
            cell.configure(with: data)
            return cell
        }
        return .init()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeButtonTabViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
}

// MARK: - Flow Layout
extension HomeButtonTabViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 90
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 45, bottom: 0, right: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: В константы
        let width = UIScreen.main.bounds.width - 90
        return .init(width: width, height: collectionView.bounds.height)
    }
}

