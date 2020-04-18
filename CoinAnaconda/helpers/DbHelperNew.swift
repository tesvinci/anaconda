//
//  DbHelperNew.swift
//  CoinAnaconda
//
//  Created by tesvinci on 7/14/18.
//  Copyright © 2018 tesvinci. All rights reserved.
//

import Foundation
import RealmSwift
class DbHelperNew {
    static let sharedInstance = DbHelperNew()
    // khong tao realm with singleton
    
    private init() {
    }
}
extension DbHelperNew {
    func addBtcTicker (btcTicker: BtcTicker) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "symbol = %@",  btcTicker.symbol)
        let result = realm.objects(BtcTicker.self).filter(predicate).first
        if (result != nil) {
            return
        }
        else {
            try! realm.write {
                realm.add(btcTicker)
            }
        }
    }
    func readBtcTicker() -> Results<BtcTicker> {
        let realm = try! Realm()
        let results = realm.objects(BtcTicker.self)
        return results
    }
    
    func deleteAllBtcTicker() {
        let realm = try! Realm()
        let results = realm.objects(BtcTicker.self)
        for btcTicker in results {
            try! realm.write {
                realm.delete(btcTicker)
            }
        }
    }
}

