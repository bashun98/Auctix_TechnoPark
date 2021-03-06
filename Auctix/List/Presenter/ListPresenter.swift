//
//  ListPresenter.swift
//  Auctix
//
//  Created by Евгений Башун on 30.11.2021.
//

import FirebaseStorage

protocol ListPresenterDescription: AnyObject {
    init(view: ListViewInput, model: TableModelDescription)
}

class ListPresenter: ListPresenterDescription {
    let model: TableModelDescription!
    let view: ListViewInput!
   // let router: ListRouterInput!
    private let dateWithTime = Date()
    private let dateFormatter = DateFormatter()
    var data: [Exhibition]?
    var reference: StorageReference?
    var pickerData: [String] {
        return ["Name","City","Country"]
    }
    
    required init(view: ListViewInput, model: TableModelDescription) {
        self.view = view
        self.model = model
    }
}

extension ListPresenter: ListViewOutput {
//    func cellTapped() {
//        router.showProducts()
//    }
    
    var itemsCount: Int {
        return data?.count ?? 0
    }
    func getData() {
        model.loadProducts()
    }
    
    func sortData(by text: String) {
        switch text {
        case pickerData[0]:
            data?.sort(by: {$0.name < $1.name})
        case pickerData[1]:
            data?.sort(by: {$0.city < $1.city})
        case pickerData[2]:
            data?.sort(by: {$0.country < $1.country})
        default:
            return
        }
        view.reloadData()
    }
    
    func item(at index: Int) -> Exhibition {
        return data?[index] ?? Exhibition(name: "",
                                          city: "",
                                          country: "",
                                          startDate: "",
                                          expirationDate: "")
    }
    
    func getReference(with name: String, completion: @escaping (StorageReference) -> Void) {
        model.loadImage(with: name) { reference in
            completion(reference)
        }
    }
}

extension ListPresenter: ListModelOutput {
    func didReceive(_ exhibitions: [Exhibition]) {
        dateFormatter.dateFormat = "dd.MM.yy"
        let date = dateFormatter.string(from: dateWithTime)
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .year]
        let difference = Calendar.current as NSCalendar
        self.data = exhibitions.compactMap {
            if Int(difference.components(components, from: dateFormatter.date(from: date)!, to: dateFormatter.date(from: $0.expirationDate)!, options: []).day ?? 0) >= 0 {
                    return $0
                } else {
                    return nil
                }
            }
        //self.data = exhibitions
        view.reloadData()
    }
    
    func didRecieveReference(_ reference: StorageReference) {
        self.reference = reference
    }
}
