//
//  LogViewController.swift
//  GISTracker
//
//  Created by imac-3282 on 2023/11/27.
//

import UIKit

class LogViewController: UIViewController {

    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var log: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupUI() {
        
    }

    private func setTableView() {
        logTableView.delegate = self
        logTableView.dataSource = self
        
        logTableView.register(UINib(nibName: "LogTableViewCell", bundle: nil),
                              forCellReuseIdentifier: LogTableViewCell.identifier)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
    }
}

extension LogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell",
                                                 for: indexPath) as? LogTableViewCell else {
            fatalError("PeripheralNameTableViewCell Can't Loaded！")
        }
        
        return cell
    }
    
    
}
