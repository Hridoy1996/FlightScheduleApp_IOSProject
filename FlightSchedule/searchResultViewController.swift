//
//  searchResultViewController.swift
//  FlightSchedule
//
//  Created by  Hridoy  on 11/30/18.
//  Copyright © 2018  Hridoy . All rights reserved.
//

import UIKit
import Foundation
import SQLite
import UserNotifications
struct  valolagena : Decodable{
    //let status: String?
    let departure: Departure
   
    let arrival: Arrival
   
    let airline: Airline
   let flight: Flight
    let status: String?
}

struct Departure: Decodable {
    let iataCode: String?
    let scheduledTime: String?
}
struct Arrival: Decodable{
    let iataCode: String?
    let estimatedRunway: String?
}

struct Airline: Decodable {
    let iataCode: String?
 
}
struct Flight: Decodable {
   
    let number : String?
}


class searchResultViewController: UIViewController {
    @IBOutlet weak var airlinetitle: UILabel!
    @IBOutlet weak var fromtitle: UILabel!
    @IBOutlet weak var totitle: UILabel!
    @IBOutlet weak var flighttitle: UILabel!
    @IBOutlet weak var statustitle: UILabel!
    @IBOutlet weak var depdatetitle: UILabel!
    @IBOutlet weak var arrdatetitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: { didAllow , error in })
       
        
        airlinetitle.text = UserDefaults.standard.string(forKey: "a")
        fromtitle.text = UserDefaults.standard.string(forKey: "f")
        totitle.text = UserDefaults.standard.string(forKey: "t")
        
        let str = UserDefaults.standard.string(forKey: "destination")!
        let jsonUrlString = "https://aviation-edge.com/v2/public/timetable?key=2d86eb-702697&iataCode="+str+"&type=arrival"
        print(jsonUrlString)
        guard   let url = URL(string: jsonUrlString)
            else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data,response,err) in
            
            guard let data = data else {return}
            do {
                let valolage = try
                    JSONDecoder().decode([valolagena].self, from: data)
                for india in valolage
                {
                    let tmp = india.airline.iataCode!
                    let tmp2 = UserDefaults.standard.string(forKey: "airline")!
                    if(( tmp.elementsEqual(tmp2)
                        == true ))
                        {
                           let tmp3 = india.departure.iataCode!
                           let tmp4 = UserDefaults.standard.string(forKey: "from")!
                            if(( tmp3.elementsEqual(tmp4)
                                == true ))
                            {
                                self.statustitle.text = india.status
                                self.flighttitle.text = india.flight.number
                                self.depdatetitle.text = india.departure.scheduledTime
                                self.arrdatetitle.text = india.arrival.estimatedRunway
                                print(india);
                                break;
                                
                            }
                        }
        
                    }
                }
            
            catch let jsonErr{
                print("error ",jsonErr)
            }
            
            }.resume()
    }
        // Do any additional setup after loading the view.
    @IBAction func reminder(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title  = "Alerm"
        content.subtitle = ""
        content.body = "Tap to see what happened!"
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 12, repeats: false)
        let request = UNNotificationRequest(identifier: "timeDone",content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
