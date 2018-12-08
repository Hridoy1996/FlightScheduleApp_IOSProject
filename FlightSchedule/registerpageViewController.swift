//
//  registerpageViewController.swift
//  FlightSchedule
//
//  Created by  Hridoy  on 11/22/18.
//  Copyright © 2018  Hridoy . All rights reserved.
//

import UIKit
import SQLite
class registerpageViewController: UIViewController {
      var database: Connection!
    
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let fname = Expression<String>("fname")
    let lname = Expression<String>("lname")
    let email = Expression<String>("email")
    let  password = Expression<String>("password")
    
    @IBOutlet weak var repeatpasswordtextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var emailaddresstextfield: UITextField!
    @IBOutlet weak var lastnametextfield: UITextField!
    @IBOutlet weak var firstpagetextfield: UITextField!
    override func viewDidLoad() {
      
        super.viewDidLoad()
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: true )
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            }
        catch{
            print("error")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signuptapped(_ sender: Any) {
        if (firstpagetextfield.text?.isEmpty)! || (lastnametextfield.text?.isEmpty)! ||
            (emailaddresstextfield.text?.isEmpty)! ||
            (passwordtextfield.text?.isEmpty)! ||
            (repeatpasswordtextfield.text?.isEmpty)!
                {
                    displayMessage(userMessage: "All fields are required to fill in")
                    print("somthing is empty")
                    return
        }
        if(( passwordtextfield.text?.elementsEqual(repeatpasswordtextfield.text!))
        != true )
        {
            displayMessage(userMessage: "Password don't match")
            print("bhai pass to mile nai")
            return
        }
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.fname)
            table.column(self.lname)
            table.column(self.email, unique: true)
            table.column(self.password)
        }
        do{
            try self.database.run(createTable)
            print("created")
        } catch{
            print(error)
        }
        let fname = firstpagetextfield.text!
        let lname = lastnametextfield.text!
        let email = emailaddresstextfield.text!
        let password = passwordtextfield.text!
        let insertUser = self.usersTable.insert(self.fname <- fname, self.lname <- lname, self.email <- email, self.password <- password)
        do{
            try self.database.run(insertUser)
         print("Inserted User")
        } catch {
             displayMessage(userMessage: "Email already exits!")
            print(error)
        }
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userId: \(user[self.id]), name: \(user[self.fname]), email: \(user[self.lname]), email: \( user[self.email]),password: \(user[self.password]) ")
            }
        } catch {
            print(error)
        }
        let regpage = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
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
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
