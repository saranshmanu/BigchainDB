//
//  ViewController.swift
//  BigchainDB Web Socket
//
//  Created by Saransh Mittal on 05/03/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import SwiftWebSocket
import MapKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var map: MKMapView!
    var transactions = [NSDictionary]()
    var transactionInformation = [NSDictionary]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    var shownIndexes : [IndexPath] = []
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            cell.transform = CGAffineTransform(translationX: 0, y:0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table", for: indexPath) as! TableViewCell
        cell.transactionID.text = transactions[indexPath.row]["transaction_id"] as! String
        cell.assetID.text = transactions[indexPath.row]["asset_id"] as! String
        cell.blockID.text = transactions[indexPath.row]["block_id"] as! String
        cell.longitude.text = String(describing: transactionInformation[indexPath.row]["longitude"]!)
        cell.latitude.text = String(describing: transactionInformation[indexPath.row]["latitude"]!)
        cell.date.text = transactionInformation[indexPath.row]["date"] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transactionTable.deselectRow(at: indexPath, animated: true)
    }

    @IBOutlet weak var transactionTable: UITableView!

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
        map.mapType = MKMapType.standard
        let socket = WebSocket("ws://139.59.12.96:59985/api/v1/streams/valid_transactions")
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
            Alamofire.request("http://139.59.12.96:59984/api/v1/transactions/" + String(describing: x!["asset_id"]!)).responseJSON{
                response in
                let x:NSDictionary = response.result.value! as! NSDictionary
                let y:NSDictionary = x["metadata"] as! NSDictionary
                do{
                    if (y["latitude"] != nil) && (y["longitude"] != nil) && (y["datetime"] != nil) {
                        let latitude:CLLocationDegrees = Double(y["latitude"] as! String)!
                        let longitude:CLLocationDegrees = Double(y["longitude"] as! String)!
                        let d = y["datetime"] as! String
                        let y = [
                            "latitude":latitude,
                            "longitude":longitude,
                            "date":d
                            ] as [String : Any]
                        self.transactionInformation = [y as NSDictionary] + self.transactionInformation
                        self.setMap(latitude: latitude, longitude: longitude, date: d)
                        self.transactionTable.reloadData()
                    }
                } catch {
                    // do nothing
                }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

