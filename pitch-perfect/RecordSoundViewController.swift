//
//  ViewController.swift
//  pitch-perfect
//
//  Created by Amadeu Andrade on 30/04/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordLbl: UILabel!
    @IBOutlet weak var stopRecBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        if (recordingSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
        
    
    }
    
    override func viewDidAppear(animated: Bool) {
        recordBtn.enabled = true
        stopRecBtn.enabled = false
        recordLbl.text = "Tap to record"
    }

    @IBAction func onRecordPressed(sender: UIButton!) {

        recordBtn.enabled = false
        stopRecBtn.enabled = true
        recordLbl.text = "Recording in progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.m4a"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
//        let recordingSession = AVAudioSession.sharedInstance()
//        try! recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//        try! recordingSession.setActive(true)
//        print("permission next:")
//        print(recordingSession.recordPermission())
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            //recording failed!
            print("falhei2")
//            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onStopRecPressed(sender: AnyObject) {
        audioRecorder.stop() //STOP audioRed
        //stop session
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording")
        if flag {
            performSegueWithIdentifier("openPlaySoundsView", sender: audioRecorder.url)
        } else {
            //recording failed!
            print("Recording failed!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openPlaySoundsView" {
            if let playSoundsVC = segue.destinationViewController as? PlaySoundsViewController {
                if let recordedAudioURL = sender as? NSURL {
                    playSoundsVC.recordedAudioURL = recordedAudioURL
                }
            }
        }
    }

}

