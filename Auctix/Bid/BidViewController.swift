//
//  BidButtonTabViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import Firebase
import SDWebImage

protocol BidTableProductControllerInput: AnyObject {
    func didReceive(_ products: [Product])
}

class BidViewController: UIViewController {
    
    //var nameExhibition = ""
    private var products: [Product] = []
    private var productsNew: [Product] = []
    private var exhibitions: [Exhibition] = []
    private var imageLoader = ProductImageLoader.shared
    private let custumAlert = CustomAlert()
    private let model: BidTableProductModelDescription = BidTableProductModel()
    private let modelExhib: CollectionModelDescription = CollectionModel()
    private let productsTableView = UITableView()
    private let viewNoProducts = ViewNoProducts()
    private var flag = false
    private var flagIndex: Int?
    
    private let dateWithTime = Date()
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupTableCell()
        setupModel()
        setupModelExhib()
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
                view.addSubview(productsTableView)
                productsTableView.translatesAutoresizingMaskIntoConstraints = false
                productsTableView.tag = 20
                setupLayoutTable()
            } else {
                setupModel()
                productsTableView.reloadData()
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
    
    private func setupModelExhib() {
        modelExhib.loadExhibitions()
        modelExhib.output = self
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

extension BidViewController: BidTableProductControllerInput {
    func didReceive(_ products: [Product]) {

        productsNew.removeAll()
        if products.count > 0 {
        for i in 0...(products.count-1) {
            let cliets = products[i].idClient
            if cliets.first(where: { $0 == Auth.auth().currentUser?.uid}) != nil {
                productsNew.append(products[i])
            }
        }
        }
        self.products = productsNew
        if self.products.count == 0 {
            flag = false
            setupView()
        }
        productsTableView.reloadData()
        //setupView()
    }
    
//    self.products = products.compactMap {
//             if $0.idExhibition == nameExhibition {
//                 return $0
//             } else {
//                 return nil
//             }
//         }
//     }
}

extension BidViewController: UITableViewDelegate {
    // открытие страницы продукта
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductCell else { return }
        let imageCell = cell.getImage()
        let viewController = ProductViewController()
        viewController.flagActiv = false
        let navigationController = UINavigationController(rootViewController: viewController)
        if cell.isActiv ?? false {
            viewController.flagActiv = true
        } else {
            viewController.flagActiv = false
        }
        viewController.product = product
        viewController.delegate = self
        viewController.productImageView.image = imageCell
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
            cell.isFavorit = false
            if product.idClientLiked.count != 0 {
                for i in 0...(product.idClientLiked.count-1) {
                    if Auth.auth().currentUser?.uid ?? "" == product.idClientLiked[i] {
                        cell.isFavorit = true
                    }
                }
            }
            cell.isActiv = false
            dateFormatter.dateFormat = "dd.MM.yy"
            let date = dateFormatter.string(from: dateWithTime)
            let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .year]
            let difference = Calendar.current as NSCalendar
            for i in 0...(exhibitions.count-1) {
                if exhibitions[i].name == product.idExhibition {
                    if Int(difference.components(components, from: dateFormatter.date(from: date)!, to: dateFormatter.date(from: exhibitions[i].expirationDate)!, options: []).day ?? 0) >= 0 {
                        cell.isActiv = true
                    }
                }
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
extension BidViewController: ProductViewControllerDelegate {
    func didTapChatButton(productViewController: UIViewController, productName: String, priceTextFild: String, currentPrice: String) {
        
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

    
extension BidViewController: ProductCellDescription {
    func didTabButton(nameProduct: String, isFavorit: Bool) {
        for i in 0...(products.count-1) {
            if products[i].name == nameProduct {
                if isFavorit {
                    for j in 0...(products[i].idClientLiked.count-1) {
                        if products[i].idClientLiked[j] == Auth.auth().currentUser?.uid ?? "" {
                            products[i].idClientLiked.remove(at: j)
                            flagIndex = i
                        }
                    }
                     
                } else {
                    products[i].idClientLiked.append(Auth.auth().currentUser?.uid ?? "")
                    flagIndex = i
                }
            }
        }
        model.update(product: products[flagIndex ?? 0])
        flagIndex = nil
        //tableView.reloadData()
        print("gggggggggg")
    }
}

extension BidViewController: HomeViewControllerInput {
    func didReceive(_ exhibitions: [Exhibition]) {
        self.exhibitions = exhibitions
    }

}
