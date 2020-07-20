//
//  ViewController.swift
//  AppMusic
//
//  Created by Zalora on 7/6/20.
//  Copyright © 2020 Dang Phong. All rights reserved.
//

import UIKit
import AVFoundation
var isMix = false
var rondomInt = 0
import MediaPlayer
var nowPlayingInfo = [String : Any] ()
class ViewController: UIViewController ,AVAudioPlayerDelegate  {

    
    
    func prapareSong(){
        do{
            let audioPath = Bundle.main.path(forResource: songList[activeSong], ofType: ".mp3")
                      try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                      audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
           
                   
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func getSongs()  {
        
               let folderUrl = URL(fileURLWithPath: Bundle.main.resourcePath!)
            do{
                let path = try FileManager.default.contentsOfDirectory(at: folderUrl,includingPropertiesForKeys: nil,options: .skipsHiddenFiles)
                for song_ in path{
                    var songName = song_.absoluteString
                    if songName.contains(".mp3")
                    {
                        let finfString = songName.components(separatedBy: "/")
                        songName = finfString[finfString.count - 1]
                        songName = songName.replacingOccurrences(of: "%20", with: " ")
                        songName = songName.replacingOccurrences(of: ".mp3", with: "")
                        songList.append(songName)
                        print(songName)
                    }
                }
            }
        
            catch
            {
                print("err")
            }
    }

    
    
}
extension UIView{
    func anchor(top : NSLayoutYAxisAnchor?
                ,left : NSLayoutXAxisAnchor?,
                 bottom : NSLayoutYAxisAnchor? ,
                 rigth: NSLayoutXAxisAnchor?,
                 marginTop : CGFloat ,
                 marginLeft : CGFloat ,
                marginBottom: CGFloat
                ,marginRigth : CGFloat ,
                 width : CGFloat ,
                 heigth : CGFloat
    
    )  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: marginTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: marginLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -marginBottom).isActive = true
        }
        if let rigth = rigth {
            self.rightAnchor.constraint(equalTo: rigth, constant: -marginRigth).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if heigth != 0{
            heightAnchor.constraint(equalToConstant: heigth).isActive = true
        }
    }
    
}

