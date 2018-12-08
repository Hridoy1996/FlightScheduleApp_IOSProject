//
//  loginViewController.swift
//  FlightSchedule
//
//  Created by  Hridoy  on 11/22/18.
//  Copyright © 2018  Hridoy . All rights reserved.
//

import UIKit
import SQLite
import Foundation

struct airs : Decodable{
    let nameAirport: String?
    let codeIataAirport: String?
    let nameCountry: String?
    
}
struct airlines : Decodable{
    let nameAirline: String?
    let codeIataAirline: String?
}

class loginViewController: UIViewController {
    var database: Connection!
    
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let fname = Expression<String>("fname")
    let lname = Expression<String>("lname")
    let email = Expression<String>("email")
    let  password = Expression<String>("password")
  /// table for airline
    let airlinetable = Table("airlinetables")
    let iid = Expression<Int>("iid")
    let iataairline = Expression<String>("iataairline")
    let nameairline = Expression<String>("nameairline")
   
    @IBOutlet weak var usernametextfield: UITextField!
    @IBOutlet weak var userpasswordtextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("test",forKey:"key");
     //  var  searchedCountry = [String]()
    //    searchedCountry.insert("apple", at: searchedCountry.endIndex)
        
      //print(searchedCountry);
        
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: true )
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            self.database = database
            
    }
    catch{
    print("error")
    }
 
        //store airports
      /*
        do{
            let  documentDirectory = try FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: true )
            let fileUrl = documentDirectory.appendingPathComponent("airport").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            self.database = database
            
        }
        catch{
            print("error")
        }
      
        //  create table
        let createTable = self.usersTable2.create { (table) in
            table.column(self.iid, primaryKey: true)
            table.column(self.iata)
            table.column(self.airportname)
            table.column(self.countryname)
        }
        do{
            try self.database.run(createTable)
            print("created")
        } catch{
            print(error)
        }
        //json to parse airport information 2d86eb-702697
        
        let jsonUrlString = "https://aviation-edge.com/v2/public/airportDatabase?key=2d86eb-702697"
        print(jsonUrlString)
        guard   let url = URL(string: jsonUrlString)
            else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data,response,err) in
            
            guard let data = data else {return}
            do {
                let valolage = try
                    JSONDecoder().decode([airs].self, from: data)
                for india in valolage
                {
                    print(india)
                   // print(india.codelataAirport!+" lslsllslslsl")
                    
                    if india.codeIataAirport == nil {
                        //india.codelataAirport = "nil"
                        continue
                    }
                    if india.nameCountry == nil {
                        continue
                    }
                    if india.nameAirport == nil {
                        continue
                    }
                    
                  let   iata = india.codeIataAirport!
                  let  airportname = india.nameAirport!
                  let  countryname = india.nameCountry!
                    
                    
                    let insertUser2 = self.usersTable2.insert(self.iata <- iata, self.airportname <- airportname, self.countryname <- countryname) ;
                    
                    do{
                        try  self.database.run(insertUser2) ;
                        print("Inserted User") ;
                    } catch {
                        //         displayMessage(userMessage: "Email already exits!")
                        print(error)
                    }
                }
            }
            catch let jsonErr{
                print("error ",jsonErr)
            }
            
            }.resume()

        ///insertion to table
        
 
        do {
            let airport = try self.database.prepare(self.usersTable2)
            for airports in airport {
                print("userId: \(airports[self.iid]), aname: \(airports[self.airportname]), cname: \(airports[self.countryname]) ")
            }
        } catch {
            print(error)
        }        // Do any additional setup after loading the view.
 */
        //store airline
        /*
         do{
         let  documentDirectory = try FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: true )
         let fileUrl = documentDirectory.appendingPathComponent("airlinetables").appendingPathExtension("sqlite3")
         
         let database = try Connection(fileUrl.path)
         self.database = database
         
         }
         catch{
         print("error")
         }
         
         //  create table
         let createTable = self.airlinetable.create { (table) in
         table.column(self.iid, primaryKey: true)
         table.column(self.iataairline)
         table.column(self.nameairline)
        
         }
         do{
         try self.database.run(createTable)
         print("created")
         } catch{
         print(error)
         }
         //json to parse airport information 2d86eb-702697
         
        let jsonUrlString = "https://aviation-edge.com/v2/public/airlineDatabase?key=2d86eb-702697"
         print(jsonUrlString)
         guard   let url = URL(string: jsonUrlString)
         else { return }
         
         URLSession.shared.dataTask(with: url) {
         (data,response,err) in
         
         guard let data = data else {return}
         do {
         let valolage = try
         JSONDecoder().decode([airlines].self, from: data)
         for india in valolage
         {
         print(india)
         // print(india.codelataAirport!+" lslsllslslsl")
         
         if india.codeIataAirline == nil {
         //india.codelataAirport = "nil"
         continue
         }
         if india.nameAirline == nil {
         continue
         }
        
         
         let  iataairline = india.codeIataAirline!
         let  nameairline = india.nameAirline!
        
         
         let insertUser2 = self.airlinetable.insert(self.iataairline <- iataairline, self.nameairline <- nameairline) ;
         
         do{
         try  self.database.run(insertUser2) ;
         print("Inserted User") ;
         } catch {
         //         displayMessage(userMessage: "Email already exits!")
         print(error)
         }
         }
         }
         catch let jsonErr{
         print("error ",jsonErr)
         }
         
         }.resume()
         
         ///insertion to table
         
         
         do {
         let airline = try self.database.prepare(self.airlinetable)
         for airlines in airline {
         print("userId: \(airlines[self.iataairline]), aname: \(airlines[self.nameairline])")
         }
         } catch {
         print(error)
         }
 */
        // Do any additional setup after loading the view.
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signintapped(_ sender: Any) {
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userId: \(user[self.id]), name: \(user[self.fname]), email: \(user[self.lname]), email: \( user[self.email]),password: \(user[self.password]) ")
                
                if(( usernametextfield.text?.elementsEqual(user[self.email]))
                    == true ){
                    
                        if(( userpasswordtextfield.text?.elementsEqual(user[self.password]))
                            == true ){
                            let regpage = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewController") as! HomepageViewController
                            self.present(regpage,animated: true)
                            return
                    }
                        
                }
                
            }
        } catch {
            print(error)
        }
         displayMessage(userMessage: "Email or password invalid")
        
    }
    @IBAction func signuptapped(_ sender: Any) {
     let regpage = self.storyboard?.instantiateViewController(withIdentifier: "registerpageViewController") as! registerpageViewController
        self.present(regpage,animated: true)
    }
    func displayMessage(userMessage:String) -> Void  {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert",message:userMessage,preferredStyle:.alert)
            let OKAction = UIAlertAction(title: "OK",style: .default)
            { (action:UIAlertAction!)in
                print("OK button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true,completion: nil)
                }
                
            }
            alertController.addAction(OKAction)
            self.present(alertController,animated: true,completion: nil)
            
        }
        
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
