//
//  ListButtonViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit
import SnapKit

class ListButtonTabViewController: UIViewController {
    
    private var exhibitions: [Exhibition] = []
    private var header: ListTableHeader!
    private let sortingData = ["Name","City","Country","New"]
    private let container = UIView()
    private let picker = UIPickerView()
    private let toolBar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    private var sortLabel: String = " "
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExhibitionTableViewCell.self, forCellReuseIdentifier: ExhibitionTableViewCell.identifier)
        tableView.register(ListTableHeader.self, forHeaderFooterViewReuseIdentifier: ListTableHeader.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        picker.delegate = self
        picker.dataSource = self
        header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListTableHeader.identifier) as? ListTableHeader
        header.delegate = self
        
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "LIST"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont.get(with: .black, size: 40)]
        
        exhibitions = ExhibitionManager.shared.loadExhibition()
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        setupPickerView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
        setupPickerViewConstaraints()
    }
    
    private func setupPickerView() {
        view.addSubview(container)
        container.addSubview(picker)
        container.addSubview(toolBar)
        picker.backgroundColor = .white
        toolBar.setItems([doneButton], animated: false)
        container.isUserInteractionEnabled = true
        container.isHidden = true
    }
    
    private func setupPickerViewConstaraints() {
        container.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height/3) // иправьте
            make.width.equalToSuperview()
        }
        toolBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }

        picker.snp.makeConstraints { make in
            make.top.equalTo(toolBar)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    @objc func doneButtonTapped() {
        container.isHidden = true
        if sortLabel == sortingData[0] {
            exhibitions.sort(by: {$0.title < $1.title})
        } else if sortLabel == sortingData[1] {
            exhibitions.sort(by: {$0.city < $1.city})
        } else if sortLabel == sortingData[2]{
            exhibitions.sort(by: {$0.country < $1.country})
        } else {
            exhibitions.sort(by: {$0.status < $1.status})
        }
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
}

extension ListButtonTabViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exhibitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExhibitionTableViewCell.identifier, for: indexPath) as? ExhibitionTableViewCell else { return UITableViewCell()}
        let exhibition = exhibitions[indexPath.row]
        cell.configure(with: exhibition)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootVC = TableProductsController()
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension ListButtonTabViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        header.setupLabel(sortingData[row])
        sortLabel = sortingData[row]
  //      tableView.reloadData()
    }
    
}

extension ListButtonTabViewController: HeaderOutput {
    func sortButtonTapped() {
        container.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
//    func filterButtonTapped(_ buttonLabel: UILabel) {
//        
//    }
}
