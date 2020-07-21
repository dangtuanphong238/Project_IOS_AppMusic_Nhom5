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

    //MARK: CREATE UI
    let playBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(play_pause), for: .touchUpInside)
        return btn
    }()
    
    let mix : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mix"), for: .normal)
        btn.addTarget(self, action: #selector(_mix), for: .touchUpInside)

        return btn
    }()
    
    let backBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(_back), for: .touchUpInside)

        return btn
    }()
    let nextBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "next"), for: .normal)
        btn.addTarget(self, action: #selector(_next), for: .touchUpInside)

        return btn
    }()
    
    
    let slider : UISlider = {
        
        let slider = UISlider()
        slider.maximumValue = 1000
        slider.minimumValue = 0
        slider.tintColor = UIColor.blue
        slider.addTarget(self, action: #selector(_slider), for: .touchDragInside)
        return slider
    }()

    let time : UILabel = {
       let label = UILabel()
        label.text = "-:--"
        label.font = UIFont.systemFont(ofSize : 12)
        label.textColor = .blue
        return label
    }()
    let totalTime : UILabel = {
         let label = UILabel()
          label.text = "-:--"
          label.font = UIFont.systemFont(ofSize : 12)
          label.textColor = .blue
          return label
      }()
    
    
    let artistName : UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.font = UIFont.systemFont(ofSize : 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let songTitle : UILabel = {
         let label = UILabel()
         label.text = "unknown"
         label.font = UIFont.systemFont(ofSize : 18)
         label.textColor = UIColor.black
         return label
     }()
    
    
    let artistImage : UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        return image
    }()

    //MARK: FUNCTION CONTROL
       @objc func play_pause ()
       {
           if audioPlayer.isPlaying {
               audioPlayer.pause()
               playBtn.setImage(UIImage(named: "play"), for: .normal)
               updateTime()
           }else{
               audioPlayer.play()
               getArtistInfo ()
               playBtn.setImage(UIImage(named: "pause"), for: .normal)
               updateTime()

           }
           
       }
      @objc func _mix ()
      {
       if isMix{
           isMix = false
           mix.setImage(UIImage(named: "mix"), for: .normal)
       }
       else{
           isMix = true
           mix.setImage(UIImage(named: "mix-selected"), for: .normal)
       }
    
       }
       @objc func _back ()
       {
           if isMix {
               if rondomInt < songList.count - 1 {
                   rondomInt -= 1
                   if rondomInt < 0  {
                       rondomInt = 0
                       return
                   }
                   activeSong = rondomInt
                   playThisSong(activeSong: songList[rondomInt])
                   time.text = ""
                   totalTime.text = ""
                   updateTime()
                   getArtistInfo()
                   audioPlayer.play()
                   playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }
               else{
                   rondomInt = 0
                   activeSong = 0
                   playThisSong(activeSong: songList[activeSong])
                   time.text = ""
                   totalTime.text = ""
                    updateTime()
                    getArtistInfo()
                     audioPlayer.play()
                   playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }
           }else{
               
               if activeSong < songList.count - 1 {
                   activeSong -= 1
                   if activeSong < 0 {
                       activeSong = 0
                       return
                   }
                   playThisSong(activeSong: songList[activeSong])
                   time.text = ""
                    totalTime.text = ""
                  updateTime()
                  getArtistInfo()
                  audioPlayer.play()
                   playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }
               else {
                   activeSong = 0
                   playThisSong(activeSong: songList[activeSong])
                   time.text = ""
                   totalTime.text = ""
                    updateTime()
                   getArtistInfo()
                  audioPlayer.play()
                 playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }
               
          }
       
       }
       @objc func _next ()
       {
           if isMix {
               if rondomInt < songList.count - 1 {
                   rondomInt += 1
                   activeSong = rondomInt
                      playThisSong(activeSong: songList[activeSong])
                               time.text = ""
                               totalTime.text = ""
                                updateTime()
                               getArtistInfo()
                              audioPlayer.play()
                             playBtn.setImage(UIImage(named: "pause"), for: .normal)
                   
               }else{
                   rondomInt = 0
                   activeSong = 0
                   playThisSong(activeSong: songList[activeSong])
                                   time.text = ""
                                   totalTime.text = ""
                                    updateTime()
                                   getArtistInfo()
                                  audioPlayer.play()
                                 playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }
               
           }else{
               if activeSong < songList.count - 1 {
                   activeSong += 1
                   if activeSong > songList.count {
                       activeSong = 0
                       return
                   }
                   playThisSong(activeSong: songList[activeSong])
                    time.text = ""
                   totalTime.text = ""
                    updateTime()
                    getArtistInfo()
                   getCoverImage()
                     audioPlayer.play()
                 playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }else{
                   activeSong = 0
                   playThisSong(activeSong: songList[activeSong])
                                                             time.text = ""
                                                             totalTime.text = ""
                                                              updateTime()
                                                             getArtistInfo()
                                                            audioPlayer.play()
                                                           playBtn.setImage(UIImage(named: "pause"), for: .normal)
               }
           }
           
        }
       @objc func _slider () {
           if audioPlayer.isPlaying {
               audioPlayer.stop()
               audioPlayer.currentTime =  TimeInterval(slider.value)
               audioPlayer.play()
           }else{
               audioPlayer.currentTime = TimeInterval(slider.value)
           }
       }
       
    
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

