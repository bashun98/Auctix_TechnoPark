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
    private let newExhibitions = UILabel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .init(), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false 
        collection.isPagingEnabled = false
        
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private let delegateExhib = ExhibitionCell()
    
    private var datasource: [Exhibition] = []
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateExhib.delegate = self
        
        loadetDatasourse()
        setupNavBar()
        setupLabel()
        setupCollectionView()
        setupTextField()
        
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(searchTextField)
        view.addSubview(newExhibitions)
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
    }
}

extension HomeButtonTabViewController: ButtonClic {
    func didTabButton(sender: UIButton) {
        let vs = UINavigationController(rootViewController: TableProductsController())
        vs.pushViewController(TableProductsController(), animated: true)
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
        
        newExhibitions.text = "Newest"
        newExhibitions.font = .systemFont(ofSize: 36)
        newExhibitions.textColor = UIColor.honeyYellow
        newExhibitions.translatesAutoresizingMaskIntoConstraints = false
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
        // TODO: В константу цвет (так точно)
        searchTextField.layer.backgroundColor = UIColor.searchColor.cgColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifire)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func loadetDatasourse(){
        var datasourceAll: [Exhibition] = []
        datasourceAll = ExhibitionManager.shared.loadExhibition()
        for i  in 1...datasourceAll.count {
            if datasourceAll[i-1].status == "new"
            {
                datasource.append(datasourceAll[i-1])
            }
        }
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
            newExhibitions.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 41),
            newExhibitions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            newExhibitions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            collectionView.topAnchor.constraint(equalTo: newExhibitions.bottomAnchor, constant: 10)
        ])
    }
     
}

// MARK: - Get Methods
extension HomeButtonTabViewController {
    
    private func getAttrTitle() -> NSAttributedString {
        let aWord = NSAttributedString(string: "A", attributes: [
            .font: UIFont.systemFont(ofSize: 25, weight: .regular),
            .foregroundColor: UIColor.honeyYellow
        ])
        
        let ctixWords = NSAttributedString(string: "UCTIX", attributes: [
            .font: UIFont.systemFont(ofSize: 25, weight: .regular),
            .foregroundColor: UIColor.lightCornflowerBlue
        ])
        
        let mutable = NSMutableAttributedString(attributedString: aWord)
        mutable.append(ctixWords)
        return mutable
    }
}

// MARK: - UICollectionViewDelegate
extension HomeButtonTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.identifire, for: indexPath) as? ExhibitionCell {
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: В константы
        let width = UIScreen.main.bounds.width - 50
        return .init(width: width, height: collectionView.bounds.height)
    }
}
