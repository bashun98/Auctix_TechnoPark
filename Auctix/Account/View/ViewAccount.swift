import Firebase
import UIKit

protocol inputImage: AnyObject {
    func inputImage(_ imageView: UIImageView,_ imageURL: String)
}

protocol SelectCollectionCell: AnyObject {
    func inputCell(product: Product, products: [Product], imageCell: UIImage)
}

protocol AccountControllerInput: AnyObject {
    func didReceive(_ products: [Product])
}

protocol GoFuncAccount: AnyObject {
    func logoutButtonTapped(sender: UIButton)
}

protocol GoFuncEdit: AnyObject {
    func editCellTapped()
}

protocol GoFuncSupport: AnyObject {
    func supportCellTapped()
}

protocol GoLetter: AnyObject {
    func confirmationLetter()
}

protocol GoChangePhoto: AnyObject {
    func changePhoto()
}

protocol GoUserPhoto: AnyObject {
    func addPhoto()
}

class ViewAccount: UIView, UITableViewDelegate, UITableViewDataSource {
        
    weak var delegateCell: SelectCollectionCell?
    weak var delegate: GoFuncAccount?
    weak var delegateEdit: GoFuncEdit?
    weak var delegateLetter: GoLetter?
    weak var delegateImage: inputImage?
    weak var delegateSupport: GoFuncSupport?
    weak var delegateChangePhoto: GoChangePhoto?
    weak var delegatePhoto: GoUserPhoto?
    
    let loadingIndicator: ProgressView = {
            let progress = ProgressView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 5)
            progress.translatesAutoresizingMaskIntoConstraints = false
            return progress
        }()
    
    
    private var products: [Product] = []
    private var productsNew: [Product] = []
    private var flag: Int?
    //private let tablePC = TableProductsController()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 33/255, green: 158/255, blue: 188/255, alpha: 1), .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Log Out",
                                                        attributes: atts)
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alwaysBounceVertical = false
        
        table.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = AccountTableLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .init(), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = false
       
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private var models = [Section]()
    private let model: CollectionLikedModelDescription = CollectionLikedModel()
    private var imageView = UIImageView()
    var imageViewTest: UIImageView?
    {
        didSet {
            self.viewWithTag(35)?.removeFromSuperview()
        }
    }
    private var userNameTitle = UILabel()
    private var emailVerificaionTitle = UILabel()
    private let appearance = UINavigationBarAppearance()
    private let viewAuth = ViewAuth()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupModel()
        setupAccView()
        
        
        


    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    private func setupModel() {
        model.loadProducts()
        model.output = self
    }
    
    func setupAccView(){
        addSubview(loginButton)
        loginButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        setupNavigationTitle()
        
        setupImage()
        addSubview(imageView)
        
        imageView.addSubview(loadingIndicator)
        loadingIndicator.tag = 35
        
        setupUserNameLabel()
        addSubview(userNameTitle)
        
        addSubview(emailVerificaionTitle)
        setupEmailVerLabel()
        
        addSubview(tableView)
        setupTable()
        
        addSubview(collectionView)
        setupCollectionView()
        
        addConstraints()
    }
    
    @objc
    func confirmationLetter() {
        delegateLetter?.confirmationLetter()
    }
    
    @objc
    func logoutButtonTapped() {
        delegate?.logoutButtonTapped(sender: loginButton)
    }
    @objc
    func editCellTapped() {
        delegateEdit?.editCellTapped()
    }
    @objc
    func supportCellTapped() {
        delegateSupport?.supportCellTapped()
    }
    
    @objc
    func CellTapped() {
        
    }
    
    @objc
    func changePhoto() {
        delegateChangePhoto?.changePhoto()
    }
    
    @objc
    func addPhoto() {
        delegatePhoto?.addPhoto()
    }
}


extension ViewAccount {
    //MARK: настраиваем изображение аккаунта
    func setupImage(){
        addPhoto()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        imageView.makeRounded()
    }
    
    public func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    public func getImage() -> UIImage {
        return imageView.image ?? #imageLiteral(resourceName: "UserDefault")
    }
    
    //MARK: настраиваем табличное отображение настроек
    func setupTable(){
        configure()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = UIScreen.main.bounds
        tableView.backgroundColor = UIColor.background
        tableView.isScrollEnabled = false
    }
    
    func setupCollectionView(){
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductLikedCell.self, forCellWithReuseIdentifier: ProductLikedCell.identifireProdLiked)
        setupModel()
        collectionView.reloadData()
        collectionView.backgroundColor = UIColor.background
        
    }
    
    //MARK: настраиваем отображение Username
    func setupUserNameLabel(){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.get("id") as? String == user?.uid {
                        self.userNameTitle.text = "Hey, \(document.get("name") ?? " ")!"
                    }
                }
            }
        }
       // userNameTitle.text = "User"
        userNameTitle.textColor = UIColor.lightCornflowerBlue
        userNameTitle.textAlignment = .center
        userNameTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupEmailVerLabel(){
        Auth.auth().currentUser?.reload()
        let user = Auth.auth().currentUser
        if (user != nil && user!.isEmailVerified) {
            emailVerificaionTitle.text = " "
            emailVerificaionTitle.text = "Account verified"
        } else {
            emailVerificaionTitle.text = "Account not verified"
        }
        emailVerificaionTitle.textColor = UIColor.lightCornflowerBlue
        emailVerificaionTitle.textAlignment = .center
        emailVerificaionTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: настраиваем надписть Account
    func setupNavigationTitle(){
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.blueGreen,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .regular)
        ]
        appearance.titleTextAttributes = attrs
        //standardAppearance = appearance
        //self.title = "Account"
    }
    //MARK: добавляем констрейты для вьюх
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        //add
        
        constraints.append(imageView.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: UIScreen.main.bounds.width/3))
        constraints.append(imageView.trailingAnchor.constraint(
            equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width/3))
        constraints.append(imageView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.width/3))
        constraints.append(imageView.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor))
 
        constraints.append(userNameTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10))
        constraints.append(userNameTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(userNameTitle.trailingAnchor.constraint(equalTo: trailingAnchor))
        
        constraints.append(emailVerificaionTitle.topAnchor.constraint(equalTo: userNameTitle.bottomAnchor, constant: 10))
        constraints.append(emailVerificaionTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(emailVerificaionTitle.trailingAnchor.constraint(equalTo: trailingAnchor))
    
        constraints.append(tableView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(
            equalTo:safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(
            equalTo: tableView.topAnchor, constant: 240))
        constraints.append(tableView.topAnchor.constraint(
            equalTo: emailVerificaionTitle.bottomAnchor))
     
        constraints.append(collectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor))
        constraints.append(collectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor))
        constraints.append(collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10))
        constraints.append(collectionView.heightAnchor.constraint(equalToConstant: 200))
       //constraints.append(collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.bounds.height/4))
        
        //constraints.append(collectionView.topAnchor.constraint(equalTo: bottomAnchor, constant: -10))
      
        constraints.append(loadingIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 47))
        constraints.append(loadingIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: -47))
        constraints.append(loadingIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -47))
        constraints.append(loadingIndicator.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 47))
        
        //Activate
        NSLayoutConstraint.activate(constraints)
    }
    
    /* //MARK: позволяет активировать отображение заголовока секций таблицы
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    } */
    
    //MARK: количество секций таблицы
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    //MARK: количество строк в каждой секции в таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    //MARK: определяем вид строки таблицы, статическая или переключатель
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(let model):
            model.handler()
            
        case .switchCell(let model):
            model.handler()
        }
    }
    //MARK: настраиваем наполнение каждой строки таблицы настроек
    func configure() {

        models.append(Section(title: "General", options: [
            .staticCell(model: SettingsOption(title: "Account editing", icon: UIImage(systemName: "person"), iconBackgroundColor: .systemPink) {
                self.editCellTapped()
                print("tapped first cell")
            }),
            .staticCell(model: SettingsOption(title: "Email confirmation letter", icon: UIImage(systemName: "bell.badge"), iconBackgroundColor: .link) {
                self.confirmationLetter()
            }),
            .staticCell(model:SettingsOption(title: "Contact us", icon: UIImage(systemName: "questionmark.circle"), iconBackgroundColor: .systemGreen) {
                self.supportCellTapped()
            }),
            
            .staticCell(model: SettingsOption(title: "Change photo", icon: UIImage(systemName: "person.crop.rectangle"), iconBackgroundColor: .systemRed) {
                self.changePhoto()
                    
            })
        ]))
    }
}

extension UIImageView {
    //MARK: Функция позволяет сделать круглое изображение
    func makeRounded() {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.honeyYellow.cgColor
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }

}


extension ViewAccount: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductLikedCell.identifireProdLiked, for: indexPath) as? ProductLikedCell {
            let data = products[indexPath.row]
            cell.isFavorit = true
            cell.configure(with: data)
            cell.delegate = self
            let imageView = cell.getImageView()
            let imageURL: UILabel = {
                let label = UILabel()
                label.text = data.name + ".jpeg"
                return label
            }()
            delegateImage?.inputImage(imageView, imageURL.text ?? "vk.jpeg")
            //setupCollectionOrMessage()
            
            
            return cell
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let product = products[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductLikedCell else { return }
        let imageCell = cell.getImage() ?? #imageLiteral(resourceName: "VK")
        delegateCell?.inputCell(product: product, products: products, imageCell: imageCell)
    }
}

extension ViewAccount: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
}

extension ViewAccount: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 50, left: 25, bottom: 50, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 50
        return .init(width: width, height: collectionView.bounds.height)
    }
}

extension ViewAccount: AccountControllerInput {
    func didReceive(_ products: [Product]) {
    
        productsNew.removeAll()
        if products.count != 0 {
            for i in 0...(products.count-1) {
                let cliets = products[i].idClientLiked
                if cliets.first(where: { $0 == Auth.auth().currentUser?.uid}) != nil {
                    productsNew.append(products[i])
                }
            }
            self.products = productsNew
            if self.products.count == 0 {

            }
        }
        collectionView.reloadData()
    }
    
}
extension ViewAccount: ProductCellDescription {
    func didTabButton(nameProduct: String, isFavorit: Bool) {
        for i in 0...(products.count-1) {
            if products[i].name == nameProduct {
                if isFavorit {
                    for j in 0...(products[i].idClientLiked.count-1) {
                        if products[i].idClientLiked[j] == Auth.auth().currentUser?.uid ?? "" {
                            products[i].idClientLiked.remove(at: j)
                            flag = i
                            break
                        }
                    }
            }
        }
        }
        
        model.update(product: products[flag ?? 0])
        flag = nil
        collectionView.reloadData()
        //print("gggggggggg")
    }
        
}
