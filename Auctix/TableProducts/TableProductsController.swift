//
//  TableGoodsController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit
import Firebase
//@testable import FirebaseMLModelDownloader
import SDWebImage

protocol TableProductControllerInput: AnyObject {
    func didReceive(_ products: [Product])
}

class TableProductsController: UITableViewController {
    
    var nameExhibition = ""
    private var products: [Product] = [] {
            didSet {
                tableView.reloadData()
            }
        }
    private let custumAlert = CustomAlert()
    private let model: TableProductModelDescription = TableProductModel()
    private var imageLoader = ProductImageLoader.shared
    private var flag: Int?
    var isActiv: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupTableCell()
        setupModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductCell else { return }
        let imageCell = cell.getImage()
        let viewController = ProductViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.product = product
        viewController.delegate = self
        viewController.productImageView.image = imageCell
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setImage(for imageView: UIImageView, with name: String) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageLoader.getReference(with: name) { reference in
            imageView.sd_setImage(with: reference, maxImageSize: 10 * 1024 * 1024, placeholderImage: nil) { image, error, SDImageCacheType, StorageReference in
                if error != nil {
                    imageView.image = #imageLiteral(resourceName: "VK")
                }
            }
        }
    }
}
extension TableProductsController: TableProductControllerInput {
    func didReceive(_ products: [Product]) {
        self.products = products.compactMap {
                 if $0.idExhibition == nameExhibition {
                     return $0
                 } else {
                     return nil
                 }
             }
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
            cell.isFavorit = false
            if product.idClientLiked.count != 0 {
                for i in 0...(product.idClientLiked.count-1) {
                    if Auth.auth().currentUser?.uid ?? "" == product.idClientLiked[i] {
                        cell.isFavorit = true
                    }
                }
            }
            cell.isActiv = false
            if isActiv ?? false {
                cell.isActiv = true
            }
            cell.configure(with: product)
            let imageView = cell.getImageView()
            let imageURL: UILabel = {
                let label = UILabel()
                label.text = product.name + ".jpeg"
                return label
            }()
            setImage(for: imageView, with: imageURL.text ?? "vk.jpeg")
            cell.delegate = self
            
            return cell
        }
        
        return .init()
    }
    
}
// настройка сообщения при нажатии на кнопку
extension TableProductsController: ProductViewControllerDelegate {
    func didTapChatButton(productViewController: UIViewController, productName: String, priceTextFild: String, currentPrice: String) {
        
        if ((Int(priceTextFild) ?? 0) - (Int(currentPrice) ?? 0)) < 100 {
            self.custumAlert.showAlert(title: "Error!", message: "You cannot make a stack without a specified value", viewController: productViewController)
        } else {
            if priceTextFild.isEmpty {
                self.custumAlert.showAlert(title: "Error!", message: "You cannot make a stack without a specified value", viewController: productViewController)
            } else {
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
}

extension TableProductsController: ProductCellDescription {
    func didTabButton(nameProduct: String, isFavorit: Bool) {
        for i in 0...(products.count-1) {
            if products[i].name == nameProduct {
                if isFavorit {
                    for j in 0...(products[i].idClientLiked.count-1) {
                        if products[i].idClientLiked[j] == Auth.auth().currentUser?.uid ?? "" {
                            products[i].idClientLiked.remove(at: j)
                            flag = i
                        }
                    }
                     
                } else {
                    products[i].idClientLiked.append(Auth.auth().currentUser?.uid ?? "")
                    flag = i
                }
            }
        }
        model.update(product: products[flag ?? 0])
        flag = nil
        //tableView.reloadData()
        print("gggggggggg")
    }
}
