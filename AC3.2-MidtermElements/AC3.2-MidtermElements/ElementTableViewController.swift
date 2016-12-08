//
//  ElementTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Eashir Arafat on 12/8/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class ElementTableViewController: UITableViewController {

    var elements: [Element] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Elements"

        APIRequestManager.manager.getData("https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements") { (data: Data?) in
            if let validData = data,
                let validElements = Element.getElements(from: validData) {
                self.elements = validElements
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    
    func getPixelColor(pos: CGPoint, uiImage: UIImage) -> UIColor {
        
        let ciImage = CIImage(image: uiImage)
        let CGImage = convertCIImageToCGImage(inputImage: ciImage!)
        
        let pixelData = CGImage?.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(uiImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath)
        
        let element = elements[indexPath.row]
        
        cell.textLabel?.text = element.name
        cell.detailTextLabel?.text = element.symbol + "(\(String(element.number)))" + " \(String(element.weight))"
        
        
        var pixelColor = element.uiColor
        APIRequestManager.manager.getData("https://s3.amazonaws.com/ac3.2-elements/\(element.symbol)_200.png") { (data: Data?) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                // Getting a color value from validImage
                var color = self.getPixelColor(pos: CGPoint(x: 150 , y: 150), uiImage: validImage)
                pixelColor = color
                DispatchQueue.main.async {
                    
                    cell.imageView?.image = validImage
                    cell.textLabel?.textColor = pixelColor
                    cell.detailTextLabel?.textColor = pixelColor
                    cell.setNeedsLayout()
                }
            }
        }
        // Configure the cell...

        return cell
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DetailViewController,
           let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            dvc.element = elements[indexPath.row]
            
            APIRequestManager.manager.getData("https://s3.amazonaws.com/ac3.2-elements/\(elements[indexPath.row].symbol).png") { (data: Data?) in
                if let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        dvc.elementImageView.image = validImage
                        
                    }
                }
            }
        }
    }
    

}
