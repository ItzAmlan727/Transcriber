//
//  ViewController.swift
//  Transcriber
//
//  Created by Amlan Jyoti on 26/10/21.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func buttonClicked(_ sender: UIButton) {
        requestRecordPermission()
    }

    func requestRecordPermission(){
        AVAudioSession.sharedInstance().requestRecordPermission() {
            [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    // GET THE TRANSCTIPITION PERMISSSION
                    self.requestTranscribePermission()
                }else {
                    //error
                }
            }
        }
    }
    func requestTranscribePermission(){
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    //get the permissions
                    self.dismiss(animated: true, completion: nil)
                }else {
                    //not allowed
                    self.showError()
                    return
                }
            }
        }
        
    }
    
    func showError() {
        self.view.backgroundColor = .blue
        self.button.isEnabled = false
        UIView.animate(withDuration: 1.0) {
            self.button.alpha = 0.3
        }
        return
    }
   

}

