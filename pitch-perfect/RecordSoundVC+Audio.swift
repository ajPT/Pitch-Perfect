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

    //PERMISSION
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
        Helper().showAlert(self, title: "Permission Denied", message: Helper.RecordingAlerts.PermissionDenied)
    }
    
    //UTILS
    func getDocumentsDirectory() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.m4a"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        return filePath!
    }
    
    //RECORDER
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
            Helper().showAlert(self, title: "Recording Failed", message: Helper.RecordingAlerts.RecordingFailed)
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Can't inactive audio session!")
            Helper().showAlert(self, title: "Audio Session", message: Helper.RecordingAlerts.InactiveSession)
        }
    }
    
    //TIMER
    func startTimer() {
        stopTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(RecordSoundViewController.timerAction), userInfo: nil, repeats: true)
    }
    
    func timerAction() {
        counter += 1
        recordLbl.text = "Recording time: \(retrieveTimeFromCounter(counter))"
    }
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
        }
        counter = 0
    }
    
    func retrieveTimeFromCounter(counter: Int) -> String {
        let seconds = counter % 60
        let minutes = (counter / 60) % 60
        let hours = (counter / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
