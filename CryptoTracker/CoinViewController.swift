//
//  CoinViewController.swift
//  CryptoTracker
//
//  Created by Fabio Quintanilha on 5/29/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHeight : CGFloat = 300
private let imageSize : CGFloat = 100
private let priceLabelHeight : CGFloat = 25.0

class CoinViewController: UIViewController, CoinDataDelegate {
    
    var chart = Chart()
    var coin : Coin?
    var priceLabel = UILabel()
    var youOwnLabel = UILabel()
    var worthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoinData.shared.delegate = self
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        
        if let coin = coin {
            title = coin.symbol
            
            chart.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
            chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1) }
            chart.xLabels = [0, 10, 20, 30, 40, 50, 60]
            chart.xLabelsFormatter = { String (Int(round(60 - $1))) + "d"}
            view.addSubview(chart)
            
            let imageView = UIImageView(frame: CGRect(x: view.frame.size.width / 2 - imageSize / 2, y: chartHeight + 20, width: imageSize, height: imageSize))
            imageView.image = coin.image
            view.addSubview(imageView)
            
            priceLabel.frame = CGRect(x: 0, y: (chartHeight + imageSize) + 30, width: view.frame.size.width, height: priceLabelHeight)
            priceLabel.textAlignment = .center
            view.addSubview(priceLabel)
            
            youOwnLabel.frame = CGRect(x: 0, y: (chartHeight + imageSize + (priceLabelHeight * 2)) + 30, width: view.frame.size.width, height: priceLabelHeight)
            youOwnLabel.textAlignment = .center
            youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(youOwnLabel)
            
            worthLabel.frame = CGRect(x: 0, y: (chartHeight + imageSize + (priceLabelHeight * 4)) + 30, width: view.frame.size.width, height: priceLabelHeight)
            worthLabel.textAlignment = .center
            worthLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(worthLabel)
            
            coin.getHistoricalData()
            newPrices()
        }
    }
    
    @objc func editTapped() {
        if let coin = coin {
            let alert = UIAlertController(title: "How much \(coin) do you own?", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "0.5"
                textField.keyboardType = .decimalPad
                
                if self.coin?.amount != 0.0 {
                    textField.text = String(coin.amount)
                }
            }
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                if let text = alert.textFields?[0].text {
                    if let amount = Double(text) {
                        self.coin?.amount = amount
                        self.newPrices()
                    }
                }
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            series.color = ChartColors.orangeColor()
            chart.add(series)
        }
    }
    
    func newPrices() {
        if let coin = coin {
            priceLabel.text = coin.priceAsString()
            worthLabel.text = coin.amountAsString()
            youOwnLabel.text = " You own: \(coin.amount) \(coin.symbol)"
        }
    }

}
