//
//  PlaySoundsVC+Audio.swift
//  pitch-perfect
//
//  Created by Amadeu Andrade on 07/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

extension PlaySoundsViewController {

    func setupAudio() {
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL)
            audioEngine = AVAudioEngine()
            audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attachNode(audioPlayerNode)
        } catch {
            print("Cannot grab the file")
            Helper().showAlert(self, title: "Audio File Error", message: Helper.PlayingAlerts.FileError)
        }
    }
    
    func playSound(rate rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        stopAudio()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        if let rate = rate {
            let applyRateEffect = AVAudioUnitTimePitch()
            applyRateEffect.rate = rate
            audioEngine.attachNode(applyRateEffect)
            audioEngine.connect(audioPlayerNode, to: applyRateEffect, format: nil)
            audioEngine.connect(applyRateEffect, to: audioEngine.outputNode, format: nil)
        }
        if let pitch = pitch {
            let applyPitchEffect = AVAudioUnitTimePitch()
            applyPitchEffect.pitch = pitch
            audioEngine.attachNode(applyPitchEffect)
            audioEngine.connect(audioPlayerNode, to: applyPitchEffect, format: nil)
            audioEngine.connect(applyPitchEffect, to: audioEngine.outputNode, format: nil)
        }
        if echo {
            let applyEchoEffect = AVAudioUnitDistortion()
            applyEchoEffect.loadFactoryPreset(.MultiEcho1)
            audioEngine.attachNode(applyEchoEffect)
            audioEngine.connect(audioPlayerNode, to: applyEchoEffect, format: nil)
            audioEngine.connect(applyEchoEffect, to: audioEngine.outputNode, format: nil)
        }
        if reverb {
            let applyReverbEffect = AVAudioUnitReverb()
            applyReverbEffect.loadFactoryPreset(.Cathedral)
            applyReverbEffect.wetDryMix = 50
            audioEngine.attachNode(applyReverbEffect)
            audioEngine.connect(audioPlayerNode, to: applyReverbEffect, format: nil)
            audioEngine.connect(applyReverbEffect, to: audioEngine.outputNode, format: nil)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch {
            print("Cannot start playing audio!")
            Helper().showAlert(self, title: "Audio Error", message: Helper.PlayingAlerts.PlayingAudioFailed)
        }
    }
    
    func stopAudio() {
        if audioPlayerNode.playing {
            audioPlayerNode.stop()
        }
        if audioEngine.running {
            audioEngine.stop()
            audioEngine.reset()
        }
    }

}