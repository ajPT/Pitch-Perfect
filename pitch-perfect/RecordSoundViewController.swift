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
    var timer: NSTimer!
    var counter = 0
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordLbl: UILabel!
    @IBOutlet weak var stopRecBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        askUserPermissionToUseMicro()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        recordBtn.enabled = true
        stopRecBtn.enabled = false
        recordLbl.text = "Tap to record"
    }

    @IBAction func onRecordPressed(sender: UIButton!) {
        recordBtn.enabled = false
        stopRecBtn.enabled = true
        startTimer()
        setupAndRunRecorder()
    }
    
    @IBAction func onStopRecPressed(sender: AnyObject) {
        stopRecording()
        stopTimer()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording")
        if flag {
            performSegueWithIdentifier("openPlaySoundsView", sender: audioRecorder.url)
        } else {
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
