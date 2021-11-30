//
//  ListButtonViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import SnapKit
import SDWebImage

//protocol ListViewControllerInput: AnyObject {
//    func didReceive(_ exhibitions: [Exhibition])
//}

final class ListViewController: UIViewController {
    
    private var exhibitions: [Exhibition] = []
    private let sortingData = ["Name","City","Country"]
    private var sortLabel: String = " "
    private let tableView = UITableView()
   // private let model: TableModelDescription = TableModel()
    private var imageLoader = ExhibitionsImageLoader.shared
    var presenter: ListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        presenter.getData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTableViewLayout()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(ExhibitionTableViewCell.self, forCellReuseIdentifier: ExhibitionTableViewCell.identifier)
        tableView.register(ListTableHeader.self, forHeaderFooterViewReuseIdentifier: ListTableHeader.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func setupTableViewLayout() {
        tableView.frame = view.bounds
    }
    
    private func setupNavBar() {
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "LIST"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont.get(with: .regular, size: 25)]
        navigationItem.backButtonTitle = "Back"
    }
    
    private func callPresenter() {
        presenter.getData()
//        model.loadProducts()
//        model.output = self
    }
    
    private func setImage(for imageView: UIImageView, with name: String) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageLoader.getReference(with: name) { reference in
            imageView.sd_setImage(with: reference, maxImageSize: 10 * 1024 * 1024, placeholderImage: nil) { _, error, _, _ in
                if error != nil {
                    imageView.image = #imageLiteral(resourceName: "VK")
                }
            }
        }
        
    }
}

//MARK: - List View Controller Input

extension ListViewController: ListViewControllerProtocol {
    func setData(_ data: [Exhibition]) {
        self.exhibitions = data
        tableView.reloadData()
    }
}

//MARK: - Table View Delegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleSelect(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListTableHeader.identifier) as? ListTableHeader else { return nil }
        header.buttonDelegate = self
        header.labelDelegate = self
        header.configurePickerView(with: sortingData)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    private func handleSelect(indexPath: IndexPath) {
        guard let currentCell = tableView.cellForRow(at: indexPath) as? ExhibitionTableViewCell else { return }
        let rootVC = TableProductsController()
        rootVC.nameExhibition = currentCell.nameLabel.text ?? ""
        navigationController?.pushViewController(rootVC, animated: true)
    }
}

//MARK: - Table View DataSource

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exhibitions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExhibitionTableViewCell.identifier, for: indexPath) as? ExhibitionTableViewCell else { return UITableViewCell()}
        let exhibition = exhibitions[indexPath.row]
        let imageView = cell.getImageView()
        cell.configure(with: exhibition)
        cell.selectionStyle = .default
        setCellsImage(imageView: imageView, name: exhibition.name)
        return cell
    }
    
    private func setCellsImage(imageView: UIImageView, name: String) {
        let imageURL: UILabel = {
            let label = UILabel()
            label.text = name + ".jpeg"
            return label
        }()
        setImage(for: imageView, with: imageURL.text ?? "vk.jpeg")
    }
}

//MARK: - Table Header Output

extension ListViewController: HeaderOutput {
    func changeSortLabel(with label: String) {
        sortLabel = label
    }
    func doneButtonTapped() {
        switch sortLabel {
        case sortingData[0]:
            exhibitions.sort(by: {$0.name < $1.name})
        case sortingData[1]:
            exhibitions.sort(by: {$0.city < $1.city})
        case sortingData[2]:
            exhibitions.sort(by: {$0.country < $1.country})
        default:
            return
        }
        tableView.reloadData()
    }
}


