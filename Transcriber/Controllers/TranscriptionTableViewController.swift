//
//  TranscriptionTableViewController.swift
//  Transcriber
//
//  Created by Amlan Jyoti on 28/10/21.
//

import UIKit
import AVFoundation
import Speech
import CoreData

class TranscriptionTableViewController: UITableViewController {
    var transcription: [NSManagedObject] = [NSManagedObject] ()
    var reuseIdentifier = "transcriptionsTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        cheakPermissions()
     }
    override func viewWillAppear(_ animated: Bool) {
        if let result = CoreDataHelper().getTranscription() {
            transcription = result
        }
        tableView.reloadData()

    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell...
      //  cell.textLabel?.text = String(transc.value(forKey: "audioFileUrlString"))
        cell.textLabel?.text = "Error!"
        return cell
    }
    
    //MARK: - For disappearing the after the clicking one cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Permissions
    func cheakPermissions() {
        let recAuthorised = AVAudioSession.sharedInstance().recordPermission == .granted
        let transAuthorised = SFSpeechRecognizer.authorizationStatus() == .authorized
        let authorised = recAuthorised && transAuthorised
        if !authorised {
            if let vc = self.storyboard?.instantiateViewController(identifier: "PermissionsViewController") {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }

}
