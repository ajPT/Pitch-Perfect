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
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }

    @IBAction func onSlowPressed(sender: AnyObject) {
        playSound(rate: 0.5)
    }
    
    @IBAction func onFastPressed(sender: AnyObject) {
        playSound(rate: 1.5)
    }
    
    @IBAction func onChipmunkPressed(sender: AnyObject) {
        playSound(pitch: 1000)
    }
    
    @IBAction func onDarthVaderPressed(sender: AnyObject) {
        playSound(pitch: -1000)
    }
    
    @IBAction func onEchoPressed(sender: AnyObject) {
        playSound(echo: true)
    }
    
    @IBAction func onReverbPressed(sender: AnyObject) {
        playSound(reverb: true)
    }
    
    @IBAction func onStopPressed(sender: AnyObject) {
        stopAudio()
    }

}
