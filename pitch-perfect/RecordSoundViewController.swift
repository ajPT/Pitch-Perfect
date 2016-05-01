//
//  ViewController.swift
//  pitch-perfect
//
//  Created by Amadeu Andrade on 30/04/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!
    let session = AVAudioSession.sharedInstance()
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordLbl: UILabel!
    @IBOutlet weak var stopRecBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        recordBtn.enabled = true
        stopRecBtn.enabled = false
        recordLbl.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRecordPressed(sender: AnyObject) {
        recordBtn.enabled = false
        stopRecBtn.enabled = true
        recordLbl.text = "Recording in progress"
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func onStopRecPressed(sender: AnyObject) {
        audioRecorder.stop()
        try! session.setActive(false)        
    }


}

