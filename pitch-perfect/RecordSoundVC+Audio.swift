//
//  RecordSoundVC+Audio.swift
//  pitch-perfect
//
//  Created by Amadeu Andrade on 07/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

extension RecordSoundViewController {
    
    struct RecordingAlerts {
        static let PermissionDenied = "Permission to record not granted."
        static let RecordingFailed = "For some unknown reason your recording has failed."
        static let InactiveSession = "For some unknown reason the audio session failed."
    }

    func askUserPermissionToUseMicro() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        if (recordingSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                } else {
                    print("Permission to record not granted")
                    self.permissionFailed()
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
            permissionFailed()
        }
    }
    
    func permissionFailed() {
        self.recordBtn.enabled = false
        self.recordLbl.text = "Please ensure the app has access to your microphone."
        showAlert("Permission Denied", message: RecordingAlerts.PermissionDenied)
    }
    
    func getDocumentsDirectory() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.m4a"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        return filePath!
    }
    
    func setupAndRunRecorder() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: getDocumentsDirectory(), settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            print("recording failed!")
            showAlert("Recording Failed", message: RecordingAlerts.RecordingFailed)
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Can't inactive audio session!")
            showAlert("Audio Session", message: RecordingAlerts.InactiveSession)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
