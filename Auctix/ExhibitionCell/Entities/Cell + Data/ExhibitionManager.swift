//
//  ExhibitionManager.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit
import Firebase

protocol ExhibitionManagerProtocol {
    var output: ExhibitionManagerOutput? { get set }
    func observeExhibitions()
}

protocol ExhibitionManagerOutput: AnyObject {
    func didReceive(_ exhibitions: [Exhibition])
    func didFail(with error: Error)
}

enum NetworkError: Error {
    case unexpected
}

class ExhibitionManager: ExhibitionManagerProtocol {
    var output: ExhibitionManagerOutput?
    static let shared: ExhibitionManagerProtocol = ExhibitionManager()
    private let database = Firestore.firestore()
    private let exhibitionConverter = ExhibitionConverter()
    
    private init(){}
    
    func observeExhibitions() {
        database.collection("exhibitions").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkError.unexpected)
                return
            }
            
            let exhibition = documents.compactMap { self?.exhibitionConverter.exhibition(from: $0) }
            self?.output?.didReceive(exhibition)
        }
    }
}

private final class ExhibitionConverter {
    enum Key: String {
        case name
        case city
        case country
        case startDate
        case expirationDate
    }
    
    func exhibition(from document: DocumentSnapshot) -> Exhibition? {
        guard let dict = document.data(),
              let name = dict[Key.name.rawValue] as? String,
              let city = dict[Key.city.rawValue] as? String,
              let country = dict[Key.country.rawValue] as? String,
              let expirationDate = dict[Key.expirationDate.rawValue] as? String,
              let startDate = dict[Key.startDate.rawValue] as? String else {
                  return nil
              }

        return Exhibition(name: name,
                          city: city,
                          country: country,
                          startDate: startDate,
                          expirationDate: expirationDate)
    }
}
