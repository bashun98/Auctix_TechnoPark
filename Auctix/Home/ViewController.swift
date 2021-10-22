//
//  ViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 11.10.2021.
//

import UIKit

class HomeButtonTabViewController: UIViewController {
    
    private let imageIconSearch = UIImageView()
    private let imageIconDelete = UIImageView()
    private let logoLabel1 = UILabel()
    private let logoLabel2 = UILabel()
    private let nameLabel = UILabel()
    private let searchTextField = UITextField()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return UICollectionView(frame: .init(), collectionViewLayout: layout)
    }()
    
    private var datasource: [Exhibition] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = ExhibitionManager.shared.loadExhibition()
        
        setupNavBar()
        setupLabel()
        setupCollectionView()

        setupTextField()
        view.addSubview(logoLabel1)
        view.addSubview(logoLabel2)
        view.addSubview(nameLabel)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
  
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
        
    }
    
    func setupLabel(){
        
        logoLabel1.text = "A"
        logoLabel1.font = .systemFont(ofSize: 40)
        logoLabel1.textColor = UIColor.honeyYellow  
        logoLabel1.backgroundColor = .white
        logoLabel1.translatesAutoresizingMaskIntoConstraints = false
        
        logoLabel2.text = "UCTIX"
        logoLabel2.font = .systemFont(ofSize: 40)
        logoLabel2.textColor = UIColor.blueGreen
        logoLabel2.backgroundColor = .white
        logoLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Good day, Иван Петров!"
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.lightCornflowerBlue
        nameLabel.backgroundColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    

    
    
    //настройка строки поиска
    
    func setupTextField() {
        
        //картинка поиска
        
        imageIconSearch.image = UIImage(named: "Search")
        
        let contentViewSearch = UIView()
        contentViewSearch.addSubview(imageIconSearch)
        contentViewSearch.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageIconSearch.frame = CGRect(x: 2, y: 0, width: 30, height: 30)
        searchTextField.leftView = contentViewSearch
        searchTextField.leftViewMode = .always
        
        //картнка стереть
        
        searchTextField.clearButtonMode = .whileEditing
        
        searchTextField.font = .systemFont(ofSize: 20)
        searchTextField.placeholder = "Search..."
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.backgroundColor = UIColor(red: 0.871, green: 0.937, blue: 0.973, alpha: 0.5).cgColor
        
        
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
       
        
    }
   
    
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ExhibitionCell.nib,
                                forCellWithReuseIdentifier: ExhibitionCell.reuseID)
        
        collectionView.contentInset = .zero
//        collectionView.contentMode = .center
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    
    

    func setupNavBar() {
        
        navigationController?.navigationBar.isHidden = true

    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            
            logoLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            logoLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            logoLabel2.leadingAnchor.constraint(equalTo: logoLabel1.leadingAnchor, constant: 25),
            logoLabel2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25),
            nameLabel.topAnchor.constraint(equalTo: logoLabel1.bottomAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            searchTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: 40),
            //searchTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 200),
            //collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),

        ])
    }
   

}

extension HomeButtonTabViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.reuseID, for: indexPath) as? ExhibitionCell else {
            return .init()
        }
        let exhibition = datasource[indexPath.row]
        cell.configure(with: exhibition)
//        cell.update(title: exhibition.title, image: exhibition.titleImg, opis: exhibition.text_opis)
   
        return cell
    }
}
extension HomeButtonTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
  
}
