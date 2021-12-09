//
//  TableSearchTableViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 09.12.2021.
//

import UIKit
import SDWebImage
import Firebase

class TableSearchViewController: UITableViewController {
        
        private let custumAlert = CustomAlert()
        private let search = UISearchController(searchResultsController: nil)
        private var imageLoader = ProductImageLoader.shared
        private var products: [Product] = [] {
                didSet {
                    //tableView.reloadData()
                    animateTableView()
                }
            }
        private let delegateController = TableProductsController()
        private var searchFilter: [Product] = []
        private var searchBarIsEmpty: Bool {
            guard let text = search.searchBar.text else {return false}
            return text.isEmpty
        }
        private var isFiltering: Bool {
                return search.isActive && !searchBarIsEmpty
            }
        
        private let model: TableProductModelDescription = TableProductModel()
        
        private let dateWithTime = Date()
        
        private let dateFormatter = DateFormatter()
        
        private let modelExhib: CollectionModelDescription = CollectionModel()

        private var exhibitions: [Exhibition] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupTableView()
            setupNavBar()
            setupModel()
            setupSearch()
            setupModelExhib()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            animateTableView()
        }
        
        private func setupModelExhib() {
            modelExhib.loadExhibitions()
            modelExhib.output = self
        }
        
        func setupSearch() {
            search.searchResultsUpdater = self
            search.obscuresBackgroundDuringPresentation = false
            search.searchBar.placeholder = "Search products..."
            navigationItem.searchController = search
            definesPresentationContext = true
        }
        
        func setupNavBar() {
            navigationController?.navigationBar.isHidden = false
            navigationController?.view.tintColor = UIColor.blueGreen
            navigationItem.title = "All exhibits"
            navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont.get(with: .regular, size: 20)]
            navigationItem.backButtonTitle = "Back"
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
        
        private func setupModel() {
            model.loadProducts()
            model.output = self
        }
        
        func setupTableView() {
            
            tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifireSearch)
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isFiltering {
                return searchFilter.count
            }
            return products.count
        }
            
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifireSearch, for: indexPath) as? SearchCell {
                let product: Product
                if isFiltering {
                    product = searchFilter[indexPath.row]
                } else {
                    product = products[indexPath.row]
                }
                cell.configure(with: product)
                let imageView = cell.getImageView()
                let imageURL: UILabel = {
                    let label = UILabel()
                    label.text = product.name + ".jpeg"
                    return label
                }()
                setImage(for: imageView, with: imageURL.text ?? "vk.jpeg")
                cell.delegate = delegateController
                return cell
            }
            return  .init()
        }
        
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
        
        // открытие страницы продукта
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let product = products[indexPath.row]
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchCell else { return }
            let imageCell = cell.getImage()
            let viewController = ProductViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            viewController.product = product
            viewController.delegate = self
            viewController.productImageView.image = imageCell
       
            dateFormatter.dateFormat = "dd.MM.yy"
            let date = dateFormatter.string(from: dateWithTime)
            let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .year]
            let difference = Calendar.current as NSCalendar
            for i in 0...(exhibitions.count-1) {
                if exhibitions[i].name == product.idExhibition {
                    if Int(difference.components(components, from: dateFormatter.date(from: date)!, to: dateFormatter.date(from: exhibitions[i].expirationDate)!, options: []).day ?? 0) >= 0 {
                        viewController.flagActiv = true
                    } else {
                        viewController.flagActiv = false
                    }
                }
            }
            
            present(navigationController, animated: true, completion: nil)
        }
        
        private func animateTableView() {
            tableView.reloadData()
            
            let cells = tableView.visibleCells
            let tableViewHeigth = tableView.bounds.height
            var delay: Double = 0
            
            for cell in cells {
                cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeigth)
                
                UIView.animate(withDuration: 1.5,
                               delay: delay * 0.05,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut,
                               animations: {
                                    cell.transform = CGAffineTransform.identity
                               },
                               completion: nil)
                delay += 1
            }
        }
        
    }

    extension TableSearchViewController: TableProductControllerInput {
        func didReceive(_ products: [Product]) {
            return self.products = products
        }
    }

    extension TableSearchViewController: UISearchResultsUpdating {
        func updateSearchResults(for search: UISearchController) {
                filterContentForSearchText(search.searchBar.text!)
            }
            
            private func filterContentForSearchText(_ searchText: String) {
                
                searchFilter = products.filter({ (product: Product) -> Bool in
                    return product.name.lowercased().contains(searchText.lowercased())
                })
                
                tableView.reloadData()
            }
    }


    extension TableSearchViewController: HomeViewControllerInput {
        func didReceive(_ exhibitions: [Exhibition]) {
            self.exhibitions = exhibitions
        }

    }

    extension TableSearchViewController: ProductViewControllerDelegate {
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
