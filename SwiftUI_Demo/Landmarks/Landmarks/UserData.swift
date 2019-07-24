//
//  UserData.swift
//  Landmarks
//
//  Created by Guiyang Li on 2019/7/24.
//  Copyright © 2019 Xin. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()

    var showFavoritesOnly = false {
        willSet {
            willChange.send()
        }
    }

    var landmarks = landmarkData {
        willSet {
            willChange.send()
        }
    }
}
