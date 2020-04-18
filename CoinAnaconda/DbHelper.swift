//
//  DbHelper.swift
//  CoinAnaconda
//
//  Created by tesvinci on 7/14/18.
//  Copyright © 2018 tesvinci. All rights reserved.
//
import Foundation
import RealmSwift
class DbHelper {
    static let sharedInstance = DbHelper()
    // khong tao realm with singleton
    
    fileprivate lazy var realm: Realm = {
        return try! Realm()
    }()
    private init() {
    }
}
//--------- BtcTicker----------------
extension DbHelper {
    func addBtcTicker (btcTicker: BtcTicker) {
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
        let results = realm.objects(BtcTicker.self)
        return results
    }
    
    
    func deleteAllBtcTicker() {
        let results = realm.objects(BtcTicker.self)
        for btcTicker in results {
            try! realm.write {
                realm.delete(btcTicker)
            }
        }
    }
}
//---------PotentialTicker ----------------
extension DbHelper {
    func addPotentialTicker (potentialTicker: PotentialTicker) {
        let predicate = NSPredicate(format: "symbol = %@",  potentialTicker.symbol)
        let result = realm.objects(PotentialTicker.self).filter(predicate).first
        if (result != nil) {
            return
        }
        else {
            try! realm.write {
                realm.add(potentialTicker)
            }
        }
    }
    func readPotentialTicker() -> Results<PotentialTicker> {
        let results = realm.objects(PotentialTicker.self)
        return results
    }
    
    func deleteAllPotentialTicker() {
        let results = realm.objects(PotentialTicker.self)
        if results.count != 0 {
            for potentialTicker in results {
                try! realm.write {
                    realm.delete(potentialTicker)
                }
            }
        }
        
    }
    
}

//---------General-------------------
