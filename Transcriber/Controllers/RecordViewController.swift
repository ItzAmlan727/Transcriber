//
//  RecordViewController.swift
//  Transcriber
//
//  Created by Amlan Jyoti on 28/10/21.
//

import UIKit
import AVFoundation
import Speech
import CoreData

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    
    var audioRec: AVAudioRecorder?
    var recordedFileURL: URL!
    var textFileUrl: URL!
    var transcribed: Bool = false
    
    var audioPlayer: AVAudioPlayer?
// MARK: - For view appearing and disappearing
    override func viewDidLoad() {
        super.viewDidLoad()
        let utls = Utilities()
        textFileUrl = utls.getTextFileUrl()
        recordedFileURL = utls.getAudioFileUrl()
        print("AMLAN: " + recordedFileURL!.absoluteString)
        self.activityIndicator.startAnimating()
        recordAudio()
    }
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer?.stop()
//        if (transcribed) {
//          CoreDataHelper().storeTranscription(audioFileUrlString: String(recordedFileURL), textFileUrlString: String(textFileUrl))
//            
//        }
    }
    //MARK: -  for stopping the recording
    @IBAction func stopButtonClicked(_ sender: UIButton) {
        audioRec?.stop()
        sender.titleLabel?.text = "Finished"
        sender.isEnabled = false
        sender.alpha = 0.1
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 1.2) {
            self.activityIndicator.alpha = 0
        }
        
    }
    
    
    //MARK: - Audio Recording started
    func recordAudio() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRec = try AVAudioRecorder(url: recordedFileURL, settings: settings)
            audioRec?.delegate = self
            audioRec?.record()
        } catch let error {
            //Failed to record
            print("AMLAN: \(error)")
            recordingEnded(success: false)
        }
    }
    
    //MARK: - Audio Recording Ended
    func recordingEnded(success: Bool) {
        audioRec?.stop()
        if (success){
            do {
                //play And transcribe audio
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: recordedFileURL)
                audioPlayer?.play()
                transcribeAudio()
                print("Amlan PLAYING")
            } catch let error {
                print("AMLAN: \(error)" )
            }
        }
        
    }
    
    // MARK: - Audio delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recordingEnded(success: false)
        }else {
            recordingEnded(success: true)
        }
    }
    // MARK: - Transcribe Audio
    func transcribeAudio() {
        let recogniser = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: recordedFileURL)
        recogniser?.recognitionTask(with: request, resultHandler: { (result, error) in
            guard let result = result else {
                print("Amlan :" + String(error!.localizedDescription))
                return
            }
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                self.textView.text = text
                do {
                    try text.write(to: self.textFileUrl, atomically: true, encoding: String.Encoding.utf8)
                    self.transcribed = true
                } catch  {
                    

                }
            }
        })
    }
    
    
    
}
