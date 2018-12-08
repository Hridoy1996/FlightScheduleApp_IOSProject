//
//  destinationViewController.swift
//  FlightSchedule
//
//  Created by  Hridoy  on 11/29/18.
//  Copyright © 2018  Hridoy . All rights reserved.
//

import UIKit
import SQLite
class destinationViewController: UIViewController {
  var database: Connection!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var tableviewid: UITableView!
    
    ///table for airplane
    let usersTable2 = Table("airport")
    let iid = Expression<Int>("iid")
    let iata = Expression<String>("iata")
    let airportname = Expression<String>("airportname")
    let countryname = Expression<String>("countryname")

    
    var countryNameArr = [String]()
    
    /* let countryNameArr = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize"]
     */
    var searchedCountry = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let  documentDirectory = try FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: true )
            let fileUrl = documentDirectory.appendingPathComponent("airport").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            self.database = database
            
        }
        catch{
            print("error")
        }
        do {
            let airport = try self.database.prepare(self.usersTable2)
            for airports in airport {
                
                countryNameArr.insert(airports[self.airportname], at: countryNameArr.endIndex)
                // print("userId: \(airports[self.iid]), aname: \(airports[self.airportname]), cname: \(airports[self.countryname]) ")
            }
        } catch {
            print(error)
        }
        print(countryNameArr)
        
        search.delegate = self        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func btntapped(_ sender: Any) {
        let from = search.text!
         UserDefaults.standard.set(from, forKey: "t")
        if search.text?.isEmpty ?? true
        {
            return
        }
        do {
            let airport = try self.database.prepare(self.usersTable2)
            for airports in airport {
                if(( from.elementsEqual(airports[self.airportname]))
                    == true )
                {
                    print(airports[self.iata])
                    UserDefaults.standard.set(airports[self.iata], forKey: "destination")
                }
                
                
                
                // countryNameArr.insert(airports[self.airportname], at: countryNameArr.endIndex)
                // print("userId: \(airports[self.iid]), aname: \(airports[self.airportname]), cname: \(airports[self.countryname]) ")
                
                
            }
            let despage = self.storyboard?.instantiateViewController(withIdentifier: "airlinesearchViewController") as! airlinesearchViewController
            self.present(despage,animated: true)        } catch {
                print(error)
        }
        
    }
    
}

extension destinationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return countryNameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchedCountry[indexPath.row]
        } else {
            cell?.textLabel?.text = countryNameArr[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            search.text = searchedCountry[indexPath.row]
        } else {
            search.text = countryNameArr[indexPath.row]
        }
        
    }
    
    
}

extension destinationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = countryNameArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableviewid.reloadData()
    }
    
    
    
    
}

