//
//  BLEPeripheralListViewController.swift
//  GISTracker
//
//  Created by imac-3282 on 2023/11/22.
//

import UIKit
import CoreBluetooth

class BLEPeripheralListViewController: UIViewController {
    
    @IBOutlet weak var peripheralListTableView: UITableView!
    @IBOutlet weak var testButton: UIButton!
    
    let bluetoothServices = BluetoothServices.shared
    
    var BLEPeripherals: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        setupBluetooth()
        setupTableView()
    }
    
    func setupBluetooth() {
        bluetoothServices.delegate = self
        bluetoothServices.startScan()
    }
    
    func setupTableView() {
        peripheralListTableView.delegate = self
        peripheralListTableView.dataSource = self
        
        peripheralListTableView.register(UINib(nibName: "PeripheralNameTableViewCell", bundle: nil),
                                         forCellReuseIdentifier: PeripheralNameTableViewCell.identifier)
    }
    
    @IBAction func test(_ sender: Any) {
        let data = "$hsgdjfjahsdjkfh".data(using: .ascii)
        bluetoothServices.writeValue(type: .withoutResponse, data: data!)
    }
}

extension BLEPeripheralListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PeripheralNameTableViewCell.identifier,
                                                       for: indexPath) as? PeripheralNameTableViewCell else {
            fatalError("PeripheralNameTableViewCell Can't Loaded！")
        }
        
        cell.nameLabel.text = BLEPeripherals[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        bluetoothServices.connectPeripheral(peripheral: BLEPeripherals[indexPath.row])
        
//        let nextVC = LogViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension BLEPeripheralListViewController: BluetoothSrvicesDelegate {
    func getBLEPeripherals(peripherals: [CBPeripheral]) {
        self.BLEPeripherals = peripherals
        
        DispatchQueue.main.async {
            self.peripheralListTableView.reloadData()
        }
    }
}
