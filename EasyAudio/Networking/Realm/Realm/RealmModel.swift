//
//  RealmModel.swift
//  KFC
//
//  Created by Dong Nguyen on 12/12/19.
//  Copyright © 2019 TVT25. All rights reserved.
//

import Foundation
import RealmSwift

class FavouriteStringRealm: Object {
    @objc dynamic var urlString: String?

    init(urlStr: String) {
        super.init()
        self.urlString = urlStr
//        do {
//            self.urlString = try urlStr.toData()
//        } catch {
//            print("\(error.localizedDescription)")
//        }
    }
    required init() {
        super.init()
    }
}
