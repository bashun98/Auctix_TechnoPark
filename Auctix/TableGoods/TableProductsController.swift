//
//  TableGoodsController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit

class TableProductsController: UITableViewController {
    private var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        products = ProductManager.shared.loadProducts()
        tableView.separatorStyle = .none
    }

    func setupTableView() {
        navigationController?.navigationBar.isHidden = false
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifireProd)
    }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let product = products[indexPath.row]
//
//            let viewController = ProductViewController()
//            let navigationController = UINavigationController(rootViewController: viewController)
//
//            viewController.product = product
//            viewController.delegate = self
//
//            present(navigationController, animated: true, completion: nil)
        }
    //}

//    extension TableProductsController: ProductViewControllerDelegate {
//        func didTapChatButton(productViewController: UIViewController, productId: String) {
//            productViewController.dismiss(animated: true)
//
//            let alertVC = UIAlertController(title: "Start Chat", message: productId, preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alertVC, animated: true, completion: nil)
//        }
//    }


}
// MARK: - Table view data source
extension TableProductsController {
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
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
