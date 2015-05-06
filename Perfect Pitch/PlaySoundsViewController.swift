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
    // audioPlayerNode plays buffers or segemnts of audio files
    var audioPlayerNode:AVAudioPlayerNode!
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
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        println("Play Slow")
    }

    @IBAction func playFastAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        println("Play Fast")
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
       playAudioWithVariablePitch(750)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-750)
    }

    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
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
        audioPlayer.stop()
        if audioPlayerNode != nil {
            audioPlayerNode.stop()
        }

        println("Stop")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
