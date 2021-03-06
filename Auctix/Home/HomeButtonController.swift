//
//  ViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 11.10.2021.
//

import UIKit
import Firebase
import SDWebImage

protocol HomeViewControllerInput: AnyObject {
    func didReceive(_ exhibitions: [Exhibition])
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let imageIconSearch = UIImageView()
    private let imageIconDelete = UIImageView()
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    
    private let searchTextField = UITextField()
    private let searchLabel = UILabel()
    private let searchButton = UIButton(type: .system)
    
    private let newExhibitions = UILabel()
    private let warningLabel = UILabel()
    private var flag = Bool()
    private var exbitionsNewest: [Exhibition] = []
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private var indexOfCellBeforeDragging = 0
    private lazy var collectionView: UICollectionView = {
        let layout = HomeTableLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .init(), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = false
       
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    private let model: CollectionModelDescription = CollectionModel()
    
    private var imageLoader = ExhibitionsImageLoader.shared
    
    private let delegateExhib = ExhibitionCell()
    
    private var datasource: [Exhibition] = []
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
      //  loadetDatasourse()
        setupNavBar()
        setupLabel()
        setupCollectionView()
 //       setupTextField()
        setupAddition()
        setupModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
    }
    
    func setupAuth() {
        let user = Auth.auth().currentUser
        if user == nil {
            nameLabel.text = "Sign in to your account"
        } else {
            let db = Firestore.firestore()
            db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if document.get("id") as? String == user?.uid {
                            self.nameLabel.text = "Good day, \(document.get("name") ?? " ")!"
                        }
                    }
                }
            }
        }
    }
    
    private func setupModel() {
        model.loadExhibitions()
        model.output = self
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
// обработчик нажатия кнопки на ячейке коллекции (открывает таблицу продуктов)
extension HomeViewController  {
    
    @objc
    func didTabButton(sender: UIButton) {
        let vc = TableProductsController()
        vc.nameExhibition = sender.titleLabel?.text ?? ""
        vc.isActiv = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - Setups
extension HomeViewController {
    
    func setupAddition() {
        view.addSubview(titleLabel)  
        view.addSubview(nameLabel)
        //view.addSubview(searchTextField)
        view.addSubview(searchLabel)
        view.addSubview(searchButton)
        view.addSubview(newExhibitions)
        //view.addSubview(warningLabel)
        view.addSubview(collectionView)
    }
    
    func setupLabel(){
        //navigationItem.title = "HOME"
        
        titleLabel.attributedText = getAttrTitle()
        titleLabel.font = UIFont(name: "Nunito-Regular", size: 25)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.lightCornflowerBlue
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        
        newExhibitions.font = .systemFont(ofSize: 36)
        newExhibitions.textColor = UIColor.honeyYellow
        newExhibitions.translatesAutoresizingMaskIntoConstraints = false

        searchLabel.font = .systemFont(ofSize: 20)
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.text = "Do you want to find an exhibit right away? Click here"
        searchLabel.numberOfLines = 0
        searchLabel.textColor = UIColor.lightCornflowerBlue
        searchLabel.textAlignment = .center
                
        searchButton.backgroundColor = UIColor.blueGreen
        searchButton.layer.cornerRadius = 18
        searchButton.setTitle("Search product", for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
//    // MARK: - настройка строки поиска
//    func setupTextField() {
//        // MARK: - картинка поиска
//        //imageIconSearch.image = UIImage(named: "Search")
//        
//        let contentViewSearch = UIView()
//        contentViewSearch.addSubview(imageIconSearch)
//        contentViewSearch.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//
//        searchTextField.delegate = self
//        searchTextField.returnKeyType = .done
//        // MARK: - картнка стереть
//        searchTextField.setImage(UIImage(named: "Search"), imageWidth: 20, padding: 20, isLeft: true)
//        //searchTextField.setRightPaddingPoints(20)
//        searchTextField.clearButtonMode = .whileEditing
//        searchTextField.font = .systemFont(ofSize: 20)
//        searchTextField.placeholder = "Search..."
//        searchTextField.layer.cornerRadius = 15
//        // TODO: В константу цвет (так точно)
//        searchTextField.layer.backgroundColor = UIColor.searchColor.cgColor
//        searchTextField.translatesAutoresizingMaskIntoConstraints = false
//        
//    }
    // настройка коллекции
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifire)
        collectionView.backgroundColor = UIColor.background
    }
    // настройка навигационного бара
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
                    
            searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            searchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            searchLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
                    //searchLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: 40),
                    
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            searchButton.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20),
                    //searchButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: 40),
                    
            newExhibitions.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 41),
            newExhibitions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            newExhibitions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
                
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: newExhibitions.bottomAnchor, constant: 10)
        ])

    }
    @objc
        private func didTapSearchButton() {
            let rootVC = TableSearchViewController()
            navigationController?.pushViewController(rootVC, animated: true)
        }
}

// MARK: - Get Methods
// расширение контроллера настройки названия приложения
extension HomeViewController {
    
    private func getAttrTitle() -> NSAttributedString {
        let aWord = NSAttributedString(string: "A", attributes: [
            .font: UIFont.systemFont(ofSize: 25, weight: .regular),
            .foregroundColor: UIColor.honeyYellow
        ])
        
        let bWords = NSAttributedString(string: "UCTIX", attributes: [
            .font: UIFont.systemFont(ofSize: 25, weight: .regular),
            .foregroundColor: UIColor.lightCornflowerBlue
        ])
        
        let mutable = NSMutableAttributedString(attributedString: aWord)
        mutable.append(bWords)
        return mutable
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.identifire, for: indexPath) as? ExhibitionCell {
            let data = datasource[indexPath.row]
            cell.configure(with: data)
            let imageView = cell.getImageView()
            let imageURL: UILabel = {
                let label = UILabel()
                label.text = data.name + ".jpeg"
                return label
            }()
            setImage(for: imageView, with: imageURL.text ?? "vk.jpeg")
            cell.jumpButton.addTarget(self, action: #selector(didTabButton(sender:)), for: .touchUpInside)
            //setupCollectionOrMessage()
            return cell
        }
        return .init()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
}

// MARK: - Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 50, left: 25, bottom: 50, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: В константы
        let width = UIScreen.main.bounds.width - 50
        return .init(width: width, height: collectionView.bounds.height)
    }
}

//MARK: - List View Controller Input

extension HomeViewController: HomeViewControllerInput {
    func didReceive(_ exhibitions: [Exhibition]) {
        
        exbitionsNewest.removeAll()
        let data = exhibitions

        let dateWithTime = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"

        let date = dateFormatter.string(from: dateWithTime) // 2/10/17
        let num = Int(date) ?? 0
        let numDay = num/10000
        let numMonth = -((numDay*100) - (num/100))
        let numYear = (num - (num/100)*100)
            
        var numMonthExample = 0
        var numDayExample = 0
        var numYearExample = 0
        if data.count > 0 {
        for i in 0...(data.count - 1) {
            let startDateFirebase = data[i].startDate.removeCharacters(from: CharacterSet.decimalDigits.inverted)
            let numStartDateFirebase = Int(startDateFirebase) ?? 0
            let numStartDateDay = numStartDateFirebase/10000
            let numStartDateMonth = -((numStartDateDay*100) - (numStartDateFirebase/100))
            let numStartDateYear = (numStartDateFirebase - (numStartDateFirebase/100)*100)

            let expirationDateFirebase = data[i].expirationDate.removeCharacters(from: CharacterSet.decimalDigits.inverted)
            let numExpirationDateFirebase = Int(expirationDateFirebase) ?? 0
            let numExpirationDateDay = numExpirationDateFirebase/10000
            let numExpirationDateMonth = -((numExpirationDateDay*100) - (numExpirationDateFirebase/100))
            let numExpirationDateYear = (numExpirationDateFirebase - (numExpirationDateFirebase/100)*100)

            if (numStartDateYear <= numYear && numExpirationDateYear >= numYear) {
                if (numStartDateMonth <= numMonth && numExpirationDateMonth >= numMonth) {
                    if (abs(numStartDateDay - numDay) <= 2) {
                        exbitionsNewest.append(data[i])
                        flag = true
                    }
                }
            }
        }
        }
        if flag {
            newExhibitions.text = "Newest"
        } else {
            if data.count > 0 {
            for i in 0...(data.count - 1) {
                let startDateFirebase = data[i].startDate.removeCharacters(from: CharacterSet.decimalDigits.inverted)
                let numStartDateFirebase = Int(startDateFirebase) ?? 0
                let numStartDateDay = numStartDateFirebase/10000
                let numStartDateMonth = -((numStartDateDay*100) - (numStartDateFirebase/100))
                let numStartDateYear = (numStartDateFirebase - (numStartDateFirebase/100)*100)

                let expirationDateFirebase = data[i].expirationDate.removeCharacters(from: CharacterSet.decimalDigits.inverted)
                let numExpirationDateFirebase = Int(expirationDateFirebase) ?? 0
                let numExpirationDateDay = numExpirationDateFirebase/10000
                let numExpirationDateMonth = -((numExpirationDateDay*100) - (numExpirationDateFirebase/100))
                let numExpirationDateYear = (numExpirationDateFirebase - (numExpirationDateFirebase/100)*100)

                if (numStartDateYear <= numYear && numExpirationDateYear >= numYear) {
                    if (numStartDateMonth <= numMonth && numExpirationDateMonth >= numMonth) {
                        if ((numYearExample < numStartDateYear)) {
                            numYearExample = numStartDateYear
                            numMonthExample = numStartDateMonth
                            numDayExample = numStartDateDay
                        }
                        if ((numMonthExample < numStartDateMonth) && (numYearExample == numStartDateYear)) {
                            numYearExample = numStartDateYear
                            numMonthExample = numStartDateMonth
                            numDayExample = numStartDateDay
                        }
                        if ((numDayExample < numStartDateDay) && (numMonthExample == numStartDateMonth)) {
                            numYearExample = numStartDateYear
                            numMonthExample = numStartDateMonth
                            numDayExample = numStartDateDay
                        }
                    }
                }
            }
            
            var stringData = String(numDayExample)+"."+String(numMonthExample)+"."+String(numYearExample)
            if numDayExample < 10{
                stringData = "0" + stringData
            }
            
            for i in 0...(data.count - 1) {
                if data[i].startDate == stringData{
                    exbitionsNewest.append(data[i])
                    newExhibitions.text = "Added earlier"
                    newExhibitions.numberOfLines = 0
                }
            }
            }
            
        }
        
        self.datasource = exbitionsNewest
        collectionView.reloadData()
    }
}


extension UITextField {
    
    public func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView   = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView     = paddingView
        self.leftViewMode = .always
    }
    
    public func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView    = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView     = paddingView
        self.rightViewMode = .always
    }
    
    public func setImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat, isLeft: Bool) {
        let imageView   = UIImageView(image: image)
        imageView.frame = .init(x      : padding,
                                y      : 0,
                                width  : imageWidth,
                                height : frame.height)
        imageView.contentMode = .center
        
        let containerView = UIView(frame: .init(x      : 0,
                                                y      : 0,
                                                width  : imageWidth + 2 * padding,
                                                height : frame.height))
        containerView.addSubview(imageView)
        if isLeft {
            leftView      = containerView
            leftViewMode  = .always
        } else {
            rightView     = containerView
            rightViewMode = .always
        }
    }
}
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
