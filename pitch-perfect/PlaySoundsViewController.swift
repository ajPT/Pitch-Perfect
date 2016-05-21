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
    
    @IBAction func playSoundEffect(sender: UIButton) {
        if sender.tag == 0 {
            playSound(rate: 0.5)
        } else if sender.tag == 1 {
            playSound(rate: 1.5)
        } else if sender.tag == 2 {
            playSound(pitch: 1000)
        } else if sender.tag == 3 {
            playSound(pitch: -1000)
        } else if sender.tag == 4 {
            playSound(echo: true)
        } else if sender.tag == 5 {
            playSound(reverb: true)
        }
    }

    @IBAction func onStopPressed(sender: AnyObject) {
        stopAudio()
    }

}
