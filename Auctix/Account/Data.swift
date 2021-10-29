//
//  Data.swift
//  Auctix
//
//  Created by mac on 29.10.2021.
//

import Foundation
import UIKit

struct Section {
    let title: String
    let options: [SettingOptionType]
}

enum SettingOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}


struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    let isOn: Bool
}

