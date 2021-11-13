//
//  TableGoodsController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit
import Firebase
@testable import FirebaseMLModelDownloader

protocol TableProductControllerInput: AnyObject {
    func didReceive(_ products: [Product])
}

class TableProductsController: UITableViewController {
    
    var nameExhibition = ""
    private var products: [Product] = []
    private var productsNew: [Product] = []
    private let custumAlert = CustomAlert()
    private let model: TableProductModelDescription = TableProductModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupTableCell()
        setupModel()
        //products = ProductManager.shared.loadProducts()
    }
    // настройка навигационного бара
    func setupNavBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "Products"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 36) ?? UIFont.systemFont(ofSize: 36) ]
    }
    
    private func setupModel() {
        model.loadProducts()
        model.output = self
    }
    
    func setupTableCell() {
        tableView.separatorStyle = .none
    }
    // настройка ячеек таблицы (их регистрация)
    func setupTableView() {
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifireProd)
    }
    // открытие страницы продукта
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]

        let viewController = ProductViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.product = product
        viewController.delegate = self

        present(navigationController, animated: true, completion: nil)
    }
}
extension TableProductsController: TableProductControllerInput {
    func didReceive(_ products: [Product]) {
        productsNew.removeAll()
        for i in 0...(products.count-1) {
            if products[i].idExhibition == nameExhibition {
                productsNew.append(products[i])
            }
        }
        self.products = productsNew
        tableView.reloadData()
    }
}
// MARK: - Table view data source
extension TableProductsController {
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifireProd, for: indexPath) as? ProductCell {
            let product = products[indexPath.row]
            cell.configure(with: product)
            return cell
        }
        return .init()
    }
    
}
// настройка сообщения при нажатии на кнопку
extension TableProductsController: ProductViewControllerDelegate {
    func didTapChatButton(productViewController: UIViewController, productName: String, priceTextFild: String) {
        
        if priceTextFild.isEmpty == false {
            var product = products.first { $0.name == productName }
            product?.currentIdClient = Auth.auth().currentUser?.uid ?? ""
            if ((product?.idClient.first { $0 == Auth.auth().currentUser?.uid}) == nil) {
                product?.idClient.append(Auth.auth().currentUser?.uid ?? "")
            }
            product?.currentPrice = Int(priceTextFild) ?? 0
            
        
            
            
//            let db = Firestore.firestore()
//            db.collection("products").document("\(idProduct)").updateData([
//                "currentPrice": Int(priceTextFild) ?? 0,
//                "currentIdClient": Auth.auth().currentUser?.uid ?? "",
//                "idClient": FieldValue.arrayUnion(["\(Auth.auth().currentUser?.uid ?? "")"])
//            ], completion: { (error) in
//                if error == nil {
                    //self.tableView.removeDa
            productViewController.dismiss(animated: true)
            self.custumAlert.showAlert(title: "Wow!", message: "Your bet has been placed", viewController: self)
                    //self.tableView.reloadData()
//                }
//            })
            model.update(product: product ?? products[0])
            
        }
    }
}
