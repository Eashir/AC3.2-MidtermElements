//
//  DetailViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Eashir Arafat on 12/8/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    

    @IBOutlet weak var electrons: UILabel!
    @IBOutlet weak var density: UILabel!
    @IBOutlet weak var discoveryYear: UILabel!
    @IBOutlet weak var boilingPoint: UILabel!
    @IBOutlet weak var meltingPoint: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var elementImageView: UIImageView!
    var element: Element?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementImageView.alpha = 0.4
        self.title = element?.name
       
        name.text = "Name: " + (element?.name)!
        symbol.text = "Symbol: " + (element?.symbol)!
        weight.text = "Weight: " + String(describing: (element?.weight)!)
        meltingPoint.text = "MeltingPoint: " + String(describing: (element?.meltingPoint)! )
        boilingPoint.text = "BoilingPoint: " + String(describing:
            (element?.boilingPoint)! )
        discoveryYear.text = "Found: " + (element?.discoveryYear)!
        density.text = "Density: " + String(describing: (element?.density)!)
        electrons.text = "Electrons: " + (element?.electrons)!
        name.textColor = element?.uiColor
        symbol.textColor = element?.uiColor
        weight.textColor = element?.uiColor
        meltingPoint.textColor = element?.uiColor
        boilingPoint.textColor = element?.uiColor
        
    }

   
    @IBAction func clickToPost(_ sender: UIButton) {
        if sender.isEnabled {
            APIRequestManager.manager.postRequest("https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites", data:  [
                "my_name": "Eashir Arafat",
                "favorite_element": "\(element?.symbol)"
                
                ])
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
