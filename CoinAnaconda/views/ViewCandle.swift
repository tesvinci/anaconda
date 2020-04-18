//
//  ViewCandle.swift
//  CoinAnaconda
//
//  Created by TuanRv on 2/23/20.
//  Copyright © 2020 tesvinci. All rights reserved.
//

import Foundation
import UIKit
class ViewCandle: UIView {
    let squarePath = UIBezierPath()
    func draw1() {
        squarePath.move(to: CGPoint(x:100, y:100))
        squarePath.addLine(to: CGPoint(x:200, y:100))
        squarePath.addLine(to: CGPoint(x:200, y:200))
        squarePath.addLine(to: CGPoint(x:100, y:100))
        squarePath.close()
    }
}
