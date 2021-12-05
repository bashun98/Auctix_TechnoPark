//
//  ListProtocols.swift
//  Auctix
//
//  Created by Евгений Башун on 03.12.2021.
//


import FirebaseStorage


protocol HeaderOutput: AnyObject {
    func doneButtonTapped()
    func changeSortLabel(with text: String)
}

protocol ListModelOutput: AnyObject {
    func didReceive(_ exhibitions: [Exhibition])
    func didRecieveReference(_ reference: StorageReference)
}

protocol ListViewOutput: AnyObject {
    var data: [Exhibition]? { get set }
    var reference: StorageReference? { get set }
    var pickerData: [String] { get }
    var itemsCount: Int { get }
    func getReference(with name: String, completion: @escaping (StorageReference) -> Void)
    func getData()
    func sortData(by text: String)
    func item(at index: Int) -> Exhibition
   // func cellTapped()
}

protocol ListViewInput: AnyObject {
    func reloadData()
}

protocol ExhibitionManagerOutput: AnyObject {
    func didReceive(_ exhibitions: [Exhibition])
    func didFail(with error: Error)
}

protocol ListRouterInput: AnyObject {
  //  func showProducts()
}
