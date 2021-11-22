//
//  ListButtonViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import SnapKit
import SDWebImage

protocol ListViewControllerInput: AnyObject {
    func didReceive(_ exhibitions: [Exhibition])
}

class ListViewController: UIViewController {
    
    private var exhibitions: [Exhibition] = []
    private let sortingData = ["Name","City","Country"]
    private let container = UIView()
    private let picker = UIPickerView()
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    // private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    private var sortLabel: String = " "
    private let tableView = UITableView()
    private let model: TableModelDescription = TableModel()
    private var imageLoader = ExhibitionsImageLoader.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        setupModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
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
    
    private func setupNavBar() {
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "LIST"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont.get(with: .regular, size: 25)]
        navigationItem.backButtonTitle = "Back"
    }
    
    private func setupModel() {
        model.loadProducts()
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

//MARK: - List View Controller Input

extension ListViewController: ListViewControllerInput {
    func didReceive(_ exhibitions: [Exhibition]) {
        self.exhibitions = exhibitions
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
        let currentCellTxt = tableView.cellForRow(at: indexPath as IndexPath)! as? ExhibitionTableViewCell
        let rootVC = TableProductsController()
        rootVC.nameExhibition = currentCellTxt?.nameLabel.text ?? ""
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ListTableHeader else { return UITableViewHeaderFooterView()}
        header.buttonDelegate = self
        header.labelDelegate = self
        header.configurePickerView(with: sortingData)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
        cell.configure(with: exhibition)
        let imageView = cell.getImageView()
        let imageURL: UILabel = {
            let label = UILabel()
            label.text = exhibition.name + ".jpeg"
            return label
        }()
        setImage(for: imageView, with: imageURL.text ?? "vk.jpeg")
        cell.selectionStyle = .default
        return cell
    }
}

//MARK: - Table Header Output

extension ListViewController: HeaderOutput {
    func changeSortLabel(with label: String) {
        sortLabel = label
    }
    
    func doneButtonTapped() {
        if sortLabel == sortingData[0] {
            exhibitions.sort(by: {$0.name < $1.name})
        } else if sortLabel == sortingData[1] {
            exhibitions.sort(by: {$0.city < $1.city})
        } else {
            exhibitions.sort(by: {$0.country < $1.country})
        }
        tableView.reloadData()
    }
}

