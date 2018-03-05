//
//  ViewController.swift
//  BigchainDB macOS
//
//  Created by Saransh Mittal on 05/03/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import Cocoa
import SwiftWebSocket
import MapKit
import Alamofire

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var transactionTable: NSTableView!
    @IBOutlet weak var map: MKMapView!
    
    var transactions = [NSDictionary]()
    func numberOfRows(in tableView: NSTableView) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""

        if tableColumn == tableView.tableColumns[0] {
            text = transactions[row]["asset_id"] as! String
            cellIdentifier = "asset"
        } else if tableColumn == tableView.tableColumns[1] {
            text = transactions[row]["transaction_id"] as! String
            cellIdentifier = "transaction"
        } else if tableColumn == tableView.tableColumns[2] {
            text = transactions[row]["block_id"] as! String
            cellIdentifier = "block"
        }

        if let cell = transactionTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTable.delegate = self
        transactionTable.dataSource = self
//        map.mapType = MKMapType.standard
        
        let socket = WebSocket("wss://test.bigchaindb.com/api/v1/streams/valid_transactions")
        socket.event.open = {
            print("opened")
        }
        socket.event.close = { code, reason, clean in
            print("closed")
        }
        socket.event.error = { error in
            print("error \(error)")
        }
        socket.event.message = { message in
            let x = self.convertToDictionary(text: String(describing: message))
            self.transactions = [x as! NSDictionary] + self.transactions
            Alamofire.request("https://test.bigchaindb.com/api/v1/transactions/" + String(describing: x!["asset_id"]!)).responseJSON{
                response in
                let x:NSDictionary = response.result.value! as! NSDictionary
                let y:NSDictionary = x["metadata"] as! NSDictionary
                do{
                    if (y["latitude"] != nil) && (y["longitude"] != nil) && (y["datetime"] != nil) {
                        let latitude:CLLocationDegrees = Double(y["latitude"] as! String)!
                        let longitude:CLLocationDegrees = Double(y["longitude"] as! String)!
                        let d = y["datetime"] as! String
                        self.setMap(latitude: latitude, longitude: longitude, date: d)
                    }
                } catch {
                    // do nothing
                }
                self.transactionTable.reloadData()
            }
        }
    }
    
    func setMap(latitude:CLLocationDegrees, longitude:CLLocationDegrees, date:String){
        let location = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
        let span = MKCoordinateSpanMake(100.55, 100.55)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = date
        annotation.subtitle = ""
        map.addAnnotation(annotation)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

