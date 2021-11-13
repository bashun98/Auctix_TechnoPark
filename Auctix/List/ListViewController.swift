//
//  ListButtonViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import SnapKit

protocol ListViewControllerInput: AnyObject {
    func didReceive(_ exhibitions: [Exhibition])
}

class ListViewController: UIViewController {
    
    private var exhibitions: [Exhibition] = []
    private var header: ListTableHeader!
    private let sortingData = ["Name","City","Country"]
    private let container = UIView()
    private let picker = UIPickerView()
    private let toolBar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    private var sortLabel: String = " "
    private let tableView = UITableView()
    private let model: TableModelDescription = TableModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeader()
        setupPickerView()
        setupNavBar()
        setupModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
        setupPickerViewConstraints()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.register(ExhibitionTableViewCell.self, forCellReuseIdentifier: ExhibitionTableViewCell.identifier)
        tableView.register(ListTableHeader.self, forHeaderFooterViewReuseIdentifier: ListTableHeader.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func setupHeader() {
        header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListTableHeader.identifier) as? ListTableHeader
        header.delegate = self
    }
    
    private func setupPickerView() {
        picker.delegate = self
        picker.dataSource = self
        view.addSubview(container)
        container.addSubview(picker)
        container.addSubview(toolBar)
        picker.backgroundColor = .white
        toolBar.setItems([doneButton], animated: false)
        container.isUserInteractionEnabled = true
        container.isHidden = true
    }
    
    private func setupNavBar() {
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "LIST"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont.get(with: .regular, size: 40)]
        navigationItem.backButtonTitle = "Back"
    }
    
    private func setupModel() {
        model.loadProducts()
        model.output = self
    }
    
    private func setupPickerViewConstraints() {
        container.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height/3)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        picker.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        toolBar.snp.makeConstraints { make in
            make.top.equalTo(picker)
            make.width.equalToSuperview()
        }
    }
    
    @objc func doneButtonTapped() {
        container.isHidden = true
        if sortLabel == sortingData[0] {
            exhibitions.sort(by: {$0.name < $1.name})
        } else if sortLabel == sortingData[1] {
            exhibitions.sort(by: {$0.city < $1.city})
        } else {
            exhibitions.sort(by: {$0.country < $1.country})
        }
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
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
        rootVC.nameExhibition = currentCellTxt?.exhibitionName.text ?? ""
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        cell.selectionStyle = .default
        return cell
    }
    
}

//MARK: - Picker View Delegate

extension ListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        header.setupLabel(sortingData[row])
        sortLabel = sortingData[row]
    }
}

//MARK: - Picker View DataSource

extension ListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingData.count
    }
}

//MARK: - Table Header Output

extension ListViewController: HeaderOutput {
    func sortButtonTapped() {
        container.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}
