//
//  schoolViewController.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/7/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import UIKit

class schoolViewController: UITableViewController {
    
    let jManager = ServerRequests.shared
    var schoolId: Int = 0
    var ID: Int = 0
    var schoolsFetched = [School]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jManager.fetchSchools { (res) in
            switch res {
            case.failure(let err):
                print("Fetching Schools Failed with Error ->", err)
            case.success(let SchoolsFetched):
                self.schoolsFetched = SchoolsFetched
            }
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schoolsFetched.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! selectSchoolCell
        cell.school.text = schoolsFetched[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        headerText.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        headerText.text = "Select Your School"
        headerText.textAlignment = .center
        headerText.font = UIFont(name: "Avenir Next", size: 30)
        headerText.font = UIFont.boldSystemFont(ofSize: 30)
        return headerText
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.schoolId = schoolsFetched[indexPath.row].id
        print("SCHOOL ID ->",self.schoolId)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "cellSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 125
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is schoolViewController {
        let destinationVC = segue.destination as! gameView
            destinationVC.ID = self.ID
            destinationVC.schoolId = self.schoolId
            print("destinationVC.schoolId", destinationVC.schoolId)
        }
    }
    
}
