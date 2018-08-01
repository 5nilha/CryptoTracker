//
//  CryptoTableViewController.swift
//  CryptoTracker
//
//  Created by Fabio Quintanilha on 5/28/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit

class CryptoTableViewController: UITableViewController, CoinDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        CoinData.shared.getPrices()
    }

    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegate = self
        tableView.reloadData()
    }
    
    
    func newPrices() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CoinData.shared.coins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let coin = CoinData.shared.coins[indexPath.row]

        cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
        cell.imageView?.image = coin.image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coinVC = CoinViewController()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true) 
    }
    
    
}
