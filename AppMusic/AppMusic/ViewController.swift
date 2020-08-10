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
var randomInt = 0
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
            if randomInt < songList.count - 1 {
                randomInt -= 1
                if randomInt < 0  {
                    randomInt = 0
                    return
                }
                activeSong = randomInt
                playThisSong(activeSong: songList[randomInt])
                time.text = ""
                totalTime.text = ""
                updateTime()
                getArtistInfo()
                audioPlayer.play()
                playBtn.setImage(UIImage(named: "pause"), for: .normal)
            }
            else{
                randomInt = 0
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
            if randomInt < songList.count - 1 {
                randomInt += 1
                activeSong = randomInt
                playThisSong(activeSong: songList[activeSong])
                time.text = ""
                totalTime.text = ""
                updateTime()
                getArtistInfo()
                audioPlayer.play()
                playBtn.setImage(UIImage(named: "pause"), for: .normal)
                
            }else{
                randomInt = 0
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
    func getCoverImage() {
           if let image = self.artistImage.image {
               nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size){
                   size in
                   return image
               }
           }
       }
    
    //MARK: Xử lý time song
    @objc func _slider () {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime =  TimeInterval(slider.value)
            audioPlayer.play()
        }else{
            audioPlayer.currentTime = TimeInterval(slider.value)
        }
    }
    func updateTime() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        slider.maximumValue = Float(audioPlayer.duration)
        totalTime.text = stringFormatterTimeInterval(interval: audioPlayer.duration) as String
    }
    func stringFormatterTimeInterval(interval : TimeInterval) ->NSString {
        let ti = NSInteger(interval)
        let second = ti % 60
        let minutes = ( ti / 60) % 60
        return NSString(format: "%0.2d:%0.2d", minutes,second)
    }
    @objc func update (_timer : Timer ) {
        slider.value = Float(audioPlayer.currentTime)
        time.text =  stringFormatterTimeInterval(interval: TimeInterval(slider.value)) as String
    }
    
    //MARK: Chuẩn bị nhạc
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
    
    //Lấy nhạc
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
    
    
    func getArtistInfo () {
        
        let audioPath = Bundle.main.path(forResource: songList[activeSong], ofType: ".mp3")
        let playerItem = AVPlayerItem(url: NSURL(fileURLWithPath: audioPath!) as URL)
        let metaDataList = playerItem.asset.commonMetadata
        for item in metaDataList {
            if item.commonKey!.rawValue == "title" {
                songTitle.text = item.stringValue!
                artistImage.image = UIImage(named: item.stringValue!)
            }
            if item.commonKey!.rawValue == "artist" {
                artistName.text = item.stringValue!
            }
        }
        
        nowPlayingInfo[MPMediaItemPropertyArtist] = artistName.text
        nowPlayingInfo[MPMediaItemPropertyTitle] = songList[activeSong]
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
    
    
    func playThisSong(activeSong : String)  {
        
        do {
            let audioPath = Bundle.main.path(forResource: activeSong, ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.prepareToPlay()
            randomInt = Int.random(in: 0...songList.count)
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func pauseSong(){
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
       
    //sử dụng ViewWillAppear chỉ để cập nhật dữ liệu trên biểu mẫu
    override func viewWillAppear(_ animated: Bool) {
        if audioPlayer.isPlaying {
            getArtistInfo()
            updateTime()
            playBtn.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
       override func viewDidLoad() {
           super.viewDidLoad()
           //add subview
           let playerIconsStack = UIStackView(arrangedSubviews: [backBtn,nextBtn,mix,playBtn])
           playerIconsStack.distribution = .fillEqually
           playerIconsStack.axis = .horizontal
           playerIconsStack.spacing = 10
           
           view.addSubview(playerIconsStack)
           
           playerIconsStack.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 20, marginBottom: 80, marginRigth: 20, width: 0, heigth: 0)
           
           view.addSubview(slider)
           
           slider.anchor(top: nil, left: view.leftAnchor, bottom: playerIconsStack.topAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 30, marginBottom: 12, marginRigth: 30, width: 0, heigth: 0)
           
           view.addSubview(time)
           time.anchor(top: nil, left: view.leftAnchor, bottom: slider.topAnchor, rigth: nil, marginTop: 0, marginLeft: 30, marginBottom: 8, marginRigth: 0, width: 0, heigth: 0)
           
           view.addSubview(totalTime)
           totalTime.anchor(top: nil, left: nil, bottom: slider.topAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 8, marginRigth: 30, width: 0, heigth: 0)
           
           
           let songInfoStack = UIStackView(arrangedSubviews: [songTitle,artistName])
           songInfoStack.axis = .vertical
           songInfoStack.alignment = .center
           songInfoStack.distribution = .equalCentering
           songInfoStack.spacing = 8
           
           view.addSubview(songInfoStack)
           songInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           
           songInfoStack.anchor(top: nil, left: nil, bottom: totalTime.topAnchor, rigth: nil, marginTop: 0, marginLeft: 0, marginBottom: 12, marginRigth: 0, width: 0, heigth: 0)

           view.addSubview(artistImage)
           
           artistImage.anchor(top: nil, left: view.leftAnchor, bottom: songInfoStack.topAnchor, rigth: view.rightAnchor, marginTop: 20, marginLeft: 20, marginBottom: 20, marginRigth: 20, width: self.view.frame.width, heigth: self.view.frame.height / 2)
           

    
           let button = UIBarButtonItem(image: UIImage(named: "list"), style: .plain, target: self, action: #selector(action))
           navigationItem.rightBarButtonItem = button
           navigationItem.title = "Music Player"
           
           getSongs()
           prapareSong()
           updateTime()
           getArtistInfo()
           getCoverImage()
                
           
       }
    @objc func action(){
        let controller = MusicList()
        navigationController?.pushViewController(controller, animated: true)
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

