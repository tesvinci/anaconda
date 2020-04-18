//
//  Constant.swift
//  CoinAnaconda
//
//  Created by tesvinci on 7/14/18.
//  Copyright © 2018 tesvinci. All rights reserved.
//

import Foundation
typealias completionHandler = (Bool) -> Void
typealias completionHandler1 = (String) -> Void


let HEADERS = ["Content-Type" : "application/json"]
//BINANCE-------------------------------------
let BINANCE_URL_BASE = "https://api.binance.com"
let CONNECTIVITY_URL = "/api/v3/ping"
let SERVER_TIME_URL = "/api/v3/time"
let PRICE_TICKER_URL = "/api/v3/ticker/price"
let KLINE_URL = "/api/v3/klines"
let BUNGNEN: Float = 4 // dung de chinh do rong cua nen
let BUNGNEN1: Int = 4
// tao limit khi request
let LIMIT_KLINES = 160

enum Interval : String {
    case ONE_MINUTE = "1m"
    case THREE_MINUTES = "3m"
    case FIVE_MINUTES = "5m"
    case FIFTEEN_MINUTES = "15m"
    case THIRDTY_MINUTES = "30m"
    case ONE_HOUR = "1h"
    case TWO_HOURS = "2h"
    case FOUR_HOURS = "4h"
    case SIX_HOURS = "6h"
    case EIGHT_HOURS = "8h"
    case TWELFTH_HOURS = "12h"
    case ONE_DAY = "1d"
    case THREE_DAYS = "3d"
    case ONE_WEEK = "1w"
    case ONE_MONTH = "1M"
}

