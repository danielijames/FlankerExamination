//
//  scoreController.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/8/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import UIKit

class scoreController: UIViewController {
    
    var averageResponse: Double?
    var score: Int?

    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scorelabel.text = "Score: \(String(describing: score ?? 0))/20"
        timeLabel.text = "Avg. Response Time: \(String(describing: (averageResponse ?? 1000))) ms"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
