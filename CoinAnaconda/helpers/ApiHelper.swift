//
//  ApiHelper.swift
//  CoinAnaconda
//
//  Created by tesvinci on 7/14/18.
//  Copyright © 2018 tesvinci. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class ApiHelper {
    func testConnectivity (url: String, completionHandler: @escaping completionHandler) {
        let url = URL(string: url)!
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: .default).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print ("khong connect duoc voi BINANCE", err)
                completionHandler(false)
                break
                
            case .success(let value):
                print ("da connect thanh cong toi BINANCE", value)
                completionHandler(true)
                break
            }
        }
    }
    func getServerTime(url: String, completionHandler : @escaping (Int64) -> Void) {
        let url = URL(string: url)!
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: .default).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                dump(err)
                break
            case .success(let value):
                let json =  JSON(value)
                let serverTime = json["serverTime"].int64Value
                completionHandler(Int64(serverTime))
                break
            }
            
        }
    }
    func getSymbolFromBinance(url: String) -> Void {
        print("get symbol")
        let url = URL(string: BINANCE_URL_BASE + PRICE_TICKER_URL)!
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: .default).responseJSON { (response) in
            print("ta da vo den day")
            if let results = response.value as? [AnyObject] {
                print("ta ko zo duoc day")
                for result in results {
                    if let ticker = result as? [String: String]{
                        let btcTicker = BtcTicker()
                        btcTicker.symbol = ticker["symbol"]
                        if btcTicker.symbol.hasSuffix("BTC"){
                            DbHelper.sharedInstance.addBtcTicker(btcTicker: btcTicker)
                        }
                    }
                    else{
                        print("khong xac dinh")
                    }
                }
            }
            else{
                print("request bi loi: ", response)
            }
        }
    }
 

    //--------------------Analize------------------------
    func getKline (params: Parameters, completionHandler: @escaping (String) -> Void) -> Void {
        let url = URL(string: BINANCE_URL_BASE + KLINE_URL)!
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: .default).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print("failure", err)
                completionHandler("err")
                break
            case .success(let value):
                //                print("sucess")
                //                print(value)
                let json = JSON(value)
                let arr = json.arrayValue
                if arr.isEmpty {
                    completionHandler("empty")
                }
                else {
                    var kline = Kline()
                    kline.openPrice = arr[0][1].floatValue
                    kline.highPrice = arr[0][2].floatValue
                    kline.lowPrice = arr[0][3].floatValue
                    kline.closePrice = arr[0][4].floatValue
                    kline.volume    = arr[0][5].floatValue
                    if (kline.closePrice / kline.openPrice) > 1.002
                    {
                        print("day la coin tiem nang")
                        completionHandler(params["symbol"] as! String)
                        //                        self.vibration()
                    }
                    else {
                        print("cung thuong thoi")
                        completionHandler("out")
                    }
                }
                break
            }
            
        }
    }
    func getKlines(params: Parameters, completionHandler: @escaping (Any) -> Void) -> Void {
        let url = URL(string: BINANCE_URL_BASE + KLINE_URL)!
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: .default).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print("failure", err)
                break
            case .success(let value):
                completionHandler(value)
                break
            }
        }
    }
    func getKlinesNew (url: String, params:Parameters, completionHandler: @escaping (JSON) -> Void) -> Void {
        print("da chay getKline")
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: .default).responseData {(response) in
            print("chua nhan ket qua tu getKline")
            switch response.result {
            case .failure(let err):
                dump(err)
                break
            case .success(let value):
                print("success")
                let json = JSON(value)
                completionHandler(json)
            }
            
        }
    }
 
    
//    func find(interval: Interval, completionHandler :  @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        //        print("aaaa")
//        queue.async {
//            while (0 < 1) {
//                //                print("lap lan thu: ", i)
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        print(serverTime)
//                        let endTime = serverTime
//                        let startTime: Int64
//                        switch interval {
//                        case .ONE_MINUTE:
//                            startTime = endTime - 60*1000
//                        case .FIVE_MINUTES:
//                            startTime = endTime - 5*60*1000
//                        case .FIFTEEN_MINUTES:
//                            startTime = endTime - 15*60*1000
//                        case .THIRDTY_MINUTES:
//                            startTime = endTime - 30*60*1000
//                        case .ONE_HOUR:
//                            startTime = endTime - 60*60*1000
//                        case .FOUR_HOURS:
//                            startTime = endTime - 4*60*60*1000
//                        case .ONE_DAY:
//                            startTime = endTime - 24*60*60*1000
//                        }
//                        //                        print("hohohohohoho")
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
////                        let queue1 = DispatchQueue(label: "kline")
//                        queue1.async {
//                            //                            print("eeeeeeeeee")
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
//                            //                            print("hishishis")
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKline(params: params) { (symbol) in
//                                    switch symbol {
//                                    case "out":
//                                        //                                        print("hahahohohihi")
//                                        d.signal()
//                                        break
//                                    case "err":
//                                        print("loi con me no roi")
//                                        d.signal()
//                                        break
//                                    case "empty":
//                                        print("trong khong")
//                                        d.signal()
//                                        break
//                                    default:
//                                        print("coin la",symbol)
//                                        completionHandler(symbol)
//                                        for _ in 0..<1 {
//                                            d.wait(timeout: .now() + 1)
//                                            self.alarm()
//                                        }
//                                        d.signal()
//                                        break
//                                    }
//                                    d.signal()
//                                }
//                                print("dang doi vong trong")
//                                d.wait(timeout: .now() + 0.1)
//                                d.wait()
//                            }
//                            print("vong lap voi so coin la" , a)
//                            q.signal()
//                        }
//                    }
//                    else {
//                        print("get server time is fail")
//                    }
//                })
//                print("dang doi vong ngoai")
////                q.wait(timeout: .now() + 60)
//                q.wait()
//            }
//        }
//    }
    // upgrade ----------------
    func getKline_V1 (params: Parameters, completionHandler: @escaping (Any) -> Void) -> Void {
        let url = URL(string: BINANCE_URL_BASE + KLINE_URL)!
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: .default).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print("failure", err)
                completionHandler("failure")
                break
            case .success(let value):
//                                print("sucess")
                //                print(value)
                let json = JSON(value)
                let arr = json.arrayValue
//                print(arr)
                if arr.isEmpty {
                    completionHandler("empty")
//                    print("empty")
                }
                else {
                    var kline = Kline()
                    kline.openPrice = arr[0][1].floatValue
                    kline.highPrice = arr[0][2].floatValue
                    kline.lowPrice = arr[0][3].floatValue
                    kline.closePrice = arr[0][4].floatValue
                    kline.volume    = arr[0][8].floatValue
                    completionHandler(kline)
                }
                break
            }
            
        }
    }
    //----------find_V1-----------
//    func find_V1(interval: Interval, overCondition: Float, completionHandler :  @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        //        print("aaaa")
//        queue.async {
//            while (0 < 1) {
//                //                print("lap lan thu: ", i)
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        print(serverTime)
//                        let endTime = serverTime
//                        let startTime: Int64
//                        switch interval {
//                        case .ONE_MINUTE:
//                            startTime = endTime - 60*1000
//                        case .FIVE_MINUTES:
//                            startTime = endTime - 5*60*1000
//                        case .FIFTEEN_MINUTES:
//                            startTime = endTime - 15*60*1000
//                        case .THIRDTY_MINUTES:
//                            startTime = endTime - 30*60*1000
//                        case .ONE_HOUR:
//                            startTime = endTime - 60*60*1000
//                        case .FOUR_HOURS:
//                            startTime = endTime - 4*60*60*1000
//                        case .ONE_DAY:
//                            startTime = endTime - 24*60*60*1000
//                        }
//                        //                        print("hohohohohoho")
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        //                        let queue1 = DispatchQueue(label: "kline")
//                        queue1.async {
//                            //                            print("eeeeeeeeee")
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
////                            print(dsBtcTicker.count)
////                             print(<#T##items: Any...##Any#>)
//                            //                            print("hishishis")
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
////                                print(btcTicker)
//                                a = a + 1
////                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": "1m", "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKline_V1(params: params, completionHandler: { (response) in
//                                    if let x: Kline = response as? Kline {
////                                        print(x.closePrice)
////                                        print(x.volume)
//
//                                        if
//                                            (x.closePrice / x.openPrice) > overCondition
////                                            x.closePrice > x.openPrice,
////                                            x.volume  > 15
//                                        {
//                                            print(x.volume)
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//                                            completionHandler(params["symbol"] as! String)
//                                            for _ in 0..<1 {
////                                                d.wait(timeout: .now() + 2)
////                                                self.alarm()
//
//                                            }
//                                        }
//                                        else {
//
//                                        }
//                                        d.signal()
//                                    }
//                                    else {
//                                        d.signal()
//                                    }
//                                    d.signal()
//                                })
////                                print("dang doi vong trong")
//                                d.wait(timeout: .now() + 0.001)
//                                d.wait()
//                            }
////                            print("vong lap voi so coin la")
//                            q.signal()
//                        }
//                    }
//                    else {
//                        print("get server time is fail")
//                    }
//                })
////                print("dang doi vong ngoai")
//                q.wait()
//                q.wait(timeout: .now() + 300)
//                print("vong lap voi so coin la")
//            }
//        }
//    }
    
    
    
//    func find_V12(dsPotentialCoin: [String], interval: Interval, overCondition: Float, completionHandler :  @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        //        print("aaaa")
//        queue.async {
//            while (0 < 1) {
//                //                print("lap lan thu: ", i)
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        print(serverTime)
//                        let endTime = serverTime
//                        let startTime: Int64
//                        switch interval {
//                        case .ONE_MINUTE:
//                            startTime = endTime - 60*1000
//                        case .FIVE_MINUTES:
//                            startTime = endTime - 5*60*1000
//                        case .FIFTEEN_MINUTES:
//                            startTime = endTime - 15*60*1000
//                        case .THIRDTY_MINUTES:
//                            startTime = endTime - 30*60*1000
//                        case .ONE_HOUR:
//                            startTime = endTime - 60*60*1000
//                        case .FOUR_HOURS:
//                            startTime = endTime - 4*60*60*1000
//                        case .ONE_DAY:
//                            startTime = endTime - 24*60*60*1000
//                        }
//                        //                        print("hohohohohoho")
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        //                        let queue1 = DispatchQueue(label: "kline")
//                        queue1.async {
//                            //                            print("hishishis")
//                            var a = 0;
//                            for btcTicker in dsPotentialCoin {
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKline_V1(params: params, completionHandler: { (response) in
//                                    if let x: Kline = response as? Kline {
//                                        if(x.highPrice / x.lowPrice) > overCondition,
//                                            x.closePrice > x.openPrice {
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//                                            completionHandler(params["symbol"] as! String)
//                                            for _ in 0..<1 {
//                                                d.wait(timeout: .now() + 1)
//                                                self.alarm()
//                                            }
//                                        }
//                                        else {
//
//                                        }
//                                        d.signal()
//                                    }
//                                    else {
//                                        d.signal()
//                                    }
//                                    d.signal()
//                                })
//                                print("dang doi vong trong")
////                                d.wait(timeout: .now() + 15)
//                                d.wait()
//                                d.wait(timeout: .now() + 0.5)
//                            }
//                            print("vong lap voi so coin la" , a)
//                            q.signal()
//                        }
//                    }
//                    else {
//                        print("get server time is fail")
//                    }
//                })
//                print("dang doi vong ngoai")
////                q.wait(timeout: .now() + 1)
//                q.wait()
//                q.wait(timeout: .now() + 1)
//            }
//        }
//    }
//    func find_V11(interval: Interval, overCondition: Float, completionHandler :  @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        //        print("aaaa")
//        queue.async {
//            while (0 < 1) {
//                //                print("lap lan thu: ", i)
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        print(serverTime)
//                        let endTime = serverTime
//                        let startTime: Int64
//                        switch interval {
//                        case .ONE_MINUTE:
//                            startTime = endTime - 60*1000
//                        case .FIVE_MINUTES:
//                            startTime = endTime - 5*60*1000
//                        case .FIFTEEN_MINUTES:
//                            startTime = endTime - 15*60*1000
//                        case .THIRDTY_MINUTES:
//                            startTime = endTime - 30*60*1000
//                        case .ONE_HOUR:
//                            startTime = endTime - 60*60*1000
//                        case .FOUR_HOURS:
//                            startTime = endTime - 4*60*60*1000
//                        case .ONE_DAY:
//                            startTime = endTime - 24*60*60*1000
//                        }
//                        //                        print("hohohohohoho")
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        //                        let queue1 = DispatchQueue(label: "kline")
//                        queue1.async {
//                            //                            print("eeeeeeeeee")
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
//                            //                            print("hishishis")
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": Interval.FIVE_MINUTES.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKline_V1(params: params, completionHandler: { (response) in
//
//                                    if let x: Kline = response as? Kline {
//                                        if(x.closePrice / x.openPrice) > overCondition{
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//                                            completionHandler(params["symbol"] as! String)
//                                            for _ in 0..<1 {
//                                                d.wait(timeout: .now() + 1)
//                                                self.alarm()
//                                            }
//                                        }
//                                        else {
//
//                                        }
//                                        d.signal()
//                                    }
//                                    else {
//                                        d.signal()
//                                    }
//                                    d.signal()
//                                })
//                                print("dang doi vong trong")
//                                d.wait(timeout: .now() + 0.1)
//                                d.wait()
//                            }
//                            print("vong lap voi so coin la" , a)
//                            q.signal()
//                        }
//                    }
//                    else {
//                        print("get server time is fail")
//                    }
//                })
//                print("dang doi vong ngoai")
//                q.wait()
//            }
//        }
//    }
    
    
//    func find_V2(interval: Interval, overCondition1: Float, overCondition2: Float, completionHandler :  @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        let queue2 = DispatchQueue(label: "klineV2")
//        //        print("aaaa")
//        queue.async {
//            while (0 < 1) {
//                //                print("lap lan thu: ", i)
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        print(serverTime)
//                        let endTime = serverTime
//                        let startTime: Int64
//                        switch interval {
//                        case .ONE_MINUTE:
//                            startTime = endTime - 60*1000
//                        case .FIVE_MINUTES:
//                            startTime = endTime - 5*60*1000
//                        case .FIFTEEN_MINUTES:
//                            startTime = endTime - 15*60*1000
//                        case .THIRDTY_MINUTES:
//                            startTime = endTime - 30*60*1000
//                        case .ONE_HOUR:
//                            startTime = endTime - 60*60*1000
//                        case .FOUR_HOURS:
//                            startTime = endTime - 4*60*60*1000
//                        case .ONE_DAY:
//                            startTime = endTime - 24*60*60*1000
//                        }
//                        //                        print("hohohohohoho")
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        //                        let queue1 = DispatchQueue(label: "kline")
//                        queue1.async {
//                            //                            print("eeeeeeeeee")
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
//                            //                            print("hishishis")
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
//                                let b = btcTicker.symbol!
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKline_V1(params: params, completionHandler: { (response) in
//                                    if let x: Kline = response as? Kline {
//                                        if(x.highPrice / x.lowPrice) >= overCondition1,
//                                            (x.closePrice > x.openPrice){
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//                                            completionHandler(params["symbol"] as! String)
//                                            for _ in 0..<1 {
//                                                d.wait(timeout: .now() + 1)
//                                                self.alarm()
//                                            }
//                                        }
//                                        else {
//                                            if (x.highPrice / x.lowPrice) >= overCondition2,
//
//
//                                                x.closePrice > x.openPrice  {
//                                                print("day la truong hop thu 2")
//                                                let endTime1 = endTime - 60*1000
//                                                let startTime1 = startTime - 60*1000
//                                                var params1: Parameters = ["symbol": b , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime1, "endTime":endTime1]
//                                                let e = DispatchSemaphore(value: 0)
//                                                queue2.async {
//
//
//                                                self.getKline_V1(params: params1, completionHandler: { (response) in
//                                                    if let y: Kline = response as? Kline {
//                                                        print("day la truong hop thu 3")
//                                                        if (y.highPrice / y.lowPrice) < 1.001, (y.closePrice / y.openPrice) < 1.001 {
//                                                            print("day cung la coin tiem nang")
//                                                            completionHandler(b)
//                                                            for _ in 0..<1 {
//                                                                d.wait(timeout: .now() + 1)
//                                                                self.alarm()
//                                                            }
//                                                            e.signal()
//                                                        }
//                                                        else {
//                                                            e.signal()
//                                                        }
//                                                        e.signal()
//                                                    }
//                                                    else{
//                                                      print("day la truong hop thu 4")
//                                                        e.signal()
//                                                    }
//                                                    e.signal()
//                                                })
//                                                e.wait()
//                                            }
//                                            }
//                                            else {
//
//                                            }
//                                        }
//                                        d.signal()
//                                    }
//                                    else {
//                                        d.signal()
//                                    }
//                                    d.signal()
//                                })
//                                print("dang doi vong trong")
//                                d.wait(timeout: .now() + 0.1)
//                                d.wait()
//                            }
//                            print("vong lap voi so coin la" , a)
//                            q.signal()
//                        }
//                    }
//                    else {
//                        print("get server time is fail")
//                    }
//                })
//                print("dang doi vong ngoai")
//                q.wait()
//            }
//        }
//    }
    //detect 0 value for kline
//    func find_V3(interval: Interval, overCondition: Float, completionHandler :  @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        //        print("aaaa")
//        queue.async {
//            while (0 < 1) {
//                //                print("lap lan thu: ", i)
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        print(serverTime)
//                        let endTime = serverTime
//                        let startTime: Int64
//                        switch interval {
//                        case .ONE_MINUTE:
//                            startTime = endTime - 60*1000
//                        case .FIVE_MINUTES:
//                            startTime = endTime - 5*60*1000
//                        case .FIFTEEN_MINUTES:
//                            startTime = endTime - 15*60*1000
//                        case .THIRDTY_MINUTES:
//                            startTime = endTime - 30*60*1000
//                        case .ONE_HOUR:
//                            startTime = endTime - 60*60*1000
//                        case .FOUR_HOURS:
//                            startTime = endTime - 4*60*60*1000
//                        case .ONE_DAY:
//                            startTime = endTime - 24*60*60*1000
//                        }
//                        //                        print("hohohohohoho")
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        //                        let queue1 = DispatchQueue(label: "kline")
//                        queue1.async {
//                            //                            print("eeeeeeeeee")
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
//                            //                            print("hishishis")
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKline_V1(params: params, completionHandler: { (response) in
//                                    if let x: Kline = response as? Kline {
//                                        if (x.highPrice / x.lowPrice) <= overCondition,
//                                            (x.closePrice > x.openPrice)  {
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//                                            completionHandler(params["symbol"] as? String)
//                                            for _ in 0..<1 {
//                                                d.wait(timeout: .now() + 1)
//                                                self.alarm()
//                                            }
//                                        }
//                                        else {
//
//                                        }
//                                        d.signal()
//                                    }
//                                    else {
//                                        d.signal()
//                                    }
//                                    d.signal()
//                                })
//                                print("dang doi vong trong")
//                                d.wait(timeout: .now() + 0.1)
//                                d.wait()
//                            }
//                            print("vong lap voi so coin la" , a)
//                            q.signal()
//                        }
//                    }
//                    else {
//                        print("get server time is fail")
//                    }
//                })
//                print("dang doi vong ngoai")
//                q.wait()
//                q.wait(timeout: .now() + 300)
//            }
//        }
//    }
    
    


    
//    func detect_V3(numberOfKline: Int64, completionHandler: @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        queue.async {
//            while (0<1){
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        let endTime = serverTime
//                        let startTime = endTime - numberOfKline * 60 *  60 * 1000
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        queue1.async {
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": Interval.ONE_HOUR.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKlines(params: params, completionHandler: { (response) in
//                                    let json = JSON(response)
//                                    let arr = json.arrayValue
//                                    if arr.count > 5 {
//                                        var kline_0 = Klines()
//                                        var kline_1 = Klines()
//                                        var kline_2 = Klines()
//                                        var kline_3 = Klines()
//                                        var kline_4 = Klines()
//                                        var kline_5 = Klines()
//
//                                        print(params["symbol"] as! String)
//
//                                        kline_0.highPrice = arr[0][2].floatValue
//                                        print(kline_0.highPrice)
//
//
//
//
//                                        kline_1.highPrice = arr[1][2].floatValue
//                                        print(kline_1.highPrice)
//
//
//                                        kline_2.highPrice = arr[2][2].floatValue
//                                        print(kline_2.highPrice)
//
//
//                                        kline_3.highPrice = arr[3][2].floatValue
//                                        print(kline_3.highPrice)
//
//
//                                        kline_4.highPrice = arr[4][2].floatValue
//                                        print(kline_4.highPrice)
//
//
//                                        kline_5.highPrice = arr[5][2].floatValue
//                                        print(kline_5.highPrice)
//
//                                        if kline_5.highPrice > max(kline_4.highPrice, max(kline_3.highPrice, max(kline_2.highPrice, max(kline_1.highPrice, kline_0.highPrice)))) {
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//
//
//                                            completionHandler(params["symbol"] as! String)
//                                            for _ in 0..<1 {
//                                                d.wait(timeout: .now() + 1)
//                                                self.alarm()
//                                            }
//                                        }
//                                        else {}
//
//                                    }
//                                    else {
//                                        print("mang tra ve bang 0")
//                                    }
//                                    d.signal()
//
//                                })
//                                d.wait()
//                            }
//                        }
//                    }
//                    q.signal()
//                })
//                q.wait()
//                q.wait(timeout: .now() + 60)
//            }
//        }
//
//    }
    
    
//    func track(numberOfKline : Int64, symbol: String) -> Void {
//        let queueSemaphore_V1 = DispatchSemaphore(value: 0)
//        let queue_V1 = DispatchQueue(label: "V1")
//        let queue_V2 = DispatchQueue(label: "V2")
//        queue_V1.async {
//            while (0<1){
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    print(serverTime)
//                    if serverTime != 0 {
//                        let endTime = serverTime
//                        let startTime = endTime - numberOfKline * 60 * 1000
//                        var params: Parameters!
//                        let limit = 500
//                        let queueSemaphore_V2 = DispatchSemaphore(value: 0)
//                        queue_V2.async {
//                            params = ["symbol": symbol , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                            self.getKlines(params: params, completionHandler: { (response) in
//                                print("haha")
//                                let json = JSON(response)
//                                let arr = json.arrayValue
//                                if arr.count > numberOfKline - 1 {
//                                    var kline_0 = Klines()
//                                    var kline_1 = Klines()
//                                    var kline_2 = Klines()
//                                    var kline_3 = Klines()
//                                    kline_0.openTime = arr[0][0].int64Value
//                                    kline_0.openPrice = arr[0][1].floatValue
//                                    kline_0.highPrice = arr[0][2].floatValue
//                                    kline_0.lowPrice = arr[0][3].floatValue
//                                    kline_0.closePrice = arr[0][4].floatValue
//                                    kline_0.volume = arr[0][5].floatValue
//
//                                    kline_1.openTime = arr[1][0].int64Value
//                                    kline_1.openPrice = arr[1][1].floatValue
//                                    kline_1.highPrice = arr[1][2].floatValue
//                                    kline_1.lowPrice = arr[1][3].floatValue
//                                    kline_1.closePrice = arr[1][4].floatValue
//                                    kline_1.volume = arr[1][5].floatValue
//
//                                    kline_2.openTime = arr[2][0].int64Value
//                                    kline_2.openPrice = arr[2][1].floatValue
//                                    kline_2.highPrice = arr[2][2].floatValue
//                                    kline_2.lowPrice = arr[2][3].floatValue
//                                    kline_2.closePrice = arr[2][4].floatValue
//                                    kline_2.volume = arr[2][5].floatValue
//
////                                    kline_3.openTime = arr[3][0].int64Value
////                                    kline_3.openPrice = arr[3][1].floatValue
////                                    kline_3.highPrice = arr[3][2].floatValue
////                                    kline_3.lowPrice = arr[3][3].floatValue
////                                    kline_3.closePrice = arr[3][4].floatValue
////                                    kline_3.volume = arr[3][5].floatValue
//
//                                    if  (1>0) {
//                                        print(kline_0.highPrice)
//                                        print(kline_1.highPrice)
//                                        print(kline_2.highPrice)
//                                        print(kline_3.highPrice)
//                                            print("alarm")
//                                        for _ in 0..<1 {
//                                            queueSemaphore_V2.wait(timeout: .now() + 1)
//                                            self.alarm()
//                                        }
//                                    }
//
//                                }
//                                queueSemaphore_V2.signal()
//                            })
//                            queueSemaphore_V2.wait()
//                        }
//                    }
//                    queueSemaphore_V1.signal()
//
//                })
//                queueSemaphore_V1.wait()
//                queueSemaphore_V1.wait(timeout: .now() + 60)
//            }
//        }
//
//    }
    
    
    
//    func detect_V1(completionHandler: @escaping (String?) -> Void) -> Void {
//        let q = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue(label: "find")
//        let queue1 = DispatchQueue(label: "kline")
//        queue.async {
//            while (0<1){
//                self.getServerTime(url: BINANCE_URL_BASE + SERVER_TIME_URL, completionHandler: { (serverTime) in
//                    if serverTime != 0 {
//                        let endTime = serverTime
//                        let startTime = endTime - 2 * 60 * 1000
//                        var params: Parameters!
//                        let limit = 500
//                        let d = DispatchSemaphore(value: 0)
//                        queue1.async {
//                            let dsBtcTicker = DbHelperNew.sharedInstance.readBtcTicker()
//                            var a = 0;
//                            for btcTicker in dsBtcTicker {
//                                a = a + 1
//                                print("so lan lap la: ", a)
//                                params = ["symbol": btcTicker.symbol!  , "interval": Interval.ONE_MINUTE.rawValue, "limit":limit, "startTime": startTime, "endTime":endTime]
//                                self.getKlines(params: params, completionHandler: { (response) in
//                                    let json = JSON(response)
//                                    let arr = json.arrayValue
//                                    if arr.count > 1 {
//                                        var kline_0 = Klines()
//                                        var kline_1 = Klines()
//
//                                        kline_0.highPrice = arr[0][2].floatValue
//                                        kline_0.lowPrice = arr[0][3].floatValue
//                                        kline_0.closePrice = arr[0][4].floatValue
//                                        kline_0.openPrice = arr[0][1].floatValue
//                                        
//
//                                        kline_1.highPrice = arr[1][2].floatValue
//                                        kline_1.lowPrice = arr[1][3].floatValue
//                                        kline_1.closePrice = arr[1][4].floatValue
//                                        kline_1.openPrice = arr[1][1].floatValue
//                            
//                                        if (kline_1.highPrice / kline_0.highPrice) > 1.002,
//                                            kline_0.highPrice > kline_0.lowPrice,
//                                            kline_1.highPrice > kline_1.lowPrice,
//                                            (kline_1.lowPrice / kline_0.lowPrice) > 1.001
//                                            
//                                            {
//                                            print("day la coin tiem nang", params["symbol"] as! String)
//                                            
//                                            
//                                            completionHandler(params["symbol"] as! String)
//                                            for _ in 0..<1 {
//                                                d.wait(timeout: .now() + 1)
//                                                self.alarm()
//                                            }
//                                        }
//                                        else {}
//                                        
//                                    }
//                                    else {
//                                        print("mang tra ve bang 0")
//                                    }
//                                    d.signal()
//                                    
//                                })
//                                d.wait()
//                            }
//                        }
//                    }
//                    q.signal()
//                })
//                q.wait()
////                q.wait(timeout: .now() + 60)
//            }
//        }
//        
//    }
    // tao array list tim nang va track theo lien tuc
//    static func trackByList (potentialList) {
//        
//    }
    
    
    

    
}

