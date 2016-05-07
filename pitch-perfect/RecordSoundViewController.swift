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
        askUserPermissionToUseMicro()
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
        setupAndRunRecorder()
    }
    
    @IBAction func onStopRecPressed(sender: AnyObject) {
        stopRecording()
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
