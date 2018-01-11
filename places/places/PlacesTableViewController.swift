//
//  PlacesTableViewController.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit
import os.log

class PlacesTableViewController: UITableViewController {
    
    //MARK: Properites
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, self]
        }
        if firstLoad {
            if let savedPlaces = loadPlaces() {
                places += savedPlaces
                firstLoad = false
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "PlacesTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PlacesTableViewCell else {
            fatalError("dequeue error")
        }
        
        let place = places[indexPath.row]
        
        cell.labelCell.text = place.name
        cell.photoCell.image = place.photo

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descVC = storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        descVC.placeIndex = indexPath.row
        navigationController?.pushViewController(descVC, animated: true)
    }
    //MARK: Actions
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let itemToMove = places[fromIndexPath.row]
        places.remove(at: fromIndexPath.row)
        places.insert(itemToMove, at: toIndexPath.row)
        savePlaces()
    }
    
    //MARK: Private Methods
    
    private func savePlaces()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(places, toFile: Place.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Places successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save places", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPlaces() -> [Place]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Place.ArchiveURL.path) as? [Place]
    }
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
