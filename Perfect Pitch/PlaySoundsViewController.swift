//
//  PlaySoundsViewController.swift
//  Perfect Pitch
//
//  Created by Luc Peeters on 18/04/15.
//  Copyright (c) 2015 Digitmedia. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // audioPlayer: playback of audio data from a file or memory
    var audioPlayer:AVAudioPlayer!
    // Recorded Audio received from RecordSoundsViewController, format: NSURL
    var receivedAudio:RecordedAudio!
    
    // audioEngine processes the recorded audio file (pitch change & ...)
    var audioEngine:AVAudioEngine!
    
    // audioPlayerNode.scheduleFile requires AVAudioFile format: NSURL will be converted into AVAudioFile
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        // Convert NSURL into AVAudioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
        println("Play Slow")
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(1.5)
        println("Play Fast")
    }
    
    func stopAudioPlayerAndEngine() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
    
    func playAudioWithVariableRate(rate: Float) {
        stopAudioPlayerAndEngine()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(750)
        println("Play High Pitch")
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-750)
        println("Play Low Pitch")
    }

    func playAudioWithVariablePitch(pitch: Float) {
        stopAudioPlayerAndEngine()
        
        // audioPlayerNode plays buffers or segemnts of audio files
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudioPlayerAndEngine()
        println("Stop")
    }
}
