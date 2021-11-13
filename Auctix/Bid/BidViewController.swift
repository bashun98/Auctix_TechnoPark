//
//  BidButtonTabViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import Firebase

protocol BidTableProductControllerInput: AnyObject {
    func didReceive(_ products: [Product])
}

class BidViewController: UIViewController {

    //var nameExhibition = ""
    private var products: [Product] = []
    private var productsNew: [Product] = []
    private let custumAlert = CustomAlert()
    private let model: BidTableProductModelDescription = BidTableProductModel()
    private let productsTableView = UITableView()
    private let viewNoProducts = ViewNoProducts()
    private var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupTableCell()
        setupModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
        setupView()
    }
    
    func setupAuth() {
        if Auth.auth().currentUser != nil {
            flag = true
        } else {
            flag = false
        }
        
    }
    
    func setupView() {
        defaultView()
        if flag {
            if let viewWithTag = self.view.viewWithTag(10) {
                viewWithTag.removeFromSuperview()
                setupModel()
                if products.count == 0 {
                    flag = false
                } else {
                    view.addSubview(productsTableView)
                    productsTableView.translatesAutoresizingMaskIntoConstraints = false
                    productsTableView.tag = 20
                    setupLayoutTable()
                }
            } else {
                setupModel()
            }
        }
        if flag == false {
            if let viewWithTag = self.view.viewWithTag(20) {
                viewWithTag.removeFromSuperview()
                view.addSubview(viewNoProducts)
                viewNoProducts.translatesAutoresizingMaskIntoConstraints = false
                viewNoProducts.tag = 10
                setupLayoutView()
            } else {
                defaultView()
            }
        }
    }
    
    func defaultView() {
        if self.view.viewWithTag(10) == nil && self.view.viewWithTag(20) == nil {
            view.addSubview(viewNoProducts)
            viewNoProducts.translatesAutoresizingMaskIntoConstraints = false
            viewNoProducts.tag = 10
            setupLayoutView()
        }
    }
    
    func setupLayoutView() {
        NSLayoutConstraint.activate([
            viewNoProducts.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewNoProducts.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewNoProducts.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewNoProducts.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupLayoutTable() {
        NSLayoutConstraint.activate([
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "Bid Products"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 36) ?? UIFont.systemFont(ofSize: 36) ]
    }
    
    private func setupModel() {
        model.loadProducts()
        model.output = self
    }
    
    func setupTableCell() {
        productsTableView.translatesAutoresizingMaskIntoConstraints = false
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.separatorStyle = .none
    }
    // настройка ячеек таблицы (их регистрация)
    func setupTableView() {
        productsTableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifireProd)
    }
}

extension BidViewController: BidTableProductControllerInput {
    func didReceive(_ products: [Product]) {

        productsNew.removeAll()
        for i in 0...(products.count-1) {
            let cliets = products[i].idClient
            if cliets.first(where: { $0 == Auth.auth().currentUser?.uid}) != nil {
                productsNew.append(products[i])
            }
        }
        self.products = productsNew
        if products.count == 0 {
            
        }
        productsTableView.reloadData()
    }
}

extension BidViewController: UITableViewDelegate {
    // открытие страницы продукта
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]

        let viewController = ProductViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.product = product
        viewController.delegate = self

        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension BidViewController: UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifireProd, for: indexPath) as? ProductCell {
            let product = products[indexPath.row]
            cell.configure(with: product)
            return cell
        }
        return .init()
    }
    
}
// настройка сообщения при нажатии на кнопку
extension BidViewController: ProductViewControllerDelegate {
    func didTapChatButton(productViewController: UIViewController, productName: String, priceTextFild: String) {
        
        if priceTextFild.isEmpty == false {
            var product = products.first { $0.name == productName }
            product?.currentIdClient = Auth.auth().currentUser?.uid ?? ""
            if ((product?.idClient.first { $0 == Auth.auth().currentUser?.uid}) == nil) {
                product?.idClient.append(Auth.auth().currentUser?.uid ?? "")
            }
            product?.currentPrice = Int(priceTextFild) ?? 0
            
            productViewController.dismiss(animated: true)
            self.custumAlert.showAlert(title: "Wow!", message: "Your bet has been placed", viewController: self)

            model.update(product: product ?? products[0])
        }
    }
}

    

