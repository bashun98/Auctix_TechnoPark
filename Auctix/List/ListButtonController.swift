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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExhibitionTableViewCell.self, forCellReuseIdentifier: ExhibitionTableViewCell.identifier)
        tableView.register(ListTableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.view.tintColor = UIColor.blueGreen
        navigationItem.title = "LIST"
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.blueGreen, NSAttributedString.Key.font: UIFont(name: FontsName.black.rawValue, size: 40) ?? UIFont.systemFont(ofSize: 36) ]
       
        exhibitions = ExhibitionManager.shared.loadExhibition()
        self.view.addSubview(tableView)
      //  view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


