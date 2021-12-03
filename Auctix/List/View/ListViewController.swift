//
//  ListButtonViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import SnapKit
import SDWebImage

final class ListViewController: UIViewController {
    
    private var sortLabel: String = " "
    private let tableView = UITableView()
    private var imageLoader = ExhibitionsImageLoader.shared
    var output: ListViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        output.getData()
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
    
    private func setImage(for imageView: UIImageView, with name: String) {
        output.getReference(with: name) { reference in
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: reference, maxImageSize: 10 * 1024 * 1024, placeholderImage: nil) { _, error, _, _ in
                if error != nil {
                    imageView.image = #imageLiteral(resourceName: "VK")
                }
            }
        }
        
    }
}

//MARK: - List View Controller Input

extension ListViewController: ListViewInput {
    func reloadData() {
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
        header.output = self
        header.configurePickerView(with: output.pickerData)
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
        return output.itemsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExhibitionTableViewCell.identifier, for: indexPath) as? ExhibitionTableViewCell else { return UITableViewCell()}
        let exhibition = output.item(at: indexPath.row)
        let imageView = cell.getImageView()
        cell.configure(with: exhibition)
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
    func changeSortLabel(with text: String) {
        sortLabel = text
    }
    func doneButtonTapped() {
        output.sortData(by: sortLabel)
    }
}


