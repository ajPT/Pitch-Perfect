//
//  PlaySoundsViewController.swift
//  pitch-perfect
//
//  Created by Amadeu Andrade on 30/04/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    
    var audioPlayer: AVAudioPlayer!
    
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: recordedAudioURL)
            audioPlayer.enableRate = true
            audioPlayer.prepareToPlay()
        } catch {
            print("Error getting the audio file")
        }
        
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        try! audioFile = AVAudioFile(forReading: recordedAudioURL)
        
    }
    

    @IBAction func onSlowPressed(sender: AnyObject) {
        if audioPlayer.playing {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func onFastPressed(sender: AnyObject) {
        if audioPlayer.playing {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func onChipmunkPressed(sender: AnyObject) {
        stopAudio()
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.prepare()
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    @IBAction func onDarthVaderPressed(sender: AnyObject) {
        stopAudio()
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.prepare()
        try! audioEngine.start()
        audioPlayerNode.play()

    }
    
    @IBAction func onEchoPressed(sender: AnyObject) {
        stopAudio()
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.MultiEcho1)
        audioEngine.attachNode(echoNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.prepare()
        try! audioEngine.start()
        audioPlayerNode.play()
    
    }
    
    @IBAction func onReverbPressed(sender: AnyObject) {
        stopAudio()
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.Cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attachNode(reverbNode)
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.prepare()
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    @IBAction func onStopPressed(sender: AnyObject) {
        stopAudio()
    }
    
    func stopAudio() {
        if audioPlayer.playing {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        
        if audioPlayerNode.playing {
            audioPlayerNode.stop()
        }
        
        if audioEngine.running {
            audioEngine.stop()
            audioEngine.reset()
        }

    
    }
    
    
}
