//
//  ViewController.swift
//  CoinAnaconda
//
//  Created by tesvinci on 7/14/18.
//  Copyright © 2018 tesvinci. All rights reserved.
//

import UIKit
import Foundation
import  Alamofire
import SwiftyJSON
import RealmSwift


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var lineWidth = 1
    var lineWidth2 = 1
    var loopRunning = false
    
    
    // lay dsBtc
    let dsBtcTickers = DbHelperNew.sharedInstance.readBtcTicker()
  
    
    // khai bao danh sach interval
    let lstInterval: [String] = ["1m", "3m", "5m", "15m", "30m", "1h", "2h", "4h", "6h", "8h", "12h", "1d", "3d", "1w", "1M"]
    
    var dsPotentialTicker: [String] = ["1"]

    let apiHelper = ApiHelper() // khoi tao ApiHelper
    

    let defaults = UserDefaults.standard // check first launch
    
    var listTicker : [String] = [""]
    var statusLoop: Bool = false
    
    
    let vCandle = UIView()
    let btnChuyenCoinNew = UIButton()
    let btnNextNew = UIButton()
    let btnBackNew = UIButton()
    let btnPlay = UIButton()
    let btnPause = UIButton()

    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnChuyenCoin: UIButton!
    
    @IBOutlet weak var btnStop: UIButton!
    
    
    
    @IBOutlet weak var btnInterval: UIButton!
    
    @IBOutlet weak var tbvInterval: UITableView!
    
    var indexBtc = -1
    
    /*
    th1: indexBtc = - 1
       next index tang len  0 thi ve cai dau tien
       back index giam xuong - 2 thi ve cai cuoi cung
    th2: indexBtc = 0
       next index tang len 1 thi va cai thu 2
       back index giam xuong - 1 thi ve cai cuoi cung
    th3: indexBtc = cuoi cung
       next index = 0 ve cai dau tien
       back index = ke cuoi ve cai ke cuoi
    Nhu vay nghia la index = -2 hoac -1 deu ve cai cauoi cung
    */
 
     
    

    
    @IBAction func btnSelectInterval(_ sender: Any) {
        self.tbvInterval.isHidden = !self.tbvInterval.isHidden
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        vCandle.backgroundColor = UIColor.black
//        vCandle.frame = CGRect(x: 16, y: self.view.bounds.size.height / 2, width: (self.view.bounds.size.width - (16 * 2)), height: (self.view.bounds.size.height - (16 * 2))/2 )
//
//        self.view.addSubview(vCandle)
        setupView()
//        addActionToView()
        setupButton()
        addActionToButton()
        
        

        
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        vCandle.backgroundColor = UIColor.black
        vCandle.frame = CGRect(x: 16, y: self.view.bounds.size.height / 2, width: (self.view.bounds.size.width - (16 * 2)), height: (self.view.bounds.size.height - (16 * 2))/2 )
        setupButton()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // khi hien thi giao dien thi an tableview
        self.tbvInterval.isHidden = true

        print(defaults.string(forKey: "Interval"))
        
        defaults.set("1d", forKey: "Interval")
        // kiem tra interval dang o cai gi hien thi len btnInterval
        btnInterval.setTitle(defaults.string(forKey: "Interval"), for: .normal)

        apiHelper.getSymbolFromBinance(url: BINANCE_URL_BASE + PRICE_TICKER_URL) //lay danh sach ticker
        
        
        
        
        
        
        
        
        

        }
    func setupView() {
        // main view
        self.view.backgroundColor = UIColor.black
        
        // candle view
        vCandle.backgroundColor = UIColor.black
        vCandle.frame = CGRect(x: 16, y: self.view.bounds.size.height / 2, width: (self.view.bounds.size.width - (16 * 2)), height: (self.view.bounds.size.height - (16 * 2))/2 )
        self.view.addSubview(vCandle)
        
    }
    func addActionToView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(autoPlay))
        self.vCandle.addGestureRecognizer(gesture)
    }
    @objc func autoPlay () {
        print("play hjhj")
    }
    
    func setupButton() {
        
        let backgroundColor = UIColor.init(red: 50/255, green: 190/255, blue: 135/255, alpha: 100)
        let mainViewWidth   = self.view.bounds.size.width
        let mainViewHeight  = self.view.bounds.size.height
        
        
        
        // back Button
        btnBackNew.backgroundColor = backgroundColor
        btnBackNew.frame = CGRect(x: 16, y: (mainViewHeight / 2) - (16 + mainViewHeight / 15), width: (mainViewWidth / 4) - (16 + 8) , height: mainViewHeight / 15)
        
        btnBackNew.setTitle("BACK", for: .normal)
        self.view.addSubview(btnBackNew)
        // play Button
        btnPlay.backgroundColor = backgroundColor
        btnPlay.frame = CGRect(x: mainViewWidth / 4 + 8, y: (mainViewHeight / 2) - (16 + mainViewHeight / 15), width: (mainViewWidth / 4) - (8 + 8), height: mainViewHeight / 15)
        btnPlay.setTitle("PLAY", for: .normal)
        self.view.addSubview(btnPlay)
        // pause button
        btnPause.backgroundColor = backgroundColor
        btnPause.frame = CGRect(x: mainViewWidth/2 + 8, y: (mainViewHeight / 2) - (16 + mainViewHeight / 15), width: (mainViewWidth / 4) - (8 + 8), height: mainViewHeight / 15)
        btnPause.setTitle("PAUSE", for: .normal)
        self.view.addSubview(btnPause)
        
        // next Button
        btnNextNew.backgroundColor = backgroundColor
        btnNextNew.frame = CGRect(x: (3 * mainViewWidth / 4 + 8), y: (mainViewHeight / 2) - (16 + mainViewHeight / 15), width: (mainViewWidth / 4) - (16 + 8), height: mainViewHeight / 15)
        btnNextNew.setTitle("NEXT", for: .normal)
        self.view.addSubview(btnNextNew)
        
        
    }
    func addActionToButton() {
        btnNextNew.addTarget(self, action: #selector(nextBtcNew), for: .touchUpInside)
        btnBackNew.addTarget(self, action: #selector(backBtcNew), for: .touchUpInside)
        btnPlay.addTarget(self, action: #selector(play), for: .touchUpInside)
        btnPause.addTarget(self, action: #selector(pause), for: .touchUpInside)
        
    }
    @objc func nextBtcNew() {
        print("next")
        if self.statusLoop != true {
        self.vCandle.layer.sublayers = nil
        // khi bam next thi tang indexBtc len 1
            indexBtc = indexBtc + 1

                if (indexBtc < dsBtcTickers.count){
        //            print(dsBtcTickers[i])
                    btnChuyenCoin.setTitle(dsBtcTickers[indexBtc].symbol, for: .normal)
                    drawCandle(symbol: dsBtcTickers[indexBtc].symbol!)
                }
                else{
                    indexBtc = 0
                    btnChuyenCoin.setTitle(dsBtcTickers[indexBtc].symbol, for: .normal)
                    drawCandle(symbol: dsBtcTickers[indexBtc].symbol!)
                }
        }
    }
    @objc func backBtcNew() {
        print("back")
               if self.statusLoop != true {
               self.vCandle.layer.sublayers = nil
               // khi bam back thi giam indexBtc di 1
                   indexBtc = indexBtc - 1

                       if (indexBtc > -1){
               //            print(dsBtcTickers[i])
                           btnChuyenCoin.setTitle(dsBtcTickers[indexBtc].symbol, for: .normal)
                           drawCandle(symbol: dsBtcTickers[indexBtc].symbol!)
                           
                       }
                       else{
                           indexBtc = dsBtcTickers.count - 1
                           btnChuyenCoin.setTitle(dsBtcTickers[indexBtc].symbol, for: .normal)
                           drawCandle(symbol: dsBtcTickers[indexBtc].symbol!)
                       }
        
               }
        
    }
    @objc func play() {
        // kiem tra false thi set len true con neu true thi de im cho no chay
        if !statusLoop {
            statusLoop = true
            btcLoopNew2(indexBtc: self.indexBtc)
        } else {
            // deo lam gi
        }
        
    }
    @objc func pause() {
        if statusLoop {
                    statusLoop = false
        //            drawCandle(symbol: dsBtcTickers[self.indexBtc].symbol!)
        }
    }
        

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstInterval.count
    }
    
    // Hien thi du lieu len tung cell trong table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellInterval", for: indexPath)
        // Gan thong tin hien thi
        cell.textLabel?.text = lstInterval[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        // Gan cho btnInterval
        self.btnInterval.setTitle(cell?.textLabel?.text, for: .normal)
        // An thong tin table view
        self.tbvInterval.isHidden = true
        // set gia tri interval xuong userDefault
        defaults.set(cell?.textLabel?.text, forKey: "Interval")
        
    }
   
    
    func drawCandleNew(symbol: String) {

        var params = Parameters()
        print("do ko troi ", symbol)
        params = ["symbol": symbol , "interval": defaults.string(forKey: "Interval")!, "limit":LIMIT_KLINES]
        apiHelper.getKlinesNew(url: BINANCE_URL_BASE + KLINE_URL, params: params) { (candleJSON) in
            // da co duoc bo du lieu tu day tro di la xu ly do thi va ve
            //----------------// xu ly do thi------------------------------------------
            // tim max va min trong so luong
//            print(candleJSON.count)
            var currentMinPrice = candleJSON[0][3].floatValue
            var currentMaxPrice = candleJSON[0][2].floatValue
            for i in 1 ..< candleJSON.count {
                if currentMaxPrice < candleJSON[i][2].floatValue {
                    currentMaxPrice = candleJSON[i][2].floatValue
                } else {
                    //khong lam chi het
                }
                if currentMinPrice > candleJSON[i][3].floatValue {
                    currentMinPrice = candleJSON[i][3].floatValue
                }else {
                    // khong lam chi het
                }
            }
            //  tim gia tri scale gia tri lon nhat < 300
            var scale = -1
            var tempMaxPrice = currentMaxPrice
            
            while tempMaxPrice < 250 {
                tempMaxPrice = tempMaxPrice * 10
                scale = scale + 1
            }
            // tien hanh ve
            // item dau tien trong mang la cay nen moi nhat se co x = widthOfView
            // Do rong bung nen la 2 tuong ung voi toa do x cua cay nen la 2
            // Kiem tra interval de dua
            // chuyen json ve trat tu nguoc lai roi duyet lai
            //            let reverseCandleArray = []
            //            for item in candleArray.count {
            //                reverseCandleArray.append(item)
            //            }
            
            var i = 0
            // chuyen JSON vao trat tu nguoc lai de ve len bieu do
            for item in  candleJSON.reversed() {
                let candle = item.1
                var kline = Klines()
                // map du lieu vao kline
                kline.openTime = candleJSON[i][0].int64Value
                kline.openPrice = candle[1].floatValue
                kline.highPrice = candle[2].floatValue
                kline.lowPrice = candle[3].floatValue
                kline.closePrice = candle[4].floatValue
                
                // bat dau tinh toan cho do thi x y
                let deltaOfMaxMinPrice = Double((currentMaxPrice - currentMinPrice)) * pow(10,Double(scale))
                let heightOfView = self.vCandle.frame.height // chieu cao cua khung
                let widthOfView = self.vCandle.frame.width
                // xu ly du lieu cho phu hop voi do thi map voi kline
                
                let bufferOpenPrice = Float(heightOfView) - ((kline.openPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                let bufferHighPrice = Float(heightOfView) - ( (kline.highPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                let bufferLowPrice = Float(heightOfView) - ( (kline.lowPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                let bufferClosePrice = Float(heightOfView) - ( (kline.closePrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                let xPositionOfCandle: Float = Float(widthOfView) - Float(2*i)


                // start to draw
                
                let path = UIBezierPath()
                // tam thoi khong can high va low
                path.move(to: CGPoint(x:Int(xPositionOfCandle-BUNGNEN/2), y:Int(bufferHighPrice))) // move toi diem high
                path.addLine(to: CGPoint(x:Double(xPositionOfCandle - BUNGNEN/2), y: Double(bufferLowPrice))) // add line toi low
                path.move(to: CGPoint(x:Int(xPositionOfCandle), y:Int(bufferOpenPrice))) // move toi diem open ben phai truc high
                path.addLine(to: CGPoint(x:Double(xPositionOfCandle - BUNGNEN), y: Double(bufferOpenPrice))) // add line toi open ben truc y
                path.addLine(to: CGPoint(x:Double(xPositionOfCandle - BUNGNEN), y: Double(bufferClosePrice))) // move qua truc tung tao bung nen
                path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferClosePrice))) // add line xuong close
                path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferOpenPrice))) // add line xuong close
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                // kiem tra neu open < = close thi stroke va fill la mau green con lai thi la red
                if (kline.openPrice < kline.closePrice){
                    shapeLayer.strokeColor = UIColor.green.cgColor
                    shapeLayer.fillColor = UIColor.green.cgColor
                } else {
                    shapeLayer.strokeColor = UIColor.red.cgColor
                    shapeLayer.fillColor = UIColor.red.cgColor
                }
                shapeLayer.lineWidth = 1
                self.vCandle.layer.addSublayer(shapeLayer)
                
            i = i + 1 // lui vi tri x de ve candle tiep theo
                print("hihihihihihi",i)
                

            }
            
        }
    }
    
    
    func btcLoop() {
        let q = DispatchSemaphore(value:0)
        let queue1 = DispatchQueue(label: "kline")
        queue1.async {
            while 0 < 1 {
            let dsBtcTickers = DbHelperNew.sharedInstance.readBtcTicker()
            // lap
            for item in dsBtcTickers {
                let a = item.symbol._rlmInferWrappedType()
                DispatchQueue.main.async {
                    self.btnChuyenCoin.setTitle(a, for: .normal)
                }
                
                
                var params = Parameters()
                params = ["symbol": item.symbol! , "interval": self.defaults.string(forKey: "Interval")!, "limit":LIMIT_KLINES]
                print("item la", item)
                self.apiHelper.getKlinesNew(url: BINANCE_URL_BASE + KLINE_URL, params: params, completionHandler: {  (candleJSON) in

                    print("kho he")
                    // da co duoc bo du lieu tu day tro di la xu ly do thi va ve
                    //----------------// xu ly do thi------------------------------------------
                    // tim max va min trong so luong
                    //            print(candleJSON.count)
                    var currentMinPrice = candleJSON[0][3].floatValue
                    var currentMaxPrice = candleJSON[0][2].floatValue
                    for i in 1 ..< candleJSON.count {
                        if currentMaxPrice < candleJSON[i][2].floatValue {
                            currentMaxPrice = candleJSON[i][2].floatValue
                        } else {
                            //khong lam chi het
                        }
                        if currentMinPrice > candleJSON[i][3].floatValue {
                            currentMinPrice = candleJSON[i][3].floatValue
                        }else {
                            // khong lam chi het
                        }
                    }
                    //  tim gia tri scale gia tri lon nhat < 300
                    var scale = -1
                    var tempMaxPrice = currentMaxPrice
                    
                    while tempMaxPrice < 250 {
                        tempMaxPrice = tempMaxPrice * 10
                        scale = scale + 1
                    }
                    // tien hanh ve
                    // item dau tien trong mang la cay nen moi nhat se co x = widthOfView
                    // Do rong bung nen la 2 tuong ung voi toa do x cua cay nen la 2
                    // Kiem tra interval de dua
                    // chuyen json ve trat tu nguoc lai roi duyet lai
                    //            let reverseCandleArray = []
                    //            for item in candleArray.count {
                    //                reverseCandleArray.append(item)
                    //            }
                    
                    var i = 0
                    // chuyen JSON vao trat tu nguoc lai de ve len bieu do
                    for item in  candleJSON.reversed() {
                        let candle = item.1
                        var kline = Klines()
                        // map du lieu vao kline
                        kline.openTime = candleJSON[i][0].int64Value
                        kline.openPrice = candle[1].floatValue
                        kline.highPrice = candle[2].floatValue
                        kline.lowPrice = candle[3].floatValue
                        kline.closePrice = candle[4].floatValue
                        
                        // bat dau tinh toan cho do thi x y
                        let deltaOfMaxMinPrice = Double((currentMaxPrice - currentMinPrice)) * pow(10,Double(scale))
                        let heightOfView = self.vCandle.frame.height // chieu cao cua khung
                        let widthOfView = self.vCandle.frame.width - 10
                        // xu ly du lieu cho phu hop voi do thi map voi kline
                        
                        let bufferOpenPrice = Float(heightOfView) - ((kline.openPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                        let bufferHighPrice = Float(heightOfView) - ( (kline.highPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                        let bufferLowPrice = Float(heightOfView) - ( (kline.lowPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                        let bufferClosePrice = Float(heightOfView) - ( (kline.closePrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                        let xPositionOfCandle: Float = Float((2/3)*widthOfView) - Float(Int(BUNGNEN)*i)
                        
                        
                        // start to draw
                        
                        let path = UIBezierPath()
                        path.lineWidth = CGFloat(self.lineWidth)
                        // tam thoi khong can high va low
//                        path.move(to: CGPoint(x:Int(xPositionOfCandle-(BUNGNEN - Float(self.lineWidth))/2), y:Int(bufferHighPrice))) // move toi diem high
//                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))/2), y: Double(bufferLowPrice))) // add line toi low
                        path.move(to: CGPoint(x:Int(xPositionOfCandle), y:Int(bufferOpenPrice))) // move toi diem open ben phai truc high
                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))), y: Double(bufferOpenPrice))) // add line toi open ben trai truc y
                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))), y: Double(bufferClosePrice))) // add line xuong close price
                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferClosePrice))) // add line quan ben kia truc high
                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferOpenPrice))) // add line xuong close
//                        path.close()
//                        path.close()
//                        path.stroke()
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.path = path.cgPath
                        // kiem tra neu open < = close thi stroke va fill la mau green con lai thi la red
                        if (kline.openPrice < kline.closePrice){
                            shapeLayer.strokeColor = UIColor.green.cgColor
                            shapeLayer.fillColor = UIColor.green.cgColor
                        } else {
                            shapeLayer.strokeColor = UIColor.red.cgColor
                            shapeLayer.fillColor = UIColor.red.cgColor
                        }
                        shapeLayer.lineWidth = CGFloat(self.lineWidth)
                        DispatchQueue.main.async {
                            
                            self.vCandle.layer.addSublayer(shapeLayer)
                            self.vCandle.setNeedsDisplay()
                        }
                        
                        i = i + 1 // lui vi tri x de ve candle tiep theo
//                        print("hihihihihihi",i)
                        //                q.signal()
//                        q.wait(timeout: .now() + 10)
//                        print("da xong 10 s roi do nghe")
                        
                        
                    }
                    print("da ve xong 725")
                    
                    print("cho nay sao")
                    q.signal()
                    
                })
               q.wait()
                q.wait(timeout: .now() + 1.5)
                DispatchQueue.main.async {
                    
                    self.vCandle.layer.sublayers = nil
                }
                
                
            }
            }
        }
    }
    
    
    func drawCandle (symbol: String) {
            var params = Parameters()
            params = ["symbol": symbol , "interval": defaults.string(forKey: "Interval")!, "limit":LIMIT_KLINES]
            apiHelper.getKlinesNew(url: BINANCE_URL_BASE + KLINE_URL, params: params) { (candleJSON) in
                // da co duoc bo du lieu tu day tro di la xu ly do thi va ve
                //----------------// xu ly do thi------------------------------------------
                // tim max va min trong so luong
    //            print(candleJSON.count)
                var currentMinPrice = candleJSON[0][3].floatValue
                var currentMaxPrice = candleJSON[0][2].floatValue
                for i in 1 ..< candleJSON.count {
                    if currentMaxPrice < candleJSON[i][2].floatValue {
                        currentMaxPrice = candleJSON[i][2].floatValue
                    } else {
                        //khong lam chi het
                    }
                    if currentMinPrice > candleJSON[i][3].floatValue {
                        currentMinPrice = candleJSON[i][3].floatValue
                    }else {
                        // khong lam chi het
                    }
                }
                //  tim gia tri scale gia tri lon nhat < 300
                var scale = -1
                var tempMaxPrice = currentMaxPrice
                // 300 la do cao max cua view
                while tempMaxPrice < 300 {
                    tempMaxPrice = tempMaxPrice * 10
                    scale = scale + 1
                }
                // tien hanh ve
                // item dau tien trong mang la cay nen moi nhat se co x = widthOfView
                // Do rong bung nen la 2 tuong ung voi toa do x cua cay nen la 2
                // Kiem tra interval de dua
                // chuyen json ve trat tu nguoc lai roi duyet lai
                //            let reverseCandleArray = []
                //            for item in candleArray.count {
                //                reverseCandleArray.append(item)
                //            }
                var i = 0
                // chuyen JSON vao trat tu nguoc lai de ve len bieu do
                for item in  candleJSON.reversed() {
                                        let candle = item.1
                                        var kline = Klines()
                                        // map du lieu vao kline
                                        kline.openTime = candleJSON[i][0].int64Value
                                        kline.openPrice = candle[1].floatValue
                                        kline.highPrice = candle[2].floatValue
                                        kline.lowPrice = candle[3].floatValue
                                        kline.closePrice = candle[4].floatValue
                                        
                                        // bat dau tinh toan cho do thi x y
                                        let deltaOfMaxMinPrice = Double((currentMaxPrice - currentMinPrice)) * pow(10,Double(scale))
                                        let heightOfView = self.vCandle.frame.height // chieu cao cua khung
                                        let widthOfView = self.vCandle.frame.width - 10
                                        // xu ly du lieu cho phu hop voi do thi map voi kline
                                        
                                        let bufferOpenPrice = Float(heightOfView) - ((kline.openPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let bufferHighPrice = Float(heightOfView) - ( (kline.highPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let bufferLowPrice = Float(heightOfView) - ( (kline.lowPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let bufferClosePrice = Float(heightOfView) - ( (kline.closePrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                    let xPositionOfCandle: Float = Float((2/3)*widthOfView) - Float((Int(BUNGNEN) + Int(self.lineWidth))*i)
                                        
                                        
                                        // start to draw
                                        
                                        let path = UIBezierPath()
                                        path.lineWidth = CGFloat(self.lineWidth)
                                        // tam thoi khong can high va low
                                        path.move(to: CGPoint(x:Int(xPositionOfCandle-(BUNGNEN - Float(self.lineWidth))/2), y:Int(bufferHighPrice))) // move toi diem high
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))/2), y: Double(bufferLowPrice))) // add line toi low
                                        path.move(to: CGPoint(x:Int(xPositionOfCandle), y:Int(bufferOpenPrice))) // move toi diem open ben phai truc high
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))), y: Double(bufferOpenPrice))) // add line toi open ben trai truc y
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))), y: Double(bufferClosePrice))) // add line xuong close price
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferClosePrice))) // add line quan ben kia truc high
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferOpenPrice))) // add line xuong close
                //                        path.close()
                //                        path.close()
                //                        path.stroke()
                                        let shapeLayer = CAShapeLayer()
                                        shapeLayer.path = path.cgPath
                                        // kiem tra neu open < = close thi stroke va fill la mau green con lai thi la red
                                        if (kline.openPrice < kline.closePrice){
                                            shapeLayer.strokeColor = UIColor.green.cgColor
                                            shapeLayer.fillColor = UIColor.green.cgColor
                                        } else {
                                            shapeLayer.strokeColor = UIColor.red.cgColor
                                            shapeLayer.fillColor = UIColor.red.cgColor
                                        }
                                        shapeLayer.lineWidth = CGFloat(self.lineWidth)
                                        DispatchQueue.main.async {
                                            
                                            self.vCandle.layer.addSublayer(shapeLayer)
                                            self.vCandle.setNeedsDisplay()
                                        }
                                        
                                        i = i + 1 // lui vi tri x de ve candle tiep theo
                //                        print("hihihihihihi",i)
                                        //                q.signal()
                //                        q.wait(timeout: .now() + 10)
                //                        print("da xong 10 s roi do nghe")
                                        
                                        
                                    }
            }
        }
    

          
  
    func btcLoopNew1() {
            let q = DispatchSemaphore(value:0)
            let queue1 = DispatchQueue(label: "kline")
            queue1.async {
                outerLoop:    while 0 < 1 {
                    let dsBtcTickers = DbHelperNew.sharedInstance.readBtcTicker()
                
                    for item in dsBtcTickers {
                        let symbol = item.symbol
                        DispatchQueue.main.async {
                            self.btnChuyenCoin.setTitle(symbol, for: .normal)
                        }
                        // kiem tra
                        if self.statusLoop {
                        
                        self.drawCanle(symbol: item.symbol) { (finishDrawing) in
                            if finishDrawing {
                                q.signal()
                            }
                        }
                    q.wait()
                    q.wait(timeout: .now() + 1.5)
                    DispatchQueue.main.async {
                        self.vCandle.layer.sublayers = nil
                        }
                        } else {
                            break outerLoop
                        }
                        
                    }
                }
            }
        }
    func btcLoopNew2 (indexBtc: Int) {
        var indexBtcTemp = indexBtc
        let q = DispatchSemaphore(value:0)
        let queue1 = DispatchQueue(label: "kline")
        queue1.async {
            let dsBtcTickers = DbHelperNew.sharedInstance.readBtcTicker()
            outerLoop:    while 0 < 1 {
//                self.indexBtc = 0
                
            
                for (index,item) in dsBtcTickers.enumerated() {
                    let symbol = item.symbol
                    DispatchQueue.main.async {
                        self.btnChuyenCoin.setTitle(symbol, for: .normal)
                    }
                    // kiem tra
                    if self.statusLoop {
                        // cho phep ve nhung cung phai ve cai index ta muon
                        if (index >= indexBtcTemp) {
                        
                    
                        self.drawCanle(symbol: item.symbol) { (finishDrawing) in
                            if finishDrawing {
                                q.signal()
                            }
                        }

                        q.wait()
                            q.wait(timeout: .now() + 1)
                        DispatchQueue.main.async {
//                            self.vCandle.layer.sublayers = nil
                            self.vCandle.layer.sublayers = nil
                            
                            }
                            self.indexBtc = index
                        } else {
                            // deo lam chi ca
                        }
                        
                        
                    } else {
                        // luu lai gia tri index
//                        self.indexBtc = index
                        break outerLoop
                    }
                    
                    
                }
                // tra lai gia tri ban dau cho indexBtc
                indexBtcTemp = 0
            }
        }
        
    }
    
    
    func drawCanle(symbol: String, completionHandler: @escaping (Bool) -> Void) {
        
            var params = Parameters()
            params = ["symbol": symbol , "interval": defaults.string(forKey: "Interval")!, "limit":LIMIT_KLINES]
            apiHelper.getKlinesNew(url: BINANCE_URL_BASE + KLINE_URL, params: params) { (candleJSON) in
                // da co duoc bo du lieu tu day tro di la xu ly do thi va ve
                //----------------// xu ly do thi------------------------------------------
                // tim max va min trong so luong
                
                var currentMinPrice = candleJSON[0][3].floatValue
                var currentMaxPrice = candleJSON[0][2].floatValue
                for i in 1 ..< candleJSON.count {
                    if currentMaxPrice < candleJSON[i][2].floatValue {
                        currentMaxPrice = candleJSON[i][2].floatValue
                    } else {
                        //khong lam chi het
                    }
                    if currentMinPrice > candleJSON[i][3].floatValue {
                        currentMinPrice = candleJSON[i][3].floatValue
                    }else {
                        // khong lam chi het
                    }
                }
                //  tim gia tri scale gia tri lon nhat < 300
                var scale = -1
                var tempMaxPrice = currentMaxPrice
                // 300 la do cao max cua view
                while tempMaxPrice < 300 {
                    tempMaxPrice = tempMaxPrice * 10
                    scale = scale + 1
                }
                // tien hanh ve
                // item dau tien trong mang la cay nen moi nhat se co x = widthOfView
                // Do rong bung nen la 2 tuong ung voi toa do x cua cay nen la 2
                // Kiem tra interval de dua
                // chuyen json ve trat tu nguoc lai roi duyet lai
                //            let reverseCandleArray = []
                //            for item in candleArray.count {
                //                reverseCandleArray.append(item)
                //            }
                var i = 0
                // chuyen JSON vao trat tu nguoc lai de ve len bieu do
               
                for item in  candleJSON.reversed() {
                    
                                        let candle = item.1
                                        var kline = Klines()
                                        // map du lieu vao kline
                                        kline.openTime = candle[0].int64Value
                                        kline.openPrice = candle[1].floatValue
                                        kline.highPrice = candle[2].floatValue
                                        kline.lowPrice = candle[3].floatValue
                                        kline.closePrice = candle[4].floatValue
                                        
                                        // bat dau tinh toan cho do thi x y
                                        let deltaOfMaxMinPrice = Double((currentMaxPrice - currentMinPrice)) * pow(10,Double(scale))

                                        let heightOfView = self.vCandle.frame.height // chieu cao cua khung
                                        let widthOfView = self.vCandle.frame.width - 10
                                        // xu ly du lieu cho phu hop voi do thi map voi kline
                                        
                                        let bufferOpenPrice = Float(heightOfView) - ((kline.openPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let bufferHighPrice = Float(heightOfView) - ( (kline.highPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let bufferLowPrice = Float(heightOfView) - ( (kline.lowPrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let bufferClosePrice = Float(heightOfView) - ( (kline.closePrice - currentMinPrice) * Float(pow( 10, Double(scale))) * Float(heightOfView) / Float(deltaOfMaxMinPrice))
                                        let xPositionOfCandle: Float = Float((2/3)*widthOfView) - Float((Int(BUNGNEN) + Int(self.lineWidth))*i)
                                       
                                        // start to draw
                                        
                                        let path = UIBezierPath()
                                        path.lineWidth = CGFloat(self.lineWidth)
                                        // tam thoi khong can high va low
                                        path.move(to: CGPoint(x:Int(xPositionOfCandle-(BUNGNEN - Float(self.lineWidth))/2), y:Int(bufferHighPrice))) // move toi diem high
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))/2), y: Double(bufferLowPrice))) // add line toi low
                                        path.move(to: CGPoint(x:Int(xPositionOfCandle), y:Int(bufferOpenPrice))) // move toi diem open ben phai truc high
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))), y: Double(bufferOpenPrice))) // add line toi open ben trai truc y
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle - (BUNGNEN - Float(self.lineWidth))), y: Double(bufferClosePrice))) // add line xuong close price
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferClosePrice))) // add line quan ben kia truc high
                                        path.addLine(to: CGPoint(x:Double(xPositionOfCandle) , y: Double(bufferOpenPrice))) // add line xuong close

                                        let shapeLayer = CAShapeLayer()
                                        shapeLayer.path = path.cgPath
                                        // kiem tra neu open < = close thi stroke va fill la mau green con lai thi la red
                                        if (kline.openPrice < kline.closePrice){
                                            shapeLayer.strokeColor = UIColor.green.cgColor
                                            shapeLayer.fillColor = UIColor.green.cgColor
                                        } else {
                                            shapeLayer.strokeColor = UIColor.red.cgColor
                                            shapeLayer.fillColor = UIColor.red.cgColor
                                        }
                                        shapeLayer.lineWidth = CGFloat(self.lineWidth)
                                        DispatchQueue.main.async {
                                            
                                            self.vCandle.layer.addSublayer(shapeLayer)
                                            self.vCandle.setNeedsDisplay()
                                        }
                                        
                                        i = i + 1 // lui vi tri x de ve candle tiep theo
                                                                                
                                    }
                            
                // ve xong roi thi bao completion
                completionHandler(true)
            }
        }
  

    
        
    

}



        

    
    
    
    






