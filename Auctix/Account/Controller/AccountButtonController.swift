//
//  AccountButtonTabViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit
import Firebase
import SDWebImage

class AccountButtonTabViewController: UIViewController {
    
    private var flag = false
    private let viewAuth = ViewAuth()
    private let viewAcc = ViewAccount()
    private let custumAlert = CustomAlert()
    private let model: TableProductModelDescription = TableProductModel()
    private let modelExhib: CollectionModelDescription = CollectionModel()
    private var products: [Product] = []
    private var exhibitions: [Exhibition] = []
    private var imageLoader = ProductImageLoader.shared
    
    private let dateWithTime = Date()
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
        setupNavBar()
        setupModelExhib()
    }
    
    private func setupModelExhib() {
        modelExhib.loadExhibitions()
        modelExhib.output = self
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupView() {
        defaultView()
        if flag {
            if let viewWithTag = self.view.viewWithTag(10) {
                viewWithTag.removeFromSuperview()
                view.addSubview(viewAcc)
                viewAcc.translatesAutoresizingMaskIntoConstraints = false
                viewAcc.tag = 20
                viewAcc.delegate = self
                viewAcc.delegateEdit = self
                viewAcc.delegateLetter = self
                viewAcc.delegateSupport = self
                viewAcc.delegateCell = self
                viewAcc.delegateImage = self
                setupLayoutAcc()
            }
            viewAcc.setupUserNameLabel()
            viewAcc.setupEmailVerLabel()
            viewAcc.setupCollectionView()
        }
        if flag == false {
            if let viewWithTag = self.view.viewWithTag(20) {
                viewWithTag.removeFromSuperview()
                defaultView()
//            } else {
//                defaultView()
            }
        }
    }
    
    func defaultView() {
        if self.view.viewWithTag(10) == nil && self.view.viewWithTag(20) == nil {
            view.addSubview(viewAuth)
            viewAuth.translatesAutoresizingMaskIntoConstraints = false
            viewAuth.tag = 10
            viewAuth.delegate = self
            setupLayoutAutch()
        }
    }
    func setupLayoutAcc() {
        NSLayoutConstraint.activate([
            viewAcc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewAcc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewAcc.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewAcc.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupLayoutAutch() {
        NSLayoutConstraint.activate([
            viewAuth.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewAuth.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewAuth.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewAuth.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
//    private func setImage(for imageView: UIImageView, with name: String) {
//        
//    }
    
}

extension AccountButtonTabViewController: GoToLogin {
    func loginButtonTapped(sender: UIButton){
        navigationController?.pushViewController(LoginController(), animated: false)
    }
}

extension AccountButtonTabViewController: GoFuncAccount {
    func logoutButtonTapped(sender: UIButton){
        let firebaseAutch = Auth.auth()
        do{
            try firebaseAutch.signOut()
            viewWillAppear(false)
            //navigationController?.popToRootViewController(animated: false)
        } catch _ as NSError {
            print("не вышел из аакаунта")
        }
    }
}

extension AccountButtonTabViewController: GoLetter {
    func confirmationLetter() {
        if Auth.auth().currentUser != nil && !Auth.auth().currentUser!.isEmailVerified {
            Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
                //Сообщите пользователю, что письмо отправлено или не может быть отправлено из-за ошибки.
                if error != nil {
                    
                } else {
                    self.custumAlert.showAlert(title: "Super", message: "We sent you an email, do not forget to confirm it.", viewController: self)
                }
            })
        }
        else {
            //Либо пользователь недоступен, либо пользователь уже верифицирован.
        }
    }
}

extension AccountButtonTabViewController: GoFuncEdit {
    func editCellTapped() {
        navigationController?.pushViewController(EditingAccountViewController(), animated: true)
    }
}

extension AccountButtonTabViewController: GoFuncSupport {
    func supportCellTapped() {
        navigationController?.pushViewController(SupportViewController(), animated: true)
    }
}

extension AccountButtonTabViewController {

    func setupAuth() {
        let user = Auth.auth().currentUser
        if user == nil {
            flag = false
        } else {
            flag = true
        }
        setupView()
    }
}

extension AccountButtonTabViewController: SelectCollectionCell {
    func inputCell(product: Product, products: [Product], imageCell: UIImage) {
        let viewController = ProductViewController()
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
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.product = product
        viewController.delegate = self
        self.products = products
        viewController.productImageView.image = imageCell
        present(navigationController, animated: true, completion: nil)
    }
}

extension AccountButtonTabViewController: ProductViewControllerDelegate {
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

extension AccountButtonTabViewController: inputImage {
    func inputImage(_ imageView: UIImageView,_ imageURL: String) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageLoader.getReference(with: imageURL) { reference in
            imageView.sd_setImage(with: reference, maxImageSize: 10 * 1024 * 1024, placeholderImage: nil) { image, error, SDImageCacheType, StorageReference in
                if error != nil {
                    imageView.image = #imageLiteral(resourceName: "VK")
                }
            }
        }
    }
}

extension AccountButtonTabViewController: HomeViewControllerInput {
    func didReceive(_ exhibitions: [Exhibition]) {
        self.exhibitions = exhibitions
    }

}
